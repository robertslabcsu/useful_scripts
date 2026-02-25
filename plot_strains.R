# Load required libraries
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(ggplot2))

#' Generate Mutant Strain Plot
#'
#' This function loads mutant strain data, calculates summary statistics, 
#' and generates a formatted plot saved as an SVG. It automatically formats 
#' strain names containing " d" to use the Greek Delta symbol.
#'
#' @param input_csv Path to the input CSV file.
#' @param output_svg Path where the output SVG plot will be saved (default: "strain_plot.svg").
#' @return The generated ggplot object (invisibly).
#' @export
generate_mutant_plot <- function(input_csv, 
                                 output_svg = "strain_plot.svg") {
  
  # 1. Load and clean data
  df_filtered <- read.csv(input_csv, header = TRUE) %>%
    mutate(
      dpi = as.factor(Day),
      Strain = droplevels(as.factor(Strain)) # Ensures clean factor levels
    )
  
  # 2. Modify Strain Labels (replace " d" with Greek delta " Δ")
  levels(df_filtered$Strain) <- gsub(" d", " \u0394", levels(df_filtered$Strain))
  
  # 3. Create Summary Statistics
  df_summary <- df_filtered %>%
    group_by(dpi, Strain) %>%
    summarise(
      sd = sd(logcfu.cm2, na.rm = TRUE),
      logcfu.cm2 = mean(logcfu.cm2, na.rm = TRUE),
      .groups = "drop" # Best practice to avoid dplyr warnings
    ) %>%
    arrange(desc(logcfu.cm2))
  
  # 4. Generate the Plot
  p <- ggplot(data = df_filtered, aes(x = dpi, y = logcfu.cm2, color = Strain, fill = Strain)) +
    geom_point(size = 4, position = position_jitterdodge(dodge.width = 1, seed = 2023)) +
    geom_vline(xintercept = 1.5) +
    geom_vline(xintercept = 2.5) +
    geom_errorbar(data = df_summary,
                  aes(ymin = logcfu.cm2 - sd, ymax = logcfu.cm2 + sd),
                  width = 0.4,
                  position = position_dodge(1),
                  color = "black") +
    scale_y_continuous(breaks = c(0, 2, 4, 6, 8, 10), limits = c(0, 10)) +
    stat_summary(geom = "crossbar", fun = mean, position = position_dodge(width = 1),
                 width = 0.3, size = 0.25, color = "black") +
    labs(x = "Days post inoculation",
         y = bquote(log(CFU / cm^2))) +
    theme_bw(base_size = 25)
  
  # 5. Save the Plot
  ggsave(filename = output_svg, plot = p, width = 10, height = 10)
  
  # Return the plot invisibly so it can be assigned to a variable if needed
  invisible(p)
}

# --- Command Line Execution Logic ---
# This block only runs if the script is executed from the terminal/command line
if (sys.nframe() == 0) {
  # Capture command line arguments
  args <- commandArgs(trailingOnly = TRUE)
  
  # Check if at least one argument (the input CSV) was provided
  if (length(args) == 0) {
    stop("Error: No input file provided.\nUsage: Rscript plot_mutants.R <input.csv> [output.svg]", call. = FALSE)
  }
  
  input_file <- args[1]
  
  # Use the second argument as the output name if provided, otherwise default
  if (length(args) >= 2) {
    output_file <- args[2]
  } else {
    output_file <- "strain_plot.svg"
  }
  
  cat("Processing data from:", input_file, "\n")
  
  # Run the function
  generate_mutant_plot(input_csv = input_file, output_svg = output_file)
  
  cat("Plot successfully saved to:", output_file, "\n")
}
