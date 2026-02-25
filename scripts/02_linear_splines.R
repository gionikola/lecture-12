source("src/load_packages.R")
source("src/data.R")
source("src/plot.R")
source("src/basis_linear_spline.R")

load_packages()

demo <- read_demo_data()

K <- 4
knots <- knots_quantile(demo$x, K)
X_basis <- basis_linear_spline(demo$x, knots)
X_df <- as_tibble(X_basis, .name_repair = "minimal")
names(X_df) <- c("intercept", "x", paste0("hinge", seq_len(K)))

fit_data <- bind_cols(y = demo$y, X_df)
model <- linear_reg() %>%
  set_engine("lm") %>%
  fit(y ~ . - 1, data = fit_data)
coefs <- coef(model$fit)

x_min <- min(demo$x)
x_max <- max(demo$x)
x_grid <- seq(x_min, x_max, length.out = 300)
fitted_grid <- predict_linear_spline(knots, coefs, x_grid)

pred_tbl <- tibble(
  x = x_grid,
  fitted = fitted_grid,
  true = true_f(x_grid)
)

dir.create("output/figures", recursive = TRUE, showWarnings = FALSE)
plot_fit(
  data = demo,
  pred = pred_tbl,
  title = "Linear regression spline fit",
  knots = knots,
  file_path = "output/figures/02_linear_splines.pdf"
)
