#' Linear regression spline basis
#'
#' f(x) = beta0 + beta1*x + sum_k gamma_k * (x - kappa_k)_+
#' Truncated power basis: 1, x, (x - kappa_1)_+, ..., (x - kappa_K)_+.

#' Place interior knots at quantiles of x
#'
#' @param x Numeric vector.
#' @param K Number of interior knots.
#' @return Numeric vector of K knots (strictly between min and max of x).
#' @export
knots_quantile <- function(x, K) {
  if (K < 1L) return(numeric(0))
  q <- quantile(x, probs = seq(0, 1, length.out = K + 2L))
  as.numeric(q[-c(1, length(q))])
}

#' Truncated power (u)_+ = max(u, 0)
#' @export
trunc_pos <- function(u) pmax(u, 0)

#' Build linear spline basis matrix: [1, x, (x - k1)_+, ..., (x - kK)_+]
#'
#' @param x Numeric vector.
#' @param knots Numeric vector of K knots.
#' @return Matrix with length(x) rows and 2 + length(knots) columns (intercept, x, then hinge terms).
#' @export
basis_linear_spline <- function(x, knots) {
  n <- length(x)
  B <- matrix(NA_real_, nrow = n, ncol = 2L + length(knots))
  B[, 1L] <- 1
  B[, 2L] <- x
  for (j in seq_along(knots)) {
    B[, 2L + j] <- trunc_pos(x - knots[j])
  }
  B
}

#' Predict from linear spline model
#'
#' @param knots Knot vector used in training.
#' @param coefs Coefficient vector: (intercept, slope, gamma_1, ..., gamma_K).
#' @param new_x New covariate values.
#' @return Numeric vector of predicted values.
#' @export
predict_linear_spline <- function(knots, coefs, new_x) {
  B <- basis_linear_spline(new_x, knots)
  as.numeric(B %*% coefs)
}
