# Lecture 11 — Generate demo data once; used by 01, 02, 03
# Run from project root: setwd("lecture-12"); source("scripts/00_data_generate.R")

source("src/load_packages.R")
source("src/data.R")

load_lecture_packages()

# ---- Generate and save ----
set.seed(42)
demo <- generate_demo_data(n = 200, sigma = 0.5, seed = NULL)

dir.create("data", recursive = TRUE, showWarnings = FALSE)
write_csv(demo, "data/demo.csv")

message("Saved ", nrow(demo), " rows to data/demo.csv")
