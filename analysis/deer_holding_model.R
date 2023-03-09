# libraries
library(tidyverse)
library(lubridate)
library(googleCloudStorageR)
library(rstan)

# get data ----------------------------------------------------------------

gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))

# upstream passage
upstream_passage <- read_csv(gcs_get_object(object_name = "standard-format-data/standard_adult_upstream_passage.csv",
                                            bucket = gcs_get_global_bucket())) |> 
  mutate(stream = tolower(stream)) |> 
  filter(run %in% c("spring", NA, "not recorded")) |> 
  glimpse()

# holding
holding <- read_csv(gcs_get_object(object_name = "standard-format-data/standard_holding.csv",
                                   bucket = gcs_get_global_bucket()))|> 
  group_by(year) |> 
  summarise(count = sum(count, na.rm = T)) |> 
  glimpse()

# redd
redd <- read_csv(gcs_get_object(object_name = "standard-format-data/standard_annual_redd.csv",
                                bucket = gcs_get_global_bucket())) |> 
  group_by(year) |>
  rename(count = max_yearly_redd_count)

redd_daily <- read_csv(gcs_get_object(object_name = "standard-format-data/standard_daily_redd.csv",
                                      bucket = gcs_get_global_bucket())) |> 
  filter(run %in% c("spring", NA, "not recorded")) |> 
  mutate(count = 1) |> 
  group_by(year, stream) |> 
  summarise(count = sum(count)) |> glimpse()

# temperature

# threshold
# https://www.noaa.gov/sites/default/files/legacy/document/2020/Oct/07354626766.pdf 
threshold <- 21

temp <- read_csv(gcs_get_object(object_name = "standard-format-data/standard_temperature.csv",
                                bucket = gcs_get_global_bucket())) |>
  filter(stream == "sacramento river") |> 
  filter(month(date) %in% 6:7) |> 
  group_by(year(date)) |> 
  mutate(above_threshold = ifelse(mean_daily_temp_c > threshold, TRUE, FALSE)) |> 
  summarise(no_days_exceed_threshold = sum(above_threshold, na.rm = T)/length(above_threshold)) |> 
  rename(year = `year(date)`) |> 
  glimpse()




# join (1999:2020)
data <- holding |> 
  left_join(temp, by = "year") |> 
  filter(!is.na(no_days_exceed_threshold)) |> 
  glimpse()

# explore
data |> 
  ggplot(aes(x = count, y = no_days_exceed_threshold)) +
  geom_point()


holding_model <- stan_glm(count ~ no_days_exceed_threshold, data = data,
                       family = gaussian,
                       #prior_intercept = normal(22, 2),
                       #prior = normal(1, 0.5),
                       #prior_aux = exponential(0.0008),
                       chains = 4, iter = 5000*2, seed = 84735)

launch_shinystan(holding_model)

# poisson: https://mc-stan.org/rstanarm/articles/count.html
# also: https://stats.libretexts.org/Bookshelves/Introductory_Statistics/Book%3A_Introductory_Statistics_(OpenStax)/04%3A_Discrete_Random_Variables/4.07%3A_Poisson_Distribution

holding_model_poisson <- stan_glm(count ~ no_days_exceed_threshold, data = data,
                                  family = poisson,
                                  #prior_intercept = normal(22, 2),
                                  #prior = normal(1, 0.5),
                                  #prior_aux = exponential(0.0008),
                                  chains = 4, iter = 5000*2, seed = 84735)

launch_shinystan(holding_model_poisson)


# redd bayesian modeling --------------------------------------------------

redd_mill <- redd |> 
  filter(stream == "mill creek") |>
  group_by(year) |> 
  mutate(count = sum(count, na.rm = T)) |> 
  ungroup() |> 
  glimpse()

upstream_mill <- upstream_passage |> 
  filter(stream == "mill creek") |>
  mutate(year = year(date)) |> 
  group_by(year) |> 
  summarise(count = round(sum(count, na.rm = T), 0)) |> 
  filter(!is.na(year))

range(redd_mill$year)
range(upstream_mill$year)



# predicted spawning population (count) based on temperature and uncertainty

