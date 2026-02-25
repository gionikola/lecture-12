#' Natural cubic spline basis — Lecture 11
#'
#' Uses splines::ns() (natural regression splines: linear beyond boundary knots).
#' Basis matrix has df columns; knots can be specified or implied by df.

#' Build natural cubic spline basis matrix
#'
#' @param x Numeric vector.
#' @param knots Optional numeric vector of interior knots. If NULL, \code{df} is used.
#' @param df Degrees of freedom (number of basis functions). Used if \code{knots} is NULL.
#' @param boundary Boundary knots; default min and max of \code{x}.
#' @return Matrix with length(x) rows and \code{df} (or length(knots)+4 for intercept) columns.
#'   Also has attribute "knots" and "Boundary.knots" from \code{splines::ns()}.
#' @export
basis_natural_cubic <- function(x, knots = NULL, df = NULL, boundary = range(x)) {
  if (is.null(knots) && is.null(df)) stop("Provide either knots or df.")
  nm <- basis_natural_cubic
  if (!is.null(knots)) {
    B <- splines::ns(x, knots = knots, Boundary.knots = boundary, intercept = TRUE)
  } else {
    B <- splines::ns(x, df = df, Boundary.knots = boundary, intercept = TRUE)
  }
  B
}

#' Predict from natural cubic spline (same basis at new x)
#'
#' @param basis_train Basis matrix returned by \code{splines::ns(x, ...)} used in training.
#'   Its attributes (\code{knots}, \code{Boundary.knots}) are used to evaluate the basis at \code{new_x}.
#' @param coefs Coefficient vector (length = ncol(basis_train)).
#' @param new_x New covariate values.
#' @return Numeric vector of predicted values.
#' @export
predict_natural_cubic <- function(basis_train, coefs, new_x) {
  k <- attr(basis_train, "knots")
  bk <- attr(basis_train, "Boundary.knots")
  intercept <- attr(basis_train, "intercept")
  B_new <- splines::ns(new_x, knots = k, Boundary.knots = bk, intercept = intercept)
  as.numeric(B_new %*% coefs)
}
