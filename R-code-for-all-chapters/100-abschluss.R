library(tidyverse)
library(easystats)

ggplot2::theme_set(theme_minimal())


data(mtcars)

url <- "https://raw.githubusercontent.com/sebastiansauer/Lehre/main/Material/yacsdas-vis.md"
childtext <- readLines(url)
cat(childtext, sep="\n")

url <- "https://raw.githubusercontent.com/sebastiansauer/Lehre/main/Material/yacsdas-EDA.md"
childtext <- readLines(url)
cat(childtext, sep="\n")

url <- "https://raw.githubusercontent.com/sebastiansauer/Lehre/main/Material/yacsdas-lm.md"
childtext <- readLines(url)
cat(childtext, sep="\n")


data(mtcars)
sd(mtcars$mpg)
summary(mtcars$mpg)

mtcars |> 
  filter(am == 0) |> 
  nrow()

mtcars |> 
  count(am)

10^3 == 1000 
1e3 == 1000
