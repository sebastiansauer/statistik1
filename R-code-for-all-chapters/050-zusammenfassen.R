library(tidyverse)
library(easystats)

source("_common.R")

library(gt)
library(mosaic)
#library(gganimate)

library(ggplot2)
ggplot2::theme_update(axis.title = ggplot2::element_text(size = 66))

mariokart <- read.csv("https://vincentarelbundock.github.io/Rdatasets/csv/openintro/mariokart.csv")

ggplot2::theme_set(theme_minimal())

d <- tibble::tribble(
  ~id, ~note, ~note_avg, ~delta, ~note2, ~note_avg2,
   1L,     2,     2.325, -0.325,  2.325,          2,
   2L,   2.7,     2.325,  0.375,    2.7,      2.325,
   3L,   3.1,     2.325,  0.775,    3.1,      2.325,
   4L,   1.5,     2.325, -0.825,  2.325,        1.5
  )

d$names <- c("Anna", "Berta", "Carl", "Dani")


d <- d %>% 
  mutate(delta_abs = abs(delta),
         pos = ifelse(delta > 0, "positiv", "negativ"),
         delta_sq = delta^2)


p_mean_deltas <- 
  d %>%
  ggplot(aes(x = id, 
             y = note)) +
  geom_hline(yintercept = mean(d$note), 
             linetype = "dashed") +
  geom_segment(aes(y = mean(d$note),
                   yend = note,
                   x = id,
                   xend = id,
                   linetype = pos,
                   color = pos),
               size = 2
               ) +
  geom_point(size = 5) + 
  labs(linetype = "Richtung der Abweichung") +
  theme(legend.position =  "bottom",
        legend.justification = c(1, 1)) +
  annotate(geom = "label",
           x = 0,
           hjust = 0,
           y = mean(d$note), 
           label = paste0("MW = ", round(mean(d$note), 2))) +
  scale_y_continuous(limits = c(1, 4)) +
  labs(x = "",
       y = "") +
  scale_x_continuous(breaks = 1:4, labels = d$names) +
  scale_color_okabeito() +
  guides(color = FALSE)

p_mean_deltas

set.seed(42)  # Zufallszahlen festlegen, hier nicht so wichtig
einkommen_studis <- rep(x = 1000, times = 100)  # "rep" wie "repeat": wiederhole 1000 USD 100 Mal
einkommen <- c(einkommen_studis, 120*1e6)  # 100 Studis mit 1000, 1 Mbappé mit 120 Mio
einkommen_mw <- mean(einkommen)
einkommen_mw




mariokart$X <- 1:nrow(mariokart)

mariokart <-
  mariokart %>% 
  mutate(is_extreme = total_pr > 100)

mariokart_extreme <-
  mariokart %>% 
  filter(is_extreme)

ggplot(mariokart) +
  aes(x = X, y = total_pr) +
    geom_hline(yintercept = mean(mariokart$total_pr),
             linewidth = 2) +
  geom_point(alpha = .7) +
  geom_point(data = mariokart_extreme, 
             color =  okabeito_colors()[1],
             alpha = .7,
             size = 8) +
  labs(caption = paste0("Mittelwert (MW): ", round(mean(mariokart$total_pr), 2)),
       x = "Nr. des Spiel") +
  scale_y_continuous(limits = c(0, 400)) +
  theme_minimal() +
  annotate("label", x = 0, y = 50, label = "MW", hjust = "left")

mariokart2 <- 
mariokart %>% 
  filter(total_pr < 100)
  
ggplot(mariokart2) +
  aes(x = X, y = total_pr) +
  geom_hline(yintercept = mean(mariokart2$total_pr),
             color = okabeito_colors()[2], 
             size = 2) +
  geom_point(alpha = .7) +
  labs(caption = paste0("Mittelwert (MW): ", round(mean(mariokart2$total_pr), 2)),
       x = "Nr. des Spiel") + 
  scale_y_continuous(limits = c(0, 400)) +
  theme_minimal()  +
  annotate("label", x = 0, y = 47, label = "MW", hjust = "left") +
  theme(axis.title = element_text(size = 18))


lm(einkommen ~ 1)  # lm wie "lineares Modell" oder engl. "linear modell"

d <-
  tibble(einkommen = einkommen,
         id = 1:length(einkommen))

