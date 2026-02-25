# Lecture 11 — Linear regression splines (truncated power basis)
# Run from project root: setwd("lecture-12"); source("scripts/02_linear_splines.R")

source("src/load_packages.R")
source("src/data.R")
source("src/plot.R")
source("src/basis_linear_spline.R")

load_lecture_packages()

# ---- Data (run 00_data_generate.R first) ----
demo <- read_demo_data()

# ---- Knots and basis ----
K <- 4
knots <- knots_quantile(demo$x, K)
X_basis <- basis_linear_spline(demo$x, knots)
X_df <- as_tibble(X_basis, .name_repair = "minimal")
names(X_df) <- c("intercept", "x", paste0("hinge", seq_len(K)))

# ---- Fit (OLS with parsnip) ----
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
  title = "Linear regression spline fit",
  knots = knots,
  file_path = "output/figures/02_linear_splines.pdf"
)
