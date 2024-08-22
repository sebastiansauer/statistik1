library(tidyverse)
library(easystats)

source("_common.R")

library(ggpubr)
library(TeachingDemos)
library(gt)
#library('MASS')

mariokart <- read.csv("https://vincentarelbundock.github.io/Rdatasets/csv/openintro/mariokart.csv")

data(mariokart, package = "openintro")

mariokart %>% 
  filter(total_pr < 100) %>% 
  ggscatter(x = "wheels", 
            y = "total_pr",
            add = "reg.line",
            add.params = list(color = "blue"),
            ellipse = TRUE)

mariokart %>% 
  filter(total_pr < 100) %>% 
  ggplot() +
  aes(x = wheels, y = total_pr) +
  geom_jitter()

d <- tibble::tribble(
  ~id, ~y, ~x,
   1L,   72,     70,
   2L,   44,     40,
   3L,   39,     35,
   4L,   50,     67
  ) %>% 
  mutate(x_avg = mean(x),
         y_avg = mean(y),
         x_delta = x - mean(x),
         y_delta = y - mean(y),
         x_pos = x > mean(x),
         y_pos = y > mean(y),
         cov_sign = sign(x_delta * y_delta),
         xy_area = x_delta * y_delta)

#write.csv(d, file = "noten.csv")

# cor(d$punkte, d$lernzeit)
#plot(d$lernzeit, d$punkte)
cov_xy <- cov(d$y, d$x)

d %>% 
  select(id, y, x) %>% 
  kable() 

p_cov <- 
ggplot(d) +
  aes(x = x, y = y) +
  geom_vline(xintercept = mean(d$x), linetype = "dashed") +
  geom_hline(yintercept = mean(d$y), linetype = "dashed") +
  geom_rect(aes(xmin = x, xmax = x_avg, ymin = y, ymax = y_avg,
                fill = factor(cov_sign)),
            alpha = .5) +
  labs(x = "Lernzeit",
       y = "Punkte (0-100)",
       fill = "Vorzeichen") + 
  theme_minimal() +
  annotate("label", x = Inf, y = Inf, 
           label = "Q1: +", hjust = "right", vjust = "top") +
  annotate("label", x = Inf, y = -Inf, 
           label = "Q2: -", hjust = "right", vjust = "bottom") +
  annotate("label", x = -Inf, y = -Inf, 
           label = "Q3: +", hjust = "left", vjust = "bottom") +
  annotate("label", x = -Inf, y = Inf, 
           label = "Q4: -", hjust = "left", vjust = "top") +
    geom_point(size = 2, color = "black") +
  scale_fill_okabeito() +
  theme(
    legend.position = c(0.95, 0.05),  # Adjust these values to position the legend
    legend.justification = c(1, 0)    # 1 = right, 0 = bottom
  )

p_cov

## Positive correlation
x <- rnorm(25)
y <- x + rnorm(25,3, .5)
#cor(x,y)
cor.rect.plot(x,y)
## negative correlation
x <- rnorm(25)
y <- rnorm(25,10,1.5) - x
#cor(x,y)
cor.rect.plot(x,y)

## p_cov2 <-
## p_cov +
##   geom_rect(aes(xmin = -Inf,
##                 xmax = Inf,
##                 ymin = -Inf,
##                 ymax = Inf),
##             fill = "gray",
##             alpha = 0.2,
##             inherit.aes = FALSE) +
##   geom_rect(aes(xmin = mean(d$x) - sqrt(cov_xy)/2,
##                 xmax = mean(d$x) + sqrt(cov_xy)/2,
##                 ymin = mean(d$y) - sqrt(cov_xy)/2,
##                 ymax = mean(d$y) + sqrt(cov_xy)/2)) +
##   geom_text(aes(x = mean(d$x), y = mean(d$y),
##                 label = "Kovarianz:\nmittleres\nAbweichungsrechteck"),
##             color = "white") +
##   theme(
##     legend.position = c(0.95, 0.05),  # Adjust these values to position the legend
##     legend.justification = c(1, 0))
## 
## p_cov2

