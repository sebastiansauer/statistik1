
set.seed(42)

library(knitr)
# define a method for objects of the class data.frame
knit_print.head = function(x, ...) {
  res = paste(c('', '', kable(head(x))), collapse = '\n')
  asis_output(res)
}
# register the method
registerS3method("knit_print", "data.frame", knit_print.head)

base_size <- 18
base_family <- "Lato Regular"


# Define a custom ggplot theme with larger text
theme_large_text <- function(base_size = 18) {
  theme_minimal(base_size = base_size) +
    theme(
      text = element_text(size = base_size + 4),          # Base text size
      axis.title = element_text(size = base_size + 6),    # Axis title text size
      axis.text = element_text(size = base_size + 4),     # Axis tick text size
      plot.title = element_text(size = base_size + 10, face = "bold"), # Plot title size
      plot.subtitle = element_text(size = base_size + 8), # Subtitle text size
      legend.text = element_text(size = base_size + 4),   # Legend text size
      legend.title = element_text(size = base_size + 6)   # Legend title text size
    )
}



ggplot2::theme_set(see::theme_modern())

knitr::opts_chunk$set(tidy = FALSE, 
                      width = 60, 
                      fig.retina = 2,
                      max.print = 100,
                      fig.dpi = 300,
                      warning = FALSE,
                      out.width = "70%", # enough room to breath
                      fig.width = 6,     # reasonable size
                      fig.asp = 0.618,   # golden ratio
                      fig.align = "center" # mostly what I want
)


options(
  dplyr.print_min = 6,
  dplyr.print_max = 6,
  pillar.max_footer_lines = 2,
  pillar.min_chars = 15,
  stringr.view_n = 6,
  # Temporarily deactivate cli output for quarto
  cli.num_colors = 0,
  cli.hyperlink = FALSE,
  pillar.bold = TRUE,
  digits = 2,
  width = 77 # 80 - 3 for #> comment
)

   

ycol <- "#E69F00"
modelcol <- "#56B4E9"
errorcol <- "#009E73"
beta0col <- "#D55E00"
beta1col <- "#0072B2"
xcol <- "#CC79A7"

yellow <- "#F0E442FF"
blue <- "#0072B2FF"
orange <- "#E69F00FF"




#ggplot2::theme_set(see::theme_modern(axis.title.size = 18))

labeltextsize <- 8



utils::data("mariokart", package = "openintro")

mariokart_no_extreme <- mariokart[mariokart$total_pr < 100, ]


mariokart_path <- "https://vincentarelbundock.github.io/Rdatasets/csv/openintro/mariokart.csv"





if (knitr:::is_latex_output()) {
  
  # add font for plots in PDF output:
  
  showtext::showtext_auto(TRUE)  # use "showtext" automatically
  
  sysfonts::font_add("Lato Regular", regular = "/Users/sebastiansaueruser/Library/Fonts/Lato-Regular.ttf")
  
  sysfonts::font_add("Lato", regular = "/Users/sebastiansaueruser/Library/Fonts/Lato-Regular.ttf")
  
  sysfonts::font_add("Font Awesome", regular = "~/Library/Fonts/fontawesome-webfont.ttf")
  
  sysfonts::font_add("Roboto Regular", regular = "/Users/sebastiansaueruser/Library/Fonts/Roboto-Regular.ttf")
  

  
  ggplot2::theme_set(ggplot2::theme_minimal())
  
  }