p1 <- ggplot(d) +
  aes(x = einkommen) +
  geom_histogram() +
  theme_modern() +
  geom_vline(xintercept = c(mean(einkommen)), color = okabeito_colors()[1]) +
  geom_vline(xintercept = c(median(einkommen)), color = okabeito_colors()[2]) +
  annotate("label", x = median(einkommen), y = 100, label = "Median", color = okabeito_colors()[2]) +
  annotate("label", x = mean(einkommen), y = 0, label = "MW", color = okabeito_colors()[1]) +
  geom_label(
           x = Inf, 
           y = 10, 
           hjust = 1,
           label = "Extremwert") +
  labs(caption = "MW: Mittelwert",
  y = "Anzahl",
       x = "Einkommen")

p1

p1 +
  scale_x_continuous(trans = "log10") +
  labs(
    caption = "MW: Mittelwert"
  )


d <-
  tibble(id = 1:5,
         name = c("Anna", "Berta", "Carla", "Dora", "Emma"),
         einkommen = c(1, 2, 3, 4, 100))

d %>% 
  ggplot(aes(x = id, y = einkommen)) +
  geom_vline(xintercept = 3, color = okabeito_colors()[2]) +
  geom_col() +
  #geom_label(aes(label = name)) +
  annotate("label", x = 3, y = 50, label = "Median") +
  theme_minimal() +
  scale_x_continuous(breaks = 1:5, labels = d$name) +
  labs(y = "Einkommen")


d %>% 
  ggplot(aes(x = einkommen)) +
  geom_histogram(binwidth = 1, color = "white") +
  geom_vline(xintercept = median(d$einkommen), color = okabeito_colors()[2]) +
  annotate("label", x = 3, y = 1, label = "Median", color = okabeito_colors()[2]) +
  geom_vline(xintercept = mean(d$einkommen), color = okabeito_colors()[1]) +  
  annotate("label", x = 22, y = 1, label = "MW", color = okabeito_colors()[1])   +
  theme_minimal() +
  scale_y_continuous(breaks = c(0, 1)) +
  annotate("label", x = 100, y = 0, label = "Dora") +
  labs(caption = "MW: Mittelwert",
       y = "Anzahl",
       x = "Einkommen")

mariokart <- read.csv("https://vincentarelbundock.github.io/Rdatasets/csv/openintro/mariokart.csv")

mariokart %>% 
  summarise(price_mw = mean(start_pr),
            price_md = median(start_pr))

mariokart %>% 
  select(start_pr) %>% 
  ggplot(aes(x = start_pr)) +
  geom_histogram() +
  geom_vline(xintercept = 1, color = okabeito_colors()[1]) +
  annotate("label", x = 1, y = 0.1, label = "Md: 1", color = okabeito_colors()[1]) +
  geom_vline(xintercept = 8.7, color = okabeito_colors()[2]) +
  annotate("label", x = 8.7, y = 0.1, label = "MW: 8.7", color = okabeito_colors()[2]) +
  theme_modern() +
  labs(
    caption = "MD: Median; MW: Mittelwert",
    y = "Anzahl"
  )


mariokart2 <- 
mariokart %>% 
  filter(total_pr < 100)

# ohne Extremwerte:
mariokart2 |> 
  summarise(total_pr_mittelwert = mean(total_pr),
            total_pr_median = median(total_pr))

# mit Extremwerten:
mariokart |> 
  summarise(total_pr_mittelwert = mean(total_pr),
            total_pr_median = median(total_pr))

mario_quantile <- 
mariokart %>% 
  filter(total_pr < 100) %>% 
  summarise(q25 = quantile(total_pr, .25),
            q50 = quantile(total_pr, .50),
            q75 = quantile(total_pr, .75))

mario_quantile <- 
  mariokart %>% 
  filter(total_pr < 100) %>% 
  reframe(qs = quantile(total_pr, c(.25, .5, .75)))

mariokart %>% 
  filter(total_pr < 100) %>%  
  ggplot(aes(x = total_pr)) +
  geom_histogram() +
  geom_vline(xintercept = mario_quantile$qs) +
  annotate("label", x =  mario_quantile$qs, y = 0, label =  mario_quantile$qs) +
  annotate("label", x =  mario_quantile$qs, y = Inf, label =  c("Q1", "Median", "Q3"), vjust = 2) +
  labs(y = "Anzahl")

mario_quantile <- 
mariokart %>% 
  filter(total_pr < 100) %>% 
  summarise(q25 = quantile(total_pr, .25),
            q50 = quantile(total_pr, .50),
            q75 = quantile(total_pr, .75))

