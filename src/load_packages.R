#' Load (and install if necessary) all packages required for the scripts
#'
#' Ensures a reproducible environment. Call this at the top of each script.
#'
#' @param install_missing If TRUE (default), install any missing packages via
#'   \code{install.packages()}. Set to FALSE to only load already-installed packages.
#' @return Invisibly, a character vector of attached package names.
#' @export
load_packages <- function(install_missing = TRUE) {
  required <- c(
    "tidyverse",   # dplyr, ggplot2, tidyr, purrr, tibble, etc.
    "tidymodels",  # parsnip, recipes, rsample, tune
    "splines"      # ns(), bs() — base R but we list for documentation
  )

  missing <- required[!vapply(required, requireNamespace, logical(1), quietly = TRUE)]

  if (length(missing) > 0L && install_missing) {
    message("Installing missing packages: ", paste(missing, collapse = ", "))
    install.packages(missing, dependencies = TRUE, repos = "https://cloud.r-project.org")
  }

  if (length(missing) > 0L) {
    stop(
      "Missing required packages: ", paste(missing, collapse = ", "),
      ". Run load_packages(install_missing = TRUE)."
    )
  }

  # Attach tidyverse and tidymodels (splines is base, already available)
  library(tidyverse)
  library(tidymodels)

  invisible(required)
}
