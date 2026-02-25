#' Step-function (piecewise-constant) basis — Lecture 11
#'
#' Cutpoints define K bins on [c0, cK). Basis b_k(x) = 1{c_{k-1} <= x < c_k}.
#' Out-of-range x is clamped to [c0, cK] before evaluation.

#' Compute cutpoints from data (quantile-based by default)
#'
#' @param x Numeric vector of covariate values.
#' @param K Number of bins (number of interior cutpoints is K - 1; total cutpoints K+1 with boundaries).
#' @return Numeric vector of length K+1: c0 = min(x), c1,...,c_{K-1} = quantiles, cK = max(x).
#' @export
cutpoints_quantile <- function(x, K) {
  c0 <- min(x)
  cK <- max(x)
  if (K <= 1L) return(c(c0, cK))
  q <- quantile(x, probs = seq(0, 1, length.out = K + 1L))
  as.numeric(q)
}

#' Build step-function basis matrix
#'
#' @param x Numeric vector.
#' @param cutpoints Numeric vector of length K+1 (boundaries define K bins).
#' @return Matrix with length(x) rows and K columns (indicator for each bin).
#' @export
basis_step <- function(x, cutpoints) {
  K <- length(cutpoints) - 1L
  out <- matrix(0, nrow = length(x), ncol = K)
  for (k in seq_len(K)) {
    out[, k] <- as.numeric(x >= cutpoints[k] & x < cutpoints[k + 1L])
  }
  # Last bin: include right endpoint so that max(x) falls in last bin
  out[, K] <- as.numeric(x >= cutpoints[K] & x <= cutpoints[K + 1L])
  out
}

#' Clamp x to the data range [x_min, x_max]
#' @export
clamp <- function(x, x_min, x_max) {
  pmax(pmin(x, x_max), x_min)
}

#' Predict step function with clamping for out-of-range x
#'
#' @param cutpoints Cutpoint vector from training data.
#' @param coefs Coefficient vector (length K); coefs[k] = level in bin k.
#' @param new_x New covariate values (can be out of range; they are clamped).
#' @param x_min Minimum x in training data (for clamping).
#' @param x_max Maximum x in training data (for clamping).
#' @return Numeric vector of predicted values.
#' @export
predict_step <- function(cutpoints, coefs, new_x, x_min, x_max) {
  x_clamped <- clamp(new_x, x_min, x_max)
  B <- basis_step(x_clamped, cutpoints)
  as.numeric(B %*% coefs)
}
