#' Plot fitted basis-function regression (Lecture 11)
#'
#' Draws scatter of data, optional true curve, and fitted curve. Optionally marks
#' cutpoints (step functions) or knots (splines). Saves to PDF.
#'
#' @param data Tibble with \code{x} and \code{y} (observed data).
#' @param pred Tibble with \code{x} and \code{fitted} (and optionally \code{true}).
#' @param title Plot title.
#' @param cutpoints Optional numeric vector of cutpoints (vertical lines).
#' @param knots Optional numeric vector of knots (vertical lines).
#' @param file_path Path for PDF output (e.g. \code{output/figures/01_step.pdf}).
#' @param width Width of PDF in inches.
#' @param height Height of PDF in inches.
#' @return The ggplot object (invisibly), and writes PDF to \code{file_path}.
#' @export
plot_fit <- function(data, pred, title = "Fit",
                     cutpoints = NULL, knots = NULL,
                     file_path = NULL, width = 7, height = 5) {
  p <- ggplot(data, aes(x = x, y = y)) +
    geom_point(alpha = 0.6, size = 2) +
    geom_line(data = pred, aes(y = fitted), color = "darkblue", linewidth = 1.2) +
    labs(title = title, x = "x", y = "y") +
    theme_minimal(base_size = 12)

  if ("true" %in% names(pred)) {
    p <- p + geom_line(data = pred, aes(y = true), color = "gray40", linewidth = 0.8, linetype = "dashed")
  }

  if (!is.null(cutpoints) && length(cutpoints) > 0L) {
    p <- p + geom_vline(xintercept = cutpoints, color = "red", linewidth = 0.4, linetype = "dotted")
  }
  if (!is.null(knots) && length(knots) > 0L) {
    p <- p + geom_vline(xintercept = knots, color = "darkgreen", linewidth = 0.4, linetype = "dotted")
  }

  if (!is.null(file_path)) {
    dir <- dirname(file_path)
    if (dir != "." && !dir.exists(dir)) dir.create(dir, recursive = TRUE)
    ggsave(file_path, plot = p, width = width, height = height, device = "pdf")
  }

  invisible(p)
}
