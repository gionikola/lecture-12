# Lecture 11 — Smoothing spline (penalized least squares); tune df via 5-fold CV
# Run from project root: setwd("lecture-12"); source("scripts/05_smoothing_spline.R")

source("src/load_packages.R")
source("src/data.R")
source("src/plot.R")

load_lecture_packages()

# ---- Data (run 00_data_generate.R first) ----
demo <- read_demo_data()

# ---- 5-fold cross-validation: tune effective degrees of freedom ----
set.seed(123)
splits <- vfold_cv(demo, v = 5)

df_candidates <- seq(4, 20, by = 2)

cv_metrics <- tibble(df = df_candidates) %>%
  mutate(
    mean_rmse = map_dbl(df, function(d) {
      rmse_per_fold <- map_dbl(splits$splits, function(split) {
        train_data <- analysis(split)
        val_data <- assessment(split)
        fit <- smooth.spline(train_data$x, train_data$y, df = d)
        pred_val <- predict(fit, val_data$x)$y
        rmse_vec(val_data$y, pred_val)
      })
      mean(rmse_per_fold)
    })
  )

best_df <- cv_metrics %>%
  slice_min(mean_rmse, n = 1) %>%
  pull(df)

# ---- Refit on full data with chosen df ----
fit <- smooth.spline(demo$x, demo$y, df = best_df)

# ---- Predict on a fine grid ----
x_min <- min(demo$x)
x_max <- max(demo$x)
x_grid <- seq(x_min, x_max, length.out = 300)
pred_grid <- predict(fit, x_grid)

pred_tbl <- tibble(
  x = x_grid,
  fitted = pred_grid$y,
  true = true_f(x_grid)
)

# ---- Plot and save (no knot lines; smoothing spline uses knots at data points) ----
dir.create("output/figures", recursive = TRUE, showWarnings = FALSE)
plot_fit(
  data = demo,
  pred = pred_tbl,
  title = sprintf("Smoothing spline (df = %g, tuned by 5-fold CV)", best_df),
  file_path = "output/figures/05_smoothing_spline.pdf"
)
