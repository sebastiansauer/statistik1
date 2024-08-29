


ggplot2::theme_set(see::theme_modern(axis.title.size = 18))


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
                      max.print = 100,
                      warning = FALSE)
options(width=60)



   

ycol <- "#E69F00"
modelcol <- "#56B4E9"
errorcol <- "#009E73"
beta0col <- "#D55E00"
beta1col <- "#0072B2"
xcol <- "#CC79A7"
