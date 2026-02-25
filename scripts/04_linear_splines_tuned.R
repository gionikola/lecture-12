# Lecture 11 — Linear regression splines: tune number of knots via 5-fold CV
# Run from project root: setwd("lecture-12"); source("scripts/04_linear_splines_tuned.R")

source("src/load_packages.R")
source("src/data.R")
source("src/plot.R")
source("src/basis_linear_spline.R")

load_lecture_packages()

# ---- Data (run 00_data_generate.R first) ----
demo <- read_demo_data()

# ---- 5-fold cross-validation ----
set.seed(123)
splits <- vfold_cv(demo, v = 5)

# Candidate number of interior knots (quantile placement for each K)
K_candidates <- 1:8

# For each K, compute mean CV RMSE
cv_metrics <- tibble(K = K_candidates) %>%
  mutate(
    mean_rmse = map_dbl(K, function(k) {
      rmse_per_fold <- map_dbl(splits$splits, function(split) {
        train_data <- analysis(split)
        val_data <- assessment(split)
        knots <- knots_quantile(train_data$x, k)
        X_train <- basis_linear_spline(train_data$x, knots)
        X_df <- as_tibble(X_train, .name_repair = "minimal")
        names(X_df) <- c("intercept", "x", paste0("hinge", seq_len(k)))
        fit_data <- bind_cols(y = train_data$y, X_df)
        model <- linear_reg() %>%
          set_engine("lm") %>%
          fit(y ~ . - 1, data = fit_data)
        coefs <- coef(model$fit)
        pred_val <- predict_linear_spline(knots, coefs, val_data$x)
        rmse_vec(val_data$y, pred_val)
      })
      mean(rmse_per_fold)
    })
  )

best_K <- cv_metrics %>%
  slice_min(mean_rmse, n = 1) %>%
  pull(K)

# ---- Refit on full data with chosen K ----
knots <- knots_quantile(demo$x, best_K)
X_basis <- basis_linear_spline(demo$x, knots)
X_df <- as_tibble(X_basis, .name_repair = "minimal")
names(X_df) <- c("intercept", "x", paste0("hinge", seq_len(best_K)))

fit_data <- bind_cols(y = demo$y, X_df)
model <- linear_reg() %>%
  set_engine("lm") %>%
  fit(y ~ . - 1, data = fit_data)
coefs <- coef(model$fit)

# ---- Predict on a fine grid ----
x_min <- min(demo$x)
x_max <- max(demo$x)
x_grid <- seq(x_min, x_max, length.out = 300)
fitted_grid <- predict_linear_spline(knots, coefs, x_grid)

pred_tbl <- tibble(
  x = x_grid,
  fitted = fitted_grid,
  true = true_f(x_grid)
)

# ---- Plot and save ----
dir.create("output/figures", recursive = TRUE, showWarnings = FALSE)
plot_fit(
  data = demo,
  pred = pred_tbl,
  title = sprintf("Linear regression spline (K = %d knots, tuned by 5-fold CV)", best_K),
  knots = knots,
  file_path = "output/figures/04_linear_splines_tuned.pdf"
)
