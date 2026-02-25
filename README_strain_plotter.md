# Mutant Strain Plotter

This repository contains an R script designed to quickly generate standardized, publication-ready scatter plots (with means and error bars) for bacterial mutant strain data.

## Prerequisites

To run this script, you will need R installed on your machine along with the following packages:
* `dplyr`
* `ggplot2`

You can install these in R using the following command:
`install.packages(c("dplyr", "ggplot2"))`

## Usage: Command Line (The Easy Way)

You can run this script directly from your Mac Terminal or Windows Command Prompt without ever opening RStudio.

**Basic Usage:**
Provide the name of your CSV file as the first argument. It will automatically generate a file named `strain_plot.svg`.
```bash
Rscript plot_mutants.R data_mutants_hatcher.csv
