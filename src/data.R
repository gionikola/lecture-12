#' True conditional mean f(x) used in the lecture demo data
#'
#' @param t Numeric vector of covariate values.
#' @return Numeric vector of conditional mean values.
#' @export
true_f <- function(t) {
  2 + 0.3 * t + 2 * sin(t * 0.6) - 0.05 * (t - 5)^2
}

#' Generate demo data for basis-function regression (Lecture 11)
#'
#' Creates a single-regressor dataset Y = f(X) + epsilon with a smooth nonlinear f.
#' Same data can be used across step functions, linear splines, and natural cubic splines.
#'
#' @param n Sample size.
#' @param sigma Standard deviation of additive Gaussian noise.
#' @param seed Optional random seed for reproducibility.
#' @return A tibble with columns \code{x} and \code{y}.
#' @export
generate_demo_data <- function(n = 200, sigma = 0.5, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  x <- runif(n, 0, 10)
  y <- true_f(x) + rnorm(n, 0, sigma)
  tibble(x = x, y = y)
}

#' Read the demo dataset from data/demo.csv
#'
#' Run \code{scripts/00_data_generate.R} first to create the file.
#'
#' @param path Path to the CSV file (default \code{data/demo.csv}).
#' @return A tibble with columns \code{x} and \code{y}.
#' @export
read_demo_data <- function(path = "data/demo.csv") {
  read_csv(path, show_col_types = FALSE)
}