# TODO go through chapter 9 in bayes book with an eye toward fitting these data
# TODO try poisson distribution in stan_glm()

# prep data
N <- (max(upstream_mill$year) - min(upstream_mill$year) + 1)
redd_count <- redd_mill |> 
  filter(year %in% min(upstream_mill$year):max(upstream_mill$year)) |> 
  distinct(year, count) |> 
  pull(count)
year <- min(upstream_mill$year):max(upstream_mill$year)
upstream_count <- upstream_mill |> pull(count)
ratio_k <- upstream_count/redd_count

# write model
mill_upstream_redd_model <- "
  data {
    int N;
    vector[N] redd_count;
    vector[N] upstream_count;
  }
  parameters {
    real mu_k;
    real sigma_k;
    real mu_a;
    real sigma_a;
  }
  model {
    vector[N] ratio_k;
    vector[N] lambda;
    real alpha;
    real beta;
    alpha <- square(mu_k) * sigma_k;
    beta <- mu_k * sigma_k;
    for(i in 1:N){
      redd_count[i] ~ poisson(lambda[i]);
    }
    lambda ~ gamma(alpha, beta);
    upstream_count ~ lognormal(mu_a, sigma_a);

  }"


mill_upstream_redd_model <- "
  data {
    int N;
    vector[N] redd_count;
  }
  parameters {
    real mu_k;
    real sigma_k;
    vector[N] lambda;
  }
  model {
    real alpha;
    real beta;
    alpha <- square(mu_k) * sigma_k;
    beta <- mu_k * sigma_k;
    for(i in 1:N){
      redd_count[i] ~ poisson(lambda[i]);
      lambda[i] ~ gamma(alpha, beta);
    }
  }"

fit <- stan(model_code = mill_upstream_redd_model, data = list(N = N,
                                                               redd_count = redd_count), 
            chains = 4, iter = 5000*2, seed = 84735)

# for(i in 1:N) {
#   lambda[i] <- upstream_count[i] * ratio_k[i];
#   redd_count[i] ~ poisson(lambda[i]);
# }
# 
# ratio_k ~ gamma(alpha, beta);
# lambda <- upstream_count .* ratio_k;
# real lambda;
# lambda <- mean(upstream_count .* ratio_k);

# run model
fit <- stan(model_code = mill_upstream_redd_model, data = list(N = N,
                                                               redd_count = redd_count,
                                                               upstream_count = upstream_count), 
            chains = 4, iter = 5000*2, seed = 84735)




# redd bayesian paper (Dauphin)
# R(t,i) drawn from a Negative Binomial (Distributed as Poisson with 
# rate parameter having a gamma distribution)

# rate parameter lambda is a function of spawners (S), proportion of 
# wetted area of the catchment unit (P), and a spawner:redd ratio (K) 

# lambda = S * P * K

# Spawners (S) is obtained from adult returns (A) subtracting rod catchment (C)

# S = A - C

# variation within and among K: either between rivers or between years within rivers
# K is distributed as a gamma function

# K | alpha, beta ~ Gamma(alpha, beta)
# alpha = mean^2 * tau
# beta = mean * tau

# mean and tau do not vary between rivers (they tried this and it did not improve model fit)


# Adults returning (A) were drawn from a river-specific lognormal distribution
# and the mean parameter can vary among rivers

# A | mean, tau ~ lognormal(mean, tau)


# logit proportion of wetted area surveyed (P) was distributed as a normal distribution

# logit(P) | mean, tau ~ Normal(logit(mean), tau)

# running the model - 10 parameters with priors specified
mill_upstream_redd_model <- "
  data {
    int N;
    vector[N] redd_count;
    vector[N] year;
    vector[N] upstream_count;
  }
  parameters {
    real mu_k;
    real sigma_k;
  } 
  transformed parameters {
    vector[N] ratio_k;
    vector[N] lambda;
    lambda <- upstream_count .* ratio_k;
  } 
  model {
    real alpha;
    real beta;
    alpha <- (mu_k)^2 * sigma_k;
    beta <- mu_k * sigma_k;
    redd_count ~ poisson(lambda);
    ratio_k ~ gamma(alpha, beta);
  }"



