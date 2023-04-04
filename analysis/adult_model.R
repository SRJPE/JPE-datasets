# implement modified Dauphin et al model


# libraries ---------------------------------------------------------------
library(tidyverse)
library(lubridate)
library(googleCloudStorageR)
library(rstan)
library(bayesplot)

# pull adult data & process ----------------------------------------------------------------
gcs_auth(json_file = Sys.getenv("GCS_AUTH_FILE"))
gcs_global_bucket(bucket = Sys.getenv("GCS_DEFAULT_BUCKET"))

# upstream passage
upstream_passage <- read_csv(gcs_get_object(object_name = "standard-format-data/standard_adult_upstream_passage.csv",
                                            bucket = gcs_get_global_bucket())) |>
  filter(!is.na(date)) |> 
  mutate(stream = tolower(stream),
         year = year(date)) |>
  filter(run %in% c("spring", NA, "not recorded")) |> 
  group_by(year, passage_direction, stream) |>
  summarise(count = sum(count, na.rm = T)) |> 
  ungroup() |> 
  pivot_wider(names_from = passage_direction, values_from = count) |> 
  # calculate upstream passage for streams where passage direction is recorded
  mutate(down = ifelse(is.na(down), 0, down),
         up = case_when(stream %in% c("deer creek", "mill creek") ~ `NA`,
                        !stream %in% c("deer creek", "mill creek") & is.na(up) ~ 0,
                        TRUE ~ up)) |> 
  select(-`NA`) |> 
  group_by(year, stream) |> 
  summarise(count = round(up - down), 0) |> 
  select(year, count, stream) |> 
  ungroup() |> 
  glimpse()


# holding
holding <- read_csv(gcs_get_object(object_name = "standard-format-data/standard_holding.csv",
                                   bucket = gcs_get_global_bucket()))|> 
  group_by(year, stream) |> 
  summarise(count = sum(count, na.rm = T)) |> 
  ungroup() |> 
  glimpse()

# redd
redd <- read_csv(gcs_get_object(object_name = "standard-format-data/standard_annual_redd.csv",
                                bucket = gcs_get_global_bucket())) |> 
  filter(run %in% c("spring", "not recorded")) |> 
  # redds in these reaches are likely fall, so set to 0 for battle & clear
  mutate(max_yearly_redd_count = case_when(reach %in% c("R6", "R6A", "R6B", "R7") & 
                                             stream %in% c("battle creek", "clear creek") ~ 0,
                                           TRUE ~ max_yearly_redd_count)) |> 
  group_by(year, stream) |>
  summarise(count = sum(max_yearly_redd_count, na.rm = T)) |> 
  ungroup() |> 
  select(year, stream, count) |> 
  glimpse()

redd_daily <- read_csv(gcs_get_object(object_name = "standard-format-data/standard_daily_redd.csv",
                                      bucket = gcs_get_global_bucket())) |> 
  filter(run %in% c("spring", NA, "not recorded")) |> 
  mutate(count = 1) |> 
  group_by(year, stream) |> 
  summarise(count = sum(count)) |> 
  ungroup() |> 
  glimpse()

# carcass
carcass <- read_csv(gcs_get_object(object_name = "standard-format-data/standard_carcass.csv",
                                   bucket = gcs_get_global_bucket())) |>
  filter(run %in% c("spring", "unknown", NA)) |> 
  select(date, stream, count) |> 
  mutate(year = year(date)) |> 
  group_by(year, stream) |> 
  summarise(count = sum(count, na.rm = T)) |> 
  ungroup() |> 
  glimpse()

# temperature

# threshold
# https://www.noaa.gov/sites/default/files/legacy/document/2020/Oct/07354626766.pdf 
threshold <- 21

temp <- read_csv(gcs_get_object(object_name = "standard-format-data/standard_temperature.csv",
                                bucket = gcs_get_global_bucket())) |> 
  filter(stream == "sacramento river") |> 
  filter(month(date) %in% 6:8) |> 
  group_by(year(date)) |> 
  mutate(above_threshold = ifelse(mean_daily_temp_c > threshold, TRUE, FALSE)) |> 
  summarise(prop_days_exceed_threshold = round(sum(above_threshold, na.rm = T)/length(above_threshold), 2)) |> 
  ungroup() |> 
  mutate(prop_days_below_threshold = 1 - prop_days_exceed_threshold,
         prop_days_below_threshold = ifelse(prop_days_below_threshold == 0, 0.001, prop_days_below_threshold)) |> 
  rename(year = `year(date)`) |> 
  glimpse()


