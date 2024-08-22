library(tidyverse)
library(yardstick)  # für Modellgüte im Test-Sample
library(easystats)
library(ggpubr)  # Daten visualisieren

library(ggpubr)
library(plotly)
library(openintro)  # dataset mariokart

source("children/colors.R")

mariokart_path <- "https://vincentarelbundock.github.io/Rdatasets/csv/openintro/mariokart.csv"
mariokart <- read.csv(mariokart_path)

wetter_path <- "https://raw.githubusercontent.com/sebastiansauer/Lehre/main/data/wetter-dwd/precip_temp_DWD.csv"
wetter <- read.csv(wetter_path)

wetter_path <- "https://raw.githubusercontent.com/sebastiansauer/Lehre/main/data/wetter-dwd/precip_temp_DWD.csv"
wetter <- read.csv(wetter_path)

wetter

lm_wetter1 <- lm(temp ~ year, data = wetter)
parameters(lm_wetter1)

parameters(lm_wetter1)

wetter_summ <-
  wetter %>% 
  group_by(year) %>% 
  summarise(temp = mean(temp),
            precip = mean(precip))  # precipitation: engl. für Niederschlag

lm_wetter1a <- lm(temp ~ year, data = wetter_summ)
parameters(lm_wetter1a)

parameters(lm_wetter1a) %>% print_md()

plot(estimate_relation(lm_wetter1)) 
plot(estimate_relation(lm_wetter1a))

wetter <-
  wetter %>% 
  mutate(year_c = year - mean(year))  # "c" wie centered

wetter %>% 
  summarise(mean(year))

lm_wetter1_zentriert <- lm(temp ~ year_c, data = wetter)
parameters(lm_wetter1_zentriert)

parameters(lm_wetter1_zentriert) %>% print_md()

r2(lm_wetter1_zentriert)  # aus `{easystats}`

predict(lm_wetter1_zentriert, newdata = tibble(year_c = 100))

year <- c(1940, 1950, 1960)
after_1950 <- year > 1950  # prüfe ob as Jahr größer als 1950 ist
after_1950

wetter <-
  wetter %>% 
  mutate(after_1950 = year > 1950) %>% 
  filter(region != "Deutschland")  # ohne Daten für Gesamt-Deutschland

lm_wetter_bin_uv <- lm(temp ~ after_1950, data = wetter)

d <- tribble(
  ~id, ~after_1950, ~after_1950TRUE,
  1,   TRUE,       1,
  2,  FALSE,       0
)

d[1:2] |> kable()

d[c(1,3)] |> kable()

d2 <- tribble(
  ~id, ~geschlecht, ~geschlechtMann,
  1,   "Mann",       1,
  2,  "Frau",       0
)

d2[1:2] %>% kable()

d2 <- tribble(
  ~id, ~geschlecht, ~geschlechtMann,
  1,   "Mann",       1,
  2,  "Frau",        0
)

d2[c(1,3)] %>% kable()


wetter %>% 
  group_by(after_1950) %>% 
  summarise(temp_mean = mean(temp))

wetter4 <-
  wetter |> 
  filter(month == 7, region == "Bayern") |> 
  mutate(after1950_TRUE = ifelse(after_1950, 1, 0)) 

lm4 <- lm(temp ~ after1950_TRUE, data = wetter4)

wetter4 %>% 
  ggplot(aes(x = after1950_TRUE, y = temp)) +
  geom_jitter(alpha = .5, width = .2) +
  #geom_violin(alpha = .7) +
  theme_minimal() +
  geom_abline(slope =  coef(lm4)[2], intercept =  coef(lm4)[1], color = "grey20") +
  stat_summary(fun = "mean", color = "grey20") +
  annotate("point", x = 0, y = coef(lm4)[1], 
           color = beta0col, size = 5) +
  annotate("label", x = 0, y = coef(lm4)[1], 
           color = beta0col, label = "hat(beta)[0]",
           parse = TRUE, hjust = "left") +
  geom_segment(x = 1, y = coef(lm4)[1], yend = coef(lm4)[1] + coef(lm4)[2], 
               color = beta1col,
               linewidth = 1.2,
             arrow = arrow(length = unit(0.03, "npc"))) +
  annotate("label", x = 1, y = coef(lm4)[1] +  coef(lm4)[2]*0.5, 
           color = beta1col, label = "hat(beta)[1]",
           parse = TRUE, hjust = 2) +
  scale_x_continuous(breaks = c(0, 1)) +
  coord_cartesian(ylim = c(16, 18)) +
  annotate("label", x = c(0, 1), y = 16, label = c("bis 1950", "nach 1950"))
  

lm_wetter_region <- lm(temp ~ region, data = wetter)
parameters(lm_wetter_region)

parameters(lm_wetter_region) %>% print_md()

d <- tribble(
  ~id, ~Bundesland, ~BL_Bayern, ~BL_Bra,
  1,   "BaWü",       0,   0,
  2,  "Bayern",       1,  0,
  3, "Brandenburg",   0,  1
)

d[1:2] %>% kable()

