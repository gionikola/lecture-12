# Run from project root: make all  or  make fit

.PHONY: all fit

# Full pipeline: generate data, then all figure scripts
all:
	Rscript scripts/00_data_generate.R
	Rscript scripts/01_step_functions.R
	Rscript scripts/02_linear_splines.R
	Rscript scripts/03_natural_cubic_splines.R
	Rscript scripts/04_linear_splines_tuned.R
	Rscript scripts/05_smoothing_spline.R

# Figure scripts only (assumes data/demo.csv already exists)
fit:
	Rscript scripts/01_step_functions.R
	Rscript scripts/02_linear_splines.R
	Rscript scripts/03_natural_cubic_splines.R
	Rscript scripts/04_linear_splines_tuned.R
	Rscript scripts/05_smoothing_spline.R
