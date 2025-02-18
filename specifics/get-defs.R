# Load necessary libraries:
library(stringr)

# Define the path to the directory containing your Quarto files:
quarto_dir <- "."

# Define the pattern to match the definition shortcode:
pattern_def <- ':::\\{#def-(.+?)\\}'
pattern_word <- '(.+)'  # Definitions follow the ID of the def.

# Initialize an empty list to store definitions:
definitions <- list()

# Function to read all files in a directory recursively:
read_files <- function(path = ".") {
  files <- list.files(path, recursive = FALSE, full.names = TRUE, pattern = "\\.qmd$")
  return(files)
}

# Get all Quarto files:
files <- read_files(quarto_dir)

# Iterate over all files and extract definitions:
for (file in files) {
  content <- readLines(file, warn = FALSE)
  
  # Use a loop to go through lines and capture definitions and their corresponding words:
  for (i in seq_along(content)) {
    def_match <- str_match(content[i], pattern_def)
    if (!is.na(def_match[1])) {
      term <- def_match[2]
      
      # Look ahead to find the word pattern
      j <- i + 1
      while (j <= length(content) && content[j] == "") {
        j <- j + 1
      }
      
      if (j <= length(content)) {
        word_match <- str_match(content[j], pattern_word)
        if (!is.na(word_match[1])) {
          word <- word_match[1]
          # Remove "### " from the word if it exists:
          word <- str_replace(word, "### ", "")
          definitions <- append(definitions, list(c(term, word)))
        }
      }
    }
  }
}

# Sort definitions alphabetically by term:
definitions <- definitions[order(sapply(definitions, `[`, 1))]

# Write the definitions to a new Quarto file:
output_file <- file.path(quarto_dir, "definitions.qmd")
fileConn <- file(output_file, "w")
writeLines("# Definitionen\n\n", fileConn)

for (definition in definitions) {
  line <- paste0("- **", definition[2], "**: @def-", definition[1], " [, S. \\pageref{def-", definition[1], "}]{.content-visible when-format=\"pdf\"}\n\n")
  writeLines(line, fileConn)
}

close(fileConn)

cat("Extracted", length(definitions), "definitions to definitions file\n")
