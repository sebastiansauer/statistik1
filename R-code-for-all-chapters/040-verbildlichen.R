library(tidyverse)
library(easystats)
#library(anglr)
#library(maptools)
library(plotly)
library(scales)

source("_common.R")

library(tidyverse)
library(easystats)
library(DataExplorer)  # nicht vergessen zu installieren

theme_set(theme_modern())

mariokart <- read.csv("https://vincentarelbundock.github.io/Rdatasets/csv/openintro/mariokart.csv")

library("ggplot2")
library("datasauRus")
ggplot(datasaurus_dozen, aes(x = x, y = y, colour = dataset))+
  geom_point() +
  theme_void() +
  theme(legend.position = "none")+
  facet_wrap(~dataset, ncol = 4)

data(mariokart, package ="openintro")

mariokart |> 
  filter(total_pr < 100) |> 
  ggplot(aes(x = duration, y = total_pr, color = cond, size = wheels, shape = stock_photo)) +
  geom_point()

## NA

nom_plots <-
  tribble(
~Erkenntnisziel, ~qualitativ, ~quantitativ,
"Verteilung", "Balkendiagramm"," Histogramm und Dichtediagramm",
"Zusammenhang", "gefülltes Balkendiagramm", "Streudiagramm",
"Unterschied", "gefülltes Balkendiagramm", "Boxplot")

nom_plots |> knitr::kable()

mariokart |> 
  count(cond) %>% print_md()

mario_n1 <-
  mariokart |> 
  count(cond) |> 
  ggplot(aes(y = n, x = cond)) + 
  geom_col() +
  coord_flip() +
  theme_modern() + 
  labs(title = "horizontale Balekn")

mario_n2 <-
  mariokart |> 
  count(cond) |> 
  ggplot(aes(y = n, x = cond)) + 
  geom_col()   +
  theme_modern() + 
  labs(title = "vertikale Balken")

plots(mario_n1, mario_n2)

library(DataExplorer)
mariokart <- read.csv("https://vincentarelbundock.github.io/Rdatasets/csv/openintro/mariokart.csv")

mariokart %>% 
  select(cond) %>% 
  plot_bar()

mariokart |> 
  select(stock_photo) |> 
  plot_bar()

mariokart |> 
  filter(total_pr < 200) |> 
  mutate(total_pr = round(total_pr, digits = 1)) |> 
  ggplot(aes(x = total_pr)) +
  geom_bar()

m1a <- 
  mariokart |> 
  filter(total_pr < 100)

m1a |> 
  ggplot(aes(x = total_pr)) +
  geom_histogram(binwidth = 5, alpha = .7, center = 0, color = "white")  +
  geom_dotplot(binwidth = 1, method = "histodot") +
  labs(caption = paste0("n = ", nrow(m1a))) +
  scale_y_continuous(
    name = "Anzahl",
    sec.axis = sec_axis(trans = ~. / 141, name = "Anteil"))

p_mario_zu_viele <- 
  mariokart |> 
  filter(total_pr < 100) |> 
  ggplot(aes(x = total_pr)) +
  geom_histogram(binwidth = 1) 

p_mario_zu_viele

p_mario_zu_wenige <- 
  mariokart |> 
  filter(total_pr < 100) |> 
  ggplot(aes(x = total_pr)) +
  geom_histogram(bins = 2) 

p_mario_zu_wenige

mariokart %>% 
  select(total_pr) %>% 
  filter(total_pr < 100) %>%  # ohne Extremwerte
  plot_histogram(ggtheme = theme_minimal())

mariokart %>% 
  select(total_pr) %>% 
  filter(total_pr < 100) %>%  # ohne Extremwerte
  plot_density(ggtheme = theme_minimal())

mariokart |> 
  select(ship_pr) |> 
  plot_histogram()

m1a |> 
  ggplot(aes(x = total_pr, y = ..density..)) +
  geom_histogram(binwidth = 5, alpha = .7, center = 0)  +
  #geom_dotplot(binwidth = 1, method = "histodot") +
  geom_density(color = okabeito_colors()[1])
  #geom_dotplot(binwidth = 1, method = "histodot")

p_norm <- 
  ggplot(NULL) +
  stat_function(fun = dnorm, args = list(mean = 0, sd = 1)) +
  scale_x_continuous(limits = c(-3, 3))

p_norm

ggplot(NULL) +
  stat_function(fun = dgamma, args = list(shape = 2, rate = 3))  +
  scale_x_continuous(limits = c(0, 3))

source("funs/plot-distribs.R")
p_distribs <- plot_distribs()
p_distribs

mariokart |> 
  select(total_pr) |> 
  plot_density()

mariokart %>% 
  ggplot(aes(x = cond, fill = stock_photo)) +
  geom_bar(position = "fill") +
  scale_fill_okabeito() +
  theme(legend.position = "bottom") +
  theme_minimal()

mariokart %>% 
  ggplot(aes(x = wheels > 0, fill = stock_photo)) +
  geom_bar(position = "fill") +
  scale_fill_okabeito() +
  theme(legend.position = "bottom") +
  theme_minimal()

mariokart %>% 
  select(cond, stock_photo) %>% 
  plot_bar(by = "cond")  # aus dem Paket DataExplorer

mariokart |> 
  # Mache aus einer metrischen eine nominale Variable: 
  mutate(wheels = factor(wheels)) |> 
  select(cond, wheels) |> 
  plot_bar(by = "cond")

library(ggpubr)
mariokart %>% 
  select(total_pr, start_pr) %>% 
  filter(total_pr < 100) %>% 
  filter(start_pr > 10) %>% 
  ggscatter(x = "start_pr", 
            y = "total_pr",
            add = "reg.line",
            add.params = list(color = "blue"),
            ellipse = TRUE)


