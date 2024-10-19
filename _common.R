
set.seed(42)

library(knitr)
# define a method for objects of the class data.frame
knit_print.head = function(x, ...) {
  res = paste(c('', '', kable(head(x))), collapse = '\n')
  asis_output(res)
}
# register the method
registerS3method("knit_print", "data.frame", knit_print.head)

ggplot2::theme_set(see::theme_modern())

knitr::opts_chunk$set(tidy = FALSE, 
                      width = 60, 
                      fig.retina = 2,
                      fig.asp = 2/3,
                      max.print = 100,
                      warning = FALSE)


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


ggplot2::theme_set(ggplot2::theme_minimal())

#ggplot2::theme_set(see::theme_modern(axis.title.size = 18))


