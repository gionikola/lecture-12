# Lecture 11 — Step functions (piecewise-constant basis)
# Run from project root: setwd("lecture-12"); source("scripts/01_step_functions.R")

# Source shared code (paths relative to project root)
source("src/load_packages.R")
source("src/data.R")
source("src/plot.R")
source("src/basis_step.R")

load_lecture_packages()

# ---- Data (run 00_data_generate.R first) ----
demo <- read_demo_data()

# ---- Cutpoints and basis ----
K <- 5
cutpoints <- cutpoints_quantile(demo$x, K)
X_basis <- basis_step(demo$x, cutpoints)
X_df <- as_tibble(X_basis, .name_repair = "minimal")
names(X_df) <- paste0("bin", seq_len(K))

# ---- Fit (OLS: no intercept; each bin has its own level) ----
fit_data <- bind_cols(y = demo$y, X_df)
model <- linear_reg() %>%
  set_engine("lm") %>%
  fit(y ~ . - 1, data = fit_data)
coefs <- coef(model$fit)

# ---- Predict on a fine grid (with clamping) ----
x_min <- min(demo$x)
x_max <- max(demo$x)
x_grid <- seq(x_min, x_max, length.out = 300)
fitted_grid <- predict_step(cutpoints, coefs, x_grid, x_min, x_max)

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
  title = "Step function fit (piecewise constant)",
  cutpoints = cutpoints[-c(1, length(cutpoints))],  # interior only for vertical lines
  file_path = "output/figures/01_step_functions.pdf"
)