d %>% 
  kable()

d %>%
  summarise(kovarianz = mean(xy_area))

# zero correlation
points1 <- data.frame(
  x = c(1,1,2,2,4,4,5,5),
  y = c(1,5,2,4,2,4,5,1)
)

cor.rect.plot(y = points1$y, x = points1$x,
              xlab = "X", ylab = "Y")

# perfect correlation
points2 <- data.frame(
  x = c(1,2,3,4,5,6,7),
  y = c(1,2,3,4,5,6,7)
)

cor.rect.plot(y = points2$y, x = points2$x,
              xlab = "X", ylab = "Y")

# perfect negative correlation
points3 <- data.frame(
  x = c(1,2,3,4,5,6,7),
  y = c(2.1,6,5,4,3,2,1)
)


cor.rect.plot(y = points3$y, x = points3$x,
              xlab = "X", ylab = "Y")



# zero correlation
points1 <- data.frame(
  x = c(1,1,2,2,4,4,5,5),
  y = c(1,5,2,4,2,4,5,1)
)

#cor(points1$x, points1$y)

cor.rect.plot(y = points1$y, x = points1$x,
              xlab = "X", ylab = "Y")


# simulated data, uncorrelated
samples = 200
r = 0


data = MASS::mvrnorm(n=samples, mu=c(0, 0), Sigma=matrix(c(1, r, r, 1), nrow=2), empirical=TRUE)

data.df <- data.frame(data)

# p1 <- ggplot(data.df, aes(x=X1, y=X2)) + geom_point() + 
#   theme(text = element_text(size = 18))
# p1

cor.rect.plot(y = data.df$X1, x = data.df$X2,
              xlab = "X", ylab = "Y")

mariokart |> 
  select(total_pr, duration, n_bids) |> 
  correlation()  # aus `easystats`

## mariokart |>
##   select(total_pr, duration, n_bids) |>
##   correlation() |>
##   summary()

mariokart |> 
  select(total_pr, duration, n_bids) |> 
  correlation() |> 
  summary() |> 
  print_md()

set.seed(42)
n <- 1e2
d <-
  tibble(x = rnorm(n = n, mean = 0, sd = 1),
         e = rnorm(n = n, mean = 0, sd = .5),
         y = x + e)

x_min <- -0.5
x_max <- 0.5

d_filtered <-
d |> 
  filter(between(x, x_min, x_max))

d |> 
ggplot(aes(x = x, y = y)) +
  geom_point() +
  labs(title = paste0("r: ", round(cor(d$x, d$y), 2))) +
  theme_modern()

d_filtered |>   
ggplot(aes(x = x, y = y)) +
  annotate("rect", xmin = x_min, xmax = x_max, ymin = -Inf, ymax = Inf, fill = okabeito_colors()[1], alpha = .5) +
  geom_point(data = d, color = "grey80") +
  geom_point() +
  labs(title = paste0("r: ", round(cor(d_filtered$x, d_filtered$y), 2))) +
  theme_modern()
  

## mariokart <- read.csv("mariokart.csv")

## mariokart <- read.csv("Mein_Unterordner/mariokart.csv")

mariokart <- read.csv("https://vincentarelbundock.github.io/Rdatasets/csv/openintro/mariokart.csv")

mariokart %>%  
  dplyr::select(duration, n_bids, start_pr, ship_pr, total_pr, seller_rate, wheels) %>% 
  cor() %>% 
  round(2) # Runden auf zwei Dezimalen

mariokart %>% 
  dplyr::select(duration, n_bids, start_pr, ship_pr, total_pr, seller_rate, wheels) %>% 
  correlation() 

mariokart %>% 
  summarise(cor_super_wichtig = cor(total_pr, wheels))

mariokart %>% 
  summarise(cor_super_wichtig = cor(total_pr, wheels, use = "complete.obs"))

library(DataExplorer)

mariokart %>% 
  dplyr::select(duration, n_bids, start_pr, ship_pr, total_pr, seller_rate, wheels) %>% 
  plot_correlation()
