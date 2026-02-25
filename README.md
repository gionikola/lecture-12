# lecture-12

Demonstrations of nonlinear regression using basis functions: step functions, linear regression splines, natural cubic splines, and smoothing splines. All scripts use **tidyverse** and **tidymodels**, fit models by (penalized) least squares, and produce comparison plots of the true and fitted curves.

## Structure

| Path | Description |
|------|-------------|
| **`scripts/`** | R scripts run in order. `00_data_generate.R` creates a single shared dataset; `01`–`05` each fit a different basis-function model and write a figure. |
| **`src/`** | Shared R code: package loading, data generation/reading, plotting helpers, and basis-function utilities (step, linear spline, natural cubic). |
| **`data/`** | Generated dataset (one sample), written by `00_data_generate.R` and read by the fit scripts. |
| **`output/figures/`** | PDF figures produced by scripts `01`–`05`. |

## Scripts

- **`00_data_generate.R`** — Generates a univariate demo sample and saves it as `data/demo.csv`.
- **`01_step_functions.R`** — Piecewise-constant (step) basis with quantile cutpoints; out-of-range prediction by clamping.
- **`02_linear_splines.R`** — Linear regression spline (truncated power basis) with a fixed number of knots.
- **`03_natural_cubic_splines.R`** — Natural cubic spline basis (`splines::ns`), OLS on the basis.
- **`04_linear_splines_tuned.R`** — Linear regression spline with the number of knots chosen by 5-fold cross-validation.
- **`05_smoothing_spline.R`** — Smoothing spline (`stats::smooth.spline`) with effective degrees of freedom chosen by 5-fold cross-validation.

## Running the pipeline

From the project root:

- **`make all`** — Generate data, then run all fit scripts (full pipeline).
- **`make fit`** — Run only the fit scripts; requires `data/demo.csv` to already exist.

To run a single script in R, set the working directory to the project root and `source("scripts/00_data_generate.R")` (or the desired script). The first time, run `load_packages(install_missing = TRUE)` so required packages are installed if needed.