d[c(1,3, 4)] %>% kable()

wetter_summ <- 
  wetter %>% 
  group_by(region) %>% 
  summarise(temp = mean(temp)) %>% 
  mutate(id = 0:15) %>% 
  ungroup() %>%
  mutate(grandmean = mean(temp),
         delta = temp - grandmean)

wetter_summ %>%  
# filter(region != "Deutschland") %>% 
  ggplot(aes(y = region, x = temp)) +
  theme_minimal() +
  geom_label(aes(label = paste0("b", id),
                 x = grandmean + delta), 
             vjust = 1,
             size = 2) +
  #stat_summary(fun = "mean", color = "grey20") + 
  geom_vline(xintercept = coef(lm_wetter_region)[1], linetype = "dashed", color = okabeito_colors()[2]) +
  coord_cartesian(xlim = c(7, 10), ylim = c(0, 16))  +
  
  #coord_flip() +
  annotate("label",
           y = 1,
           x = coef(lm_wetter_region)[1],
           vjust = 1,
           label = paste0("b0"),
           #size = 6,
           color = beta0col) +
  annotate("point", 
           y = 1, 
           x = coef(lm_wetter_region)[1], 
           color = beta0col,
           #vjust = 1,
           size = 4) +
  geom_segment(aes(yend = region, xend = temp), 
               x = coef(lm_wetter_region)[1])  +
    geom_point() +
  labs(y = "",
       x = "Temperatur")

lm_wetter_month <- lm(precip ~ month, data = wetter)
parameters(lm_wetter_month)

parameters(lm_wetter_month) %>% print_md()

wetter <-
  wetter %>% 
  mutate(month_factor = factor(month))

lm_wetter_month_factor <- lm(precip ~ month_factor, data = wetter)
parameters(lm_wetter_month_factor)

parameters(lm_wetter_month_factor) %>% print_md()

wetter <-
  wetter %>% 
  mutate(month_factor = relevel(month_factor, ref = "7"))

levels(wetter$month_factor)

wetter_month_1_7 <-
  wetter %>% 
  filter(month == 1  | month == 7) 

geschlecht <- c("f", "f", "m")
geschlecht_factor <- factor(geschlecht)
geschlecht_factor

wetter_month_1_7 <-
  wetter %>% 
  filter(month == 1  | month == 7) %>% 
  mutate(month_factor = factor(month))  # Faktor (und damit die Faktorstufen) neu berechnen

lm_year_month <- lm(precip ~ year_c + month_factor, data = wetter_month_1_7)

parameters(lm_year_month) %>% print_md()

neue_daten <- tibble(year_c = 2020-1951,
                     month_factor = factor("1"))
predict(lm_year_month, newdata = neue_daten)

ggplot(wetter_month_1_7) +
  aes(x = year_c, 
      y = precip, 
      color = month_factor,
      group = month_factor) +
  geom_point2(alpha = .1) +
  scale_color_okabeito() +
  geom_abline(slope = coef(lm_year_month)[2],
              intercept = coef(lm_year_month)[1], color = okabeito_colors()[1], size = 2) +
  geom_abline(slope = coef(lm_year_month)[2],
              intercept = coef(lm_year_month)[1] + coef(lm_year_month)[3], color = okabeito_colors()[2], size = 2) +
  annotate("label", x = Inf,
           y = predict(lm_year_month, newdata = tibble(year_c = 50, month_factor = factor("1"))),
           label = "month 1", hjust = 1.1) +
  scale_x_continuous(limits = c(-100, 100)) +
  theme(legend.position = "none") +
  annotate("label", x = Inf,
           y = predict(lm_year_month, newdata = tibble(year_c = 50, month_factor = factor("7"))),
           label = "month 7", hjust = 1.1)


r2(lm_year_month)

lm_year_month_interaktion <- lm(
  precip ~ year_c + month_factor + year_c:month_factor, 
  data = wetter_month_1_7)

## plot(estimate_expectation(lm_year_month_interaktion)) +
##   scale_color_okabeito()  # schönes Farbschema

ggplot(wetter_month_1_7) +
  aes(x = year_c, 
  y = precip, 
  color = month_factor,
  group = month_factor) +
  geom_point2(alpha = .1) +
  geom_smooth(method = "lm", size = 2, fullrange = TRUE) +
  scale_color_okabeito() +
scale_x_continuous(limits = c(-100, 100)) +
  theme(legend.position = "none") +
  annotate("label", x = Inf,
           y = predict(lm_year_month_interaktion, newdata = tibble(year_c = 50, month_factor = factor("7"))),
           label = "month 7", hjust = 1.1) +
  annotate("label", x = Inf,
           y = predict(lm_year_month_interaktion, newdata = tibble(year_c = 50, month_factor = factor("1"))),
           label = "month 1", hjust = 1.1) 

parameters(lm_year_month_interaktion) %>% print_md()

r2(lm_year_month_interaktion)  # aus `{easystats}`

source("children/3d.R")
scatterplot_3d_with_trace

lm3d_expect <- estimate_relation(lm3d)
plot(lm3d_expect)

