source("src/load_packages.R")
source("src/data.R")

load_packages()

set.seed(42)
demo <- generate_demo_data(n = 200, sigma = 0.5, seed = NULL)

dir.create("data", recursive = TRUE, showWarnings = FALSE)
write_csv(demo, "data/demo.csv")

message("Saved ", nrow(demo), " rows to data/demo.csv")
