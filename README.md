# Autistic traits and self-other integration

This repository contains data, analysis code, and figures for the project
**“No evidence of a relationship between autistic traits and self-other
integration during social decision making.”** The project analyzes behavioral
data from laboratory and online experiments, including analyses of autistic
traits, self-bias, and social basis function use.

## Repository layout

| Folder | Contents |
| --- | --- |
| `1_data/` | MATLAB source data and CSV tables exported from the MATLAB analyses. |
| `2_ana/` | MATLAB and R scripts for data processing and analysis, plus shared utilities. |
| `3_ana_out/` | Processed participant-level datasets, analysis outputs, and Bayesian analysis code. |
| `4_plot/` | R scripts for generating main and supplementary figures. |
| `5_figs/` | Exported manuscript figures, primarily PDFs. |

## Workflow

The general workflow is to proceed from source data through processing and
analysis to figures:

1. **Prepare the MATLAB-derived tables.** The source data is in
   `1_data/Alldata_4exps_ridge_07-Sep-2023.mat`. The MATLAB script
   `2_ana/ana_all_ridge_2026.m` runs ridge-based behavioral models and exports
   tables to `1_data/outfrommat/`.
2. **Prepare analysis datasets.** Run `2_ana/beh_prep.R` to combine the lab
   and online experiment tables, derive analysis variables, and write dated
   datasets to `3_ana_out/`.
3. **Run analyses and create figures.** The scripts in `4_plot/` create the
   main and supplementary figures from the processed datasets, saving figure
   files to `5_figs/`. `3_ana_out/beh_BayesianRegression_inR.R` contains the
   Bayesian regression analyses.

The repository includes processed CSVs and exported figures, so these outputs
can be inspected without rerunning the full pipeline. Some scripts also
perform computations while plotting.

## Running the scripts

- MATLAB scripts use relative paths. Run `ana_all_ridge_2026.m` with
  `2_ana/` as the working directory.
- The R scripts use `rstudioapi` to set the working directory to the active
  script's folder. Open and run them from RStudio.
- The shared `environPrepar.R` scripts load helper functions and R packages.
  The package setup includes `tidyverse`, `rstatix`, `readxl`, `ggpubr`,
  `bruceR`, `corrplot`, `cocor`, `RColorBrewer`, `ppcor`, `mediation`,
  `patchwork`, `cowplot`, `readr`, `BayesFactor`, and `lmtest`.
- Project notes record MATLAB R2021b and R 4.1.3 as the analysis versions.

## Reproducibility notes

- Several analysis and plotting scripts refer to specifically dated input
  files (for example, `Fulldata_20261020.csv`). If you regenerate data with a
  different date, update the corresponding input filenames in downstream
  scripts before running them.
- Some scripts create date-stamped outputs. Check the script's input paths and
  output naming before rerunning to avoid unintentionally replacing or
  mixing results.
- See the manuscript for study methods, variable definitions, and
  interpretation of the results.