# write base model in stan --------------------------------------------------

mill_model_temp_prop <- "
  data {
    int N;
    int upstream_count[N];
    int redd_count[N];
    real ratio_k[N];
    real temp[N];
    real prop_surveyed[N];
  }
  parameters {
    real <lower = 0> mu_k;
    real <lower = 0> sigma_k;
    real mu_a;
    real <lower = 0> sigma_a;
  }
  model {
    vector[N] lambda;
    real alpha;
    real beta;
    beta = mu_k * sigma_k;
    alpha = mu_k * beta;
    for(i in 1:N) {
      upstream_count[i] ~ lognormal(mu_a, sigma_a);
      ratio_k[i] ~ gamma(alpha, beta);
      lambda[i] = upstream_count[i] * ratio_k[i] * temp[i] * prop_surveyed[i];
      redd_count[i] ~ poisson(lambda[i]);
    }

  }"

# prep data ---------------------------------------------------------------

all_mill <- redd |> 
  filter(stream == "mill creek") |>
  rename(redd_count = count) |> 
  full_join(upstream_passage |> 
              filter(stream == "mill creek") |> 
              rename(upstream_count = count) |> 
              select(-stream),
            by = "year") |> 
  glimpse()

years <- min(upstream_mill$year):max(upstream_mill$year)
N <- length(years)
redd_count <- all_mill |> 
  filter(!is.na(upstream_count)) |> 
  pull(redd_count)
upstream_count <- all_mill |> 
  filter(!is.na(upstream_count)) |> 
  pull(upstream_count)
ratio_k <- upstream_count / redd_count
model_temp <- temp |> 
  filter(year %in% years) |> 
  pull(prop_days_below_threshold) |> 
  append(0.15, 2) # placehlder for 2013 temp (got filtered out)
prop_surveyed <- rep(1.0, 9) # assume all of spawning population is surveyed



# fit model ---------------------------------------------------------------


fit <- stan(model_code = mill_model_temp_prop, 
            data = list(N = N,
                        upstream_count = upstream_count,
                        redd_count = redd_count,
                        ratio_k = ratio_k,
                        temp = model_temp,
                        prop_surveyed = prop_surveyed), 
            #init = init_list,
            chains = 4, iter = 5000*2, seed = 84735)



# try hierarchical structure ----------------------------------------------

# prep data
all_tribs_all_data <- upstream_passage |> 
  rename(upstream_count = count) |> 
  full_join(redd |> rename(redd = count),
            by = c("year", "stream")) |> 
  full_join(holding |> rename(holding = count),
            by = c("year", "stream")) |> 
  glimpse()

# just try redd and upstream for battle & yuba
upstream_hierarchical <- all_tribs_all_data |> 
  filter(stream %in% c("yuba river", "battle creek"),
         year %in% 2011:2019) |> 
  select(year, upstream_count, stream) |> 
  pivot_wider(names_from = stream, values_from = upstream_count) |> 
  select(-year) |> 
  as.matrix() |> 
  unname()

redd_hierarchical <- all_tribs_all_data |> 
  filter(stream %in% c("yuba river", "battle creek"),
         year %in% 2011:2019) |>
  select(year, redd, stream) |> 
  pivot_wider(names_from = stream, values_from = redd) |> 
  select(-year) |> 
  as.matrix() |> 
  unname()

ratio_hierarchical <- upstream_hierarchical / redd_hierarchical

S <- dim(redd_hierarchical)[2]
N <- dim(redd_hierarchical)[1]