mario_quantile <- 
  mariokart %>% 
  filter(total_pr < 100) %>% 
  reframe(qs = quantile(total_pr, c(.25, .5, .75)))

mariokart %>% 
  filter(total_pr < 100) %>%  
  ggplot(aes(x = total_pr)) +
  geom_density() +
  geom_vline(xintercept = mario_quantile$qs) +
  annotate("label", x =  mario_quantile$qs, y = 0, label =  mario_quantile$qs) +
  annotate("label", x =  mario_quantile$qs, y = Inf, label =  c("Q1", "Median", "Q3"), vjust = 2) +
  labs(y = "Anzahl")

## mario_quantile <-
## mariokart %>%
##   filter(total_pr < 100) %>%
##   summarise(q25 = quantile(total_pr, .25),
##             q50 = quantile(total_pr, .50),
##             q75 = quantile(total_pr, .75))

xqnorm( p = c(.25, .5, .75), return = "plot") +
  guides(fill = "none") + 
  theme_minimal()

xqnorm( p = seq(0,1, by = .1), return = "plot") +
  theme_minimal() +
  guides(fill = "none") 

xqnorm( p = seq(0,1, by = .01), return = "plot") +
  theme_minimal() +
  guides(fill = "none") 

mariokart_lagemaße_total_pr <-
  mariokart %>% 
  summarise(mw = mean(total_pr),
            md = median(total_pr),
            q1 = quantile(total_pr, .25),
            q2 = quantile(total_pr, .5),
            q3 = quantile(total_pr, .75),
            min = min(total_pr),
            max = max(total_pr))
mariokart_lagemaße_total_pr

mariokart_lagemaße_gruppiert <-
  mariokart %>% 
  group_by(wheels) %>%  # neue Zeile, der Rest ist gleich!
  summarise(mw = mean(total_pr))

mariokart_lagemaße_gruppiert

mariokart$X <- 1:nrow(mariokart)

mariokart <-
  mariokart %>% 
  mutate(is_extreme = total_pr > 100)

mariokart_extreme <-
  mariokart %>% 
  filter(is_extreme)

mariokart2 <- 
mariokart %>% 
  filter(total_pr < 100)



mariokart3 <-
  mariokart2 |> 
  filter(wheels == 0 | wheels == 2) 

mariokart3_summ <-
  mariokart3 |> 
  group_by(wheels) |> 
  summarise(total_pr = mean(total_pr, na.rm = TRUE)) |> 
  mutate(wheels = factor(wheels))

p1 <- ggplot(mariokart2) +
  aes(x = X, y = total_pr) +
  geom_hline(yintercept = mean(mariokart2$total_pr),
             color = okabeito_colors()[1], 
             size = 2) +
  geom_point(alpha = .7) +
  labs(caption = paste0("MW: ", round(mean(mariokart2$total_pr), 2)),
       x = "Nr. des Spiel") +
  theme_minimal() +
  scale_y_continuous(limits = c(0, 100)) +
  annotate("label", x = 0, y = 47, label = "MW")

  
p2 <- mariokart3 |> 
  mutate(wheels = factor(wheels)) |> 
  ggplot(aes(x = X, y = total_pr, group = wheels, color = wheels)) +
  geom_point2() + # Scatter plot
  geom_hline(data = mariokart3_summ, aes(yintercept = total_pr,
                                         color = wheels),
             size = 2) +
  scale_color_okabeito() +
  labs(caption = paste0("MWs: ", round(mariokart3_summ$total_pr, 2)),
       x = "Nr. des Spiel")  +
  theme_minimal()  +
  scale_y_continuous(limits = c(0, 100)) +
  theme(legend.position = c(.8, .1),
        legend.background = element_rect(
          fill = NA, # Background color
          color = "grey40", # Border color
          linewidth = 1, # Border size
          linetype = "solid"))

p1
p2

checkliste <- tibble::tribble(
  ~Nr,                                                                                       ~Check,
   1L,       "Wurde die Art und die Zeitdauer der Datenerhebung vorab festgelegt und berichtet?",
   2L,            "Wurden ausreichend Daten gesammelt (z.B. mind. 20 Beobachtungen pro Gruppe)?",
   3L,                                           "Wurden alle untersuchten Variablen berichtet?",
   4L,                                    "Wurden alle durchgeführten Interventionen berichtet?",
   5L, "Wurden Daten aus der Analyse entfernt? Wenn ja, gibt es eine (stichhaltige) Begründung?"
  )

checkliste |> 
  gt()
