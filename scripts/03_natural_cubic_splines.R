source("src/load_packages.R")
source("src/data.R")
source("src/plot.R")
source("src/basis_natural_cubic.R")

load_packages()

demo <- read_demo_data()

df <- 6
boundary <- range(demo$x)
B <- basis_natural_cubic(demo$x, df = df, boundary = boundary)
X_df <- as_tibble(B, .name_repair = "minimal")
names(X_df) <- paste0("ns", seq_len(ncol(X_df)))

fit_data <- bind_cols(y = demo$y, X_df)
model <- linear_reg() %>%
  set_engine("lm") %>%
  fit(y ~ . - 1, data = fit_data)
coefs <- coef(model$fit)

x_min <- min(demo$x)
x_max <- max(demo$x)
x_grid <- seq(x_min, x_max, length.out = 300)
fitted_grid <- predict_natural_cubic(B, coefs, x_grid)

pred_tbl <- tibble(
  x = x_grid,
  fitted = fitted_grid,
  true = true_f(x_grid)
)

dir.create("output/figures", recursive = TRUE, showWarnings = FALSE)
interior_knots <- attr(B, "knots")
plot_fit(
  data = demo,
  pred = pred_tbl,
  title = "Natural cubic spline fit",
  knots = interior_knots,
  file_path = "output/figures/03_natural_cubic_splines.pdf"
)