data(mariokart, package = "openintro")

lm_mario_2uv <- lm(total_pr ~ start_pr + ship_pr, data = mariokart %>% filter(total_pr < 100))

lm_coefs <- coef(lm_mario_2uv)

start_seq <- seq(0, 70, by = 1)
ship_seq <- seq(0, 10, by = 1)

z2 <- t(outer(start_seq, ship_seq,
            function(x,y) {lm_coefs[1] + lm_coefs[2]*x + lm_coefs[3]*y}))

plot_ly(x = ~ start_seq,
        y = ~ ship_seq,
        z = ~ z2,
        type = "surface") %>% 
  add_trace(data = mariokart %>% filter(total_pr < 100),
            x = ~start_pr,
            y = ~ship_pr,
            z = ~total_pr,
            mode = "markers",
            type = "scatter3d")

## # library(readr)
## #write_csv(mariokart_train, "daten/mariokart_train.csv")
## #write_csv(mariokart_test, "daten/mariokart_test.csv")

## mariokart_train <- read.csv("daten/mariokart_train.csv")

mariokart_train <- read.csv("https://raw.githubusercontent.com/sebastiansauer/statistik1/main/daten/mariokart_train.csv")

mariokart_test <- read.csv("https://raw.githubusercontent.com/sebastiansauer/statistik1/main/daten/mariokart_test.csv")

lm_allin <- lm(total_pr ~ ., data = mariokart_train)
r2(lm_allin)  # aus easystats

predict(lm_allin, newdata = mariokart_test)

mariokart_train2 <-
  mariokart_train %>% 
  select(-c(title, V1, id))

lm_allin_no_title <- lm(total_pr ~ ., data = mariokart_train2)
r2(lm_allin_no_title) 

performance::rmse(lm_allin_no_title)

mariokart_test %>% 
  select(id, total_pr) %>% 
  head()

lm_allin_predictions <- predict(lm_allin_no_title, newdata = mariokart_test)

head(lm_allin_predictions)

mariokart_test <-
  mariokart_test %>% 
  mutate(lm_allin_predictions = predict(lm_allin_no_title, newdata = mariokart_test))

library(yardstick)

yardstick::mae(data = mariokart_test,
               truth = total_pr,  # echter Verkaufspreis
               estimate = lm_allin_predictions)  # Ihre Vorhersage
yardstick::rmse(data = mariokart_test,
               truth = total_pr,  # echter Verkaufspreis
               estimate = lm_allin_predictions)  # Ihre Vorhersage

# `rsq ` ist auch aus dem Paket yardstick:
rsq(data = mariokart_test,
    truth = total_pr,  # echter Verkaufspreis
    estimate = lm_allin_predictions)  # Ihre Vorhersage

library(rsample)
mariokart <- read_csv("daten/mariokart.csv")  # Wenn die CSV-Datei in einem Unterordner mit Namen "daten" liegt

meine_aufteilung <- initial_split(mariokart, strata = total_pr)

set.seed(42)
meine_aufteilung <- initial_split(mariokart, strata = total_pr)

mariokart_train <- training(meine_aufteilung)  # Analyse-Sample
mariokart_test <- testing(meine_aufteilung)  # Assessment-Sample

## flowchart TD
##   S[Samples]
##   TS[Train-Sample]
##   TT[Test-Sample]
##   AS[Analyse-Sample]
##   AssS[Assessment-Sample]
## 
##   S-->TT
##   S-->TS
##   TS-->AS
##   TS-->AssS
## 

penguins <- read.csv("https://vincentarelbundock.github.io/Rdatasets/csv/palmerpenguins/penguins.csv")

ggscatter(penguins, x = "bill_length_mm", y = "bill_depth_mm", 
          add = "reg.line")  # aus `ggpubr`

lm1 <- lm(bill_depth_mm ~ bill_length_mm, data = penguins)

parameters(lm1) |> print_md()

ggscatter(penguins, x = "bill_length_mm", y = "bill_depth_mm", 
          add = "reg.line", color = "species")

lm2 <- lm(bill_depth_mm ~ bill_length_mm + species, data = penguins)

parameters(lm2) |> print_md()

n <- 100

set.seed(42)

d_sim <-
  tibble(
    x = rnorm(n, 0, 0.5),
    y = rnorm(n, 0, 0.5),
    group = "A"
  ) %>%
  bind_rows(
    tibble(
      x = rnorm(n, 1, 0.5),
      y = rnorm(n, 1, 0.5),
      group = "B")
  )

p_super_korr <- 
d_sim %>%
  ggplot(aes(x = x, y = y)) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(title = "Oh yeah, super Korrelation!") +
  theme_minimal() 

p_super_korr



d_sim %>%
  ggplot(aes(x = x, y = y, color = group)) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(title = "Oh nein, in beiden Gruppen keine Korrelation!") +
  theme(legend.position = "bottom") +
  theme_minimal() +
  scale_color_okabeito() +
  theme(
    legend.position = c(0.97, 0.05),  # Adjust these values to position the legend
    legend.justification = c(1, 0)) 
