library(tidyverse)
library(easystats)

library(gt)
library(ggrepel)
library(ggplot2)

theme_set(theme_minimal())
scale_colour_discrete <- function(...) 
  scale_color_okabeito()

mariokart <- read.csv("https://vincentarelbundock.github.io/Rdatasets/csv/openintro/mariokart.csv")

# set.seed(42)
# noten2 <-
#   tibble(
#     id = 1:100,
#     x = rnorm(100, mean = 73, sd = 10),
#     y = x + rnorm(100, 0, 10)
#   )
# write.csv(noten2, "daten/noten2.csv")

noten2 <- read.csv("daten/noten2.csv")

noten2 %>% 
  summarise(mw = mean(y))  # y ist der Punktwert in der Klausur

ggplot(noten2) +
  aes(id, y) +
  geom_point() +
  geom_hline(yintercept = mean(noten2$y), color = modelcol) +
  annotate("label", x = -Inf, y = mean(noten2$y), 
           label = paste0("MW: ", round(mean(noten2$y))), hjust = "left") +
  theme_minimal()

lm0 <- lm(y ~ 1, data = noten2)
lm0

## library(DataExplorer)
## noten2 %>%
##   plot_scatterplot(by = "y")  # Y-Variable muss angegeben werden

lm1 <- lm(y ~ x, data = noten2)
lm1_b0 <- coef(lm1)[1]
lm1_b2 <- coef(lm1)[2]

toni_punkte <- predict(lm1, newdata = data.frame(x=42))

#noten2 <- read.csv(noten2, "daten/noten2.csv")



ggplot(noten2) +
  aes(x, y) +
  geom_point() +
  labs(x = "Lernzeit",
       y = "Klausurpunkte") +
  theme_minimal()

noten2 %>% 
  ggplot(aes(x, y)) +
  geom_point() +
  geom_vline(xintercept = mean(noten2$x), linetype = "dashed", color = "grey") +  
  geom_hline(yintercept = mean(noten2$y), linetype = "dashed", color = "grey") +   
  geom_abline(slope = coef(lm1)[2], intercept = coef(lm1)[1], color = modelcol, size = 1.5) +
  theme_minimal() +
  annotate("label", x = mean(noten2$x), y = -Inf, 
           label = paste0("MW: ", round(mean(noten2$x))), vjust = "bottom") +
  annotate("label", y = mean(noten2$y), x = -Inf, 
           label = paste0("MW: ", round(mean(noten2$y))), hjust = "left")   +
  annotate("point", x = 42, y = toni_punkte, color = "red",
           alpha = .7, size = 7) +
  scale_x_continuous(breaks = c(40, 42, 60, 80, 100)) +
  labs(x = "Lernzeit",
       y = "Klausurpunkte")

set.seed(42)
d1 <- tibble::tibble(
  x1 = rnorm(50),
  y1 = 2 * x1 + rnorm(50, mean = 0, sd = .5)
)

set.seed(3141)
d2 <- tibble::tibble(
  x2 = rnorm(50),
  y2 = -x2 + rnorm(50, mean = 1, sd = .5)
)

lm11 <- lm(y1 ~ x1, data = d1)
lm11_coef <- coef(lm11)
lm12 <- lm(y2 ~ x2, data = d2)
lm12_coef <- coef(lm12)

cap1 <- paste0("Datensatz 1: b0 = ", round(lm11_coef[1], 2), "; b1 = ", round(lm11_coef[2], 2))
cap2 <- paste0("Datensatz 2: b0 = ", round(lm12_coef[1], 2), "; b1 = ", round(lm12_coef[2], 2))

ggplot(d1, aes(x1, y1)) + 
  geom_point() +
  geom_smooth(method = "lm", se = TRUE, color = okabeito_colors()[8]) +
  scale_y_continuous(limits = c(-4, 4)) +
  labs(title = paste0("b0 = ",round(lm11_coef[1], 2), "; b1 = ", round(lm11_coef[2]), 2)) +
  theme_modern()

ggplot(d2, aes(x2, y2)) + 
  geom_point() +
  geom_smooth(method = "lm", se = TRUE, color = okabeito_colors()[8]) +
  scale_y_continuous(limits = c(-4, 4)) +
  labs(title = paste0("b0 = ",round(lm12_coef[1], 1), "; b1 = ", round(lm12_coef[2]), 2)) +
  theme_modern()

lm1 <- lm(y ~ x, data = noten2)
lm1_b0 <- coef(lm1)[1]

