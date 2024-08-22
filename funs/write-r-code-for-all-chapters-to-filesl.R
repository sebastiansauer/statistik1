write_r_code_to_files <- function(path_to_qmd_files = ".", 
                                  pattern = "\\d{3}-.*\\.qmd$",
                                  output_path = "R-code-for-all-chapters/") {
  
  library(stringr)
  library(purrr)
  
  source_file_names <- list.files(path = path_to_qmd_files, pattern = pattern)
  
  output_file_names <- 
    source_file_names |> 
    str_sub(end = -5) |> 
    str_c(".R")
  
  
  output_file_names_with_path <- paste0(output_path, output_file_names)
  
  
  source_files |> 
    map2(.x = source_file_names,
         .y = output_file_names_with_path,
         .f = ~ knitr::purl(.x, output = .y, documentation = 0))
  
}

write_r_code_to_files(pattern = "\\d{3}-.*\\.qmd$")