mariokart %>% 
  #select(total_pr, start_pr) %>% 
  filter(total_pr < 100) %>% 
  filter(start_pr > 10) %>% 
  ggscatter(x = "n_bids", 
            y = "total_pr",
            add = "reg.line",
            add.params = list(color = "blue"),
            ellipse = TRUE)


data <- read.csv("daten/nonlinear_datasets.csv")

p0 <- ggplot(data) + geom_point()  + theme_void() 

p1 <- p0 + aes(x=x1, y=y1) + ggtitle("Quadratischer Zusammenhang") 
p2 <- p0 + aes(x=x2, y=y2) + ggtitle("Exponenzieller Zusammenhang")
p3 <- p0 + aes(x=x3, y=y3) + ggtitle("Sinus-Zusammenhang")
p4 <- p0 + aes(x=x4, y=y4) + ggtitle("Logarithmischer Zusammenhang")

plots(p1, p2, p3, p4, n_rows = 2, tags = "A")

source("funs/plot-different-cors.R")
fig_cors <- plot_different_cors(plot_it = FALSE)
fig_cors +
  theme_void()

source("funs/plot-different-cors.R")
fig_cors2 <- plot_different_cors(plot_it = FALSE, short = TRUE)
fig_cors2

mariokart %>% 
  select(duration, n_bids, start_pr, ship_pr, total_pr, seller_rate, wheels) %>% 
  plot_scatterplot(by = "total_pr")

mariokart_no_extreme <-
  mariokart %>% 
  filter(total_pr < 100)

mariokart_no_extreme %>% 
  select(duration, n_bids, start_pr, ship_pr, total_pr, seller_rate, wheels) %>% 
  plot_scatterplot(by = "total_pr")

mariokart_no_extreme |> 
  select(start_pr, total_pr) |> 
  plot_scatterplot(by = "total_pr")

ggplot(mariokart_no_extreme, aes(x = cond, y = total_pr)) +
  geom_violinhalf() +
  theme_minimal()


ggplot(mariokart_no_extreme, aes(x = cond, y = total_pr)) +
  geom_boxplot() +
  theme_minimal()

mariokart %>% 
  filter(total_pr < 100) %>% 
  ggpubr::ggboxplot(., x = "cond", y = "total_pr")

mariokart %>% 
  filter(total_pr < 100) %>% 
  ggpubr::ggboxplot(., x = "stock_photo", y = "total_pr")

source("funs/histogram-to-boxplot.R")
hist_to_box <- histogram_to_boxplot(mariokart_no_extreme, "total_pr", plot_it = FALSE)
hist_to_box +
  labs(caption = "Md: Median; Q1/3: 1./3. Quartil")


mariokart_no_extreme %>% 
  select(total_pr, wheels) %>% 
  plot_boxplot(by = "wheels")

mariokart_no_extreme %>% 
  select(total_pr, wheels) %>% 
  mutate(wheels = factor(wheels)) %>% 
  plot_boxplot(by = "wheels")

mariokart_no_extreme %>% 
  count(wheels)

mariokart_no_extreme |> 
  select(cond, total_pr) |> 
  plot_boxplot(by = "cond")

mariokart_no_extreme |> 
  select(ship_pr, total_pr) |> 
  plot_boxplot(by = "ship_pr")

d <- tibble(
  Jahr = c(1, 2, 3, 4, 5),
  Umsatz = c(100, 98, 94, 93, 70)
)

ggplot(d, aes(Jahr, Umsatz)) +
  geom_point(alpha = .7) +
  geom_line() +
  theme_minimal() +
  scale_y_continuous(limits = c(0, 100)) +
   coord_fixed(ratio = .10)

ggplot(d, aes(Jahr, Umsatz)) +
  geom_point(alpha = .7) +
  geom_line() +
  theme_minimal() +
  scale_y_continuous(limits = c(0, 100)) +
  coord_fixed(ratio = .010)


d <- tibble(
  Jahr = c(1, 2, 3, 4, 5),
  Umsatz = c(100, 98, 94, 93, 70)
)

ggplot(d, aes(Jahr, Umsatz)) +
  geom_point(alpha = .7) +
  geom_line() +
  theme_minimal()

ggplot(d, aes(Jahr, Umsatz)) +
  geom_point(alpha = .7) +
  geom_line() +
  theme_minimal() +
  scale_y_continuous(limits = c(0, 100))

fig2 <- plot_ly(mariokart |> filter(total_pr < 100), x = ~duration, y = ~n_bids, z = ~total_pr, color = ~cond, colors = c('#BF382A', '#0C4B8E'))
fig2 <- fig2 %>% add_markers()
fig2 <- fig2 %>% layout(scene = list(xaxis = list(title = 'duration'),
                     yaxis = list(title = 'number of bids'),
                     zaxis = list(title = 'total price')))

fig2

## library(ggpubr)  # einmalig instalieren nicht vergessen
## mariokart %>%
##   filter(total_pr < 100) %>%
##   ggboxplot(x = "cond", y = "total_pr")

ggviolin(mariokart_no_extreme, x = "cond", y = "total_pr",
         add = "mean_sd") 

library(ggstatsplot)

gghistostats(
  data       = mariokart_no_extreme,
  x          = total_pr,
  xlab       = "Verkaufspreis" 
  # results.subtitle = FALSE   # unterdrückt statistische Kennzahlen
)

mariokart %>% 
  filter(total_pr < 100) %>% 
  ggboxplot(x = "cond", y = "total_pr", fill = "cond") +
  scale_fill_okabeito()