mill_model_hierarchical <- "
  data {
    int N;
    int S;
    int upstream_count[N,S];
    int redd_count[N,S];
    real ratio_k[N,S];
  }
  parameters {
    real <lower = 0> mu_k;
    real <lower = 0> sigma_k[N];
    real mu_a;
    real <lower = 0> sigma_a;
  }
  model {
    matrix[N,S] lambda;
    real alpha[N];
    real beta[N];
    for(i in 1:N) {
      beta[i] = mu_k * sigma_k[i];
      alpha[i] = mu_k * beta[i];
      for(j in 1:S) {
        upstream_count[i,j] ~ lognormal(mu_a, sigma_a);
        ratio_k[i,j] ~ gamma(alpha[i], beta[i]);
        lambda[i,j] = upstream_count[i,j] * ratio_k[i,j];
        redd_count[i,j] ~ poisson(lambda[i,j]);
      }
    }
  }"

fit_hierarchical <- stan(model_code = mill_model_hierarchical, 
                          data = list(N = N,
                                      S = S,
                                      upstream_count = upstream_hierarchical,
                                      redd_count = redd_hierarchical,
                                      ratio_k = ratio_hierarchical), 
                          chains = 4, iter = 5000*2, seed = 84735)

# diagnostics -------------------------------------------------------------

mcmc_trace(fit, pars = c("mu_k", "sigma_k", "mu_a", "sigma_a"))
mcmc_areas(fit, pars = c("mu_k", "sigma_k", "mu_a", "sigma_a"))
mcmc_dens_overlay(fit, pars = c("mu_k", "sigma_k", "mu_a", "sigma_a")) # should be indistinguishable
neff_ratio(fit, pars = c("mu_k", "sigma_k", "mu_a", "sigma_a")) # should be >0.1
mcmc_acf(fit, pars = c("mu_k", "sigma_k", "mu_a", "sigma_a")) # should drop to be low
rhat(fit, c("mu_k", "sigma_k", "mu_a", "sigma_a")) # should be close to 1


# scratch -----------------------------------------------------------------

# prediction
# prediction using rstanarm - need to fit model in rstanarm for this to work
# TODO wrapper for passing stan code to rstan?

# prediction with R code and custom function
# get results
pars <- as.data.frame(fit, pars = c("mu_k", "sigma_k", "mu_a", "sigma_a"))
predict_redd <- function(mu_k, sigma_k, mu_a, sigma_a) {
  beta <- mu_k * sigma_k
  alpha <- mu_k * beta
  
  upstream_count <- rlnorm(1, mu_a, sigma_a)
  ratio_k <- rgamma(1, alpha, beta)
  lambda <- upstream_count * ratio_k
  redd_count <- rpois(1, lambda)
  return(list("redd_count" = redd_count,
              "upstream_count" = upstream_count,
              "ratio_k" = ratio_k))
}

pred_redd <- numeric()
pred_adult <- numeric()
pred_ratio <- numeric()
year <- numeric()
for(i in 1:100){
  predict <- predict_redd(sample(pars$mu_k, 1), sample(pars$sigma_k, 1),
                          sample(pars$mu_a, 1), sample(pars$sigma_a, 1))
  year[i] <- i
  pred_redd[i] <- predict$redd_count
  pred_adult[i] <- predict$upstream_count
  pred_ratio[i] <- predict$ratio_k
}

pred_dat <- tibble(year = year,
                   redd = pred_redd,
                   adult = pred_adult,
                   ratio = pred_ratio)
ggplot(pred_dat) +
  geom_line(data = pred_dat, aes(x = year, y = redd)) + 
  geom_line(data = pred_dat, aes(x = year, y = adult),  col = "blue")

ggplot(pred_dat) +
  geom_line(aes(x = year, y = pred_ratio))
# TODO could covariate explain years where ratio is below 1 ? upstream passage has 
# high flow? 



# scratch -----------------------------------------------------------------



mu <- 0.5
sigma <- 0.2
beta <- mu * sigma
alpha <- mu * beta
summary(rgamma(10000, alpha, beta))

init_list <- list()
Nchains <- 4
for(i in 1:Nchains){
  init_list[[i]] <- list(mu_k = rgamma(1, 3, 1),
                         sigma_k = rgamma(1, 1, 2),
                         mu_a = runif(1, 3, 5),
                         sigma_a = rgamma(1, 0.6, 1))
}


# try predicting with bayesforecast
bayesforecast::forecast(fit, h = 20) # not working