noten2 %>% 
  ggplot(aes(x, y)) +
  geom_point() +
  geom_vline(xintercept = mean(noten2$x), linetype = "dashed", color = "grey") +  
  geom_hline(yintercept = mean(noten2$y), linetype = "dashed", color = "grey") +   
  geom_abline(slope = coef(lm1)[2], intercept = coef(lm1)[1], color = okabeito_colors()[8], size = 1.5) +
  theme_minimal() +
  scale_x_continuous(limits = c(0, 100)) +
  scale_y_continuous(limits = c(0, 100)) +
  annotate("point", x = 0, y = lm1_b0, color = "red", size = 7, alpha = .7) +
  annotate("label", x = mean(noten2$x), y = 0, vjust = "bottom",
           label = "MW Noten") +
  annotate("label", y = mean(noten2$y), x = 12, vjust = "left",
           label = "MW Klausurpunkte") +
  geom_text_repel(data = tibble(x = 0, y = predict(lm1, newdata = tibble(x = 0))), 
                  aes(x = x, y = y,), 
                  label = "Toni",
                  point.padding = 5,
                  size = 8)

tonis_lernzeit <- tibble(x = 0)  # `tibble` erstellt eine Tabelle
tonis_lernzeit

predict(lm1, newdata = tonis_lernzeit)

## lm(y ~ x, data = meine_daten)

lm1 <- lm(y ~ x, data = noten2)
lm1

lernzeit <- 10
y_pred <- 8.6 + 0.88*lernzeit
y_pred

tonis_lernzeit2 <- tibble(x = 73)  # Der Befehl `tibble` erstellt eine Tabelle in R.

tonis_lernzeit2

predict(lm1, newdata = tonis_lernzeit2)

noten2 <-
  noten2 %>% 
  mutate(yhat = predict(lm1, newdata = noten2))

noten2 %>% 
  ggplot(aes(x, y)) +
  geom_point(color = ycol) +
  geom_abline(slope = coef(lm1)[2], intercept = coef(lm1)[1], color = modelcol, size = 1.5) +
  theme_minimal() +
  geom_segment(aes(xend = x, yend = yhat), color = errorcol)

noten2 %>% 
  ggplot(aes(x, y)) +
  geom_point(color = ycol) +
  geom_hline(yintercept = mean(noten2$y), color = modelcol, size = 1.5) +
  theme_minimal() +
  geom_segment(aes(xend = x, yend = mean(noten2$y)), color = errorcol)


mae(lm0)
mae(lm1)

verhaeltnis_fehler_mae <- mae(lm1) / mae(lm0)
verhaeltnis_fehler_mae

mse(lm0)
mse(lm1)

verhaeltnis_fehler_mse <- mse(lm1)/mse(lm0)
verhaeltnis_fehler_mse

1 - verhaeltnis_fehler_mse

r2(lm1)

d0 <-
  tibble(x = rnorm(100),
         y = rnorm(100))

d0 %>% 
  ggplot(aes(x,y)) + 
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = modelcol) +
  theme_modern()


d_r1 =
  tibble(x = 1:10,
         y = seq(10, 100, by = 10))

d_r1 %>% 
  ggplot(aes(x,y)) + 
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = modelcol) +
  theme_modern()

lm1_b1 <- coef(lm1)[2] %>% round(2)

d <-
  tibble(r = seq(from = -1, to = 1, by = .01))

d <-
  d |> 
  mutate(r2 = r^2)


d |> 
  ggplot(aes(x = r, y = r2)) +
  geom_line() +
  theme_modern() +
  labs(y = "R-Quadrat",
       title = "Der Zusammenhang von r und R-Quadrat ist nicht linear.")

mariokart <- read.csv("https://vincentarelbundock.github.io/Rdatasets/csv/openintro/mariokart.csv")

lm2 <- lm(total_pr ~ start_pr, data = mariokart)
r2(lm2)

lm3 <- lm(total_pr ~ ship_pr, data = mariokart)
parameters(lm3)

parameters(lm3) %>% print_md()

estimate_expectation(lm3) %>% head()  # nur die ersten paar vorhergesagten Werte

neue_daten <- tibble(
  ship_pr = c(1, 4)  # zwei Werte zum Vorhersagen
)

predict(lm3, newdata = neue_daten)

estimate_expectation(lm3) %>% plot()

mae(lm3)

lm3_r2 <- round(r2(lm3)$R2, 2)

r2(lm3)

mae(lm3)
