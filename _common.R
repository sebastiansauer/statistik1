





library(knitr)
# define a method for objects of the class data.frame
knit_print.head = function(x, ...) {
  res = paste(c('', '', kable(head(x))), collapse = '\n')
  asis_output(res)
}
# register the method
registerS3method("knit_print", "data.frame", knit_print.head)

