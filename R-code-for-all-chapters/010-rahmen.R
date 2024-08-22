library(tibble)
library(tidyverse)
library(gt)
library(ggfittext)
library(see)

theme_set(theme_minimal())

ggplot2::theme_set(theme_minimal())

## flowchart TD
##   subgraph Lehrkraft
##     F["🔥"]
##   end
##   subgraph A[Konzentration im Unterricht]
##     C["🪵"]
##   end
##   subgraph E[Eigenstudium]
##     D["🌳"]
##   end
## 


d <- 
  tibble(y = rnorm(100),
         e = rnorm(100, mean = 0, sd = 0.3),
         x = y + e)

d |> 
  ggplot(aes(y = y, x = 1)) +
  geom_jitter(width = .1) +
  scale_x_continuous(limits = c(0, 2)) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  annotate("point", size = 7, x = 1, y = 0,
           color = modelcol) +
  annotate("label", x = 0, y = 0, label = "MW", hjust = 0) +
  labs(caption = "MW: Mittelwert") +
  theme_modern()


d |> 
  ggplot(aes(x = x, y = y)) +
  geom_point2() +
  geom_smooth(method = "lm", color = modelcol) +
  theme_modern()

groesse <- 
  tibble::tribble(
     ~id, ~groesse,        ~team,
      1L,     199L, "Basketball 🏀",
      2L,     203L, "Basketball 🏀",
      3L,     201L, "Basketball 🏀",
     4L,     199L, "Basketball 🏀",
     5L,     204L, "Basketball 🏀",
     1L,     161L,     "Schach ♟️",
     2L,     198L,        "Schach ♟️",
     3L,     177L,      "Schach ♟️",
     4L,     171L,        "Schach ♟️",
     5L,     192L,    "Schach ♟️",
     )

groesse <- groesse %>%
  mutate(label = if_else(team == "Basketball 🏀", "geringe Variation", "hohe Variation"))



groesse %>% 
  ggplot(aes(x = id, y = groesse)) +
  geom_col() +
  facet_wrap(~team) +
  labs(title = "Variation in der Körpergröße",
       y = "Körpergröße",
       x = "Spielernummer",
       caption = "MW: Mittelwert") +
  geom_label(data = distinct(groesse, team, .keep_all = TRUE), 
            aes(label = label, x = 3, y = 50), 
            size = 5, vjust = 0) +
  theme(strip.text = element_text(size = 16)) +
  theme_modern()

groesse_summ <-
  groesse %>% 
  group_by(team) %>% 
  summarise(groesse_mw = mean(groesse))

groesse <-
  groesse %>% 
  group_by(team) %>% 
  mutate(groesse_mw = mean(groesse)) %>% 
  mutate(abweichung = groesse - groesse_mw) %>% 
  mutate(vorzeichen = factor(sign(abweichung)))

groesse %>% 
  ggplot(aes(x = id)) +
  geom_segment(aes(x = id, xend = id, y = groesse, yend = groesse_mw, color = vorzeichen)) +
  geom_point(aes(x = id, y = groesse), color = "grey60", alpha = .7, size = 2) +
  facet_wrap(~ team) +
  geom_hline(aes(yintercept = groesse_mw), data = groesse_summ) +
  labs(title = "Abweichung vom Mittelwert der Körpergröße pro Team",
       subtitle = "Basketball: Wenig Variation; Schach: Viel Variation") + 
  scale_color_okabeito() +
  geom_label(x = 5, label = "MW",
            aes(y = groesse_mw),
            hjust = "right",
            size = 5)  +
  theme(strip.text = element_text(size = 16),
        legend.position = "bottom")  +
  theme_modern()

## graph TD
##   subgraph Ziele
##     A[beschreiben]
##     B[vorhersagen]
##     C[erklären]
##   end

## graph LR
##     I[Input bzw. X] --> X[hier passiert irgendwas]
##     subgraph "Schwarze Kiste"
##       X
##     end
##     X --> O[Output bzw. Y]

## graph LR
##     Problem --> Plan --> Data --> Analysis --> Conclusions --> Problem

d <- 
  tribble(~ id, ~name, ~note,
          1, "Anna", 1.3,
          2, "Berta", 2.3,
          3, "Carla", 3)

d |> 
  gt::gt()

#library(dplyr)
#library(DT)
data("mariokart", package = "openintro")

#mariokart <- as_tibble("mariokart")

head(mariokart) |> 
  select(-id, - title) |> 
  kable()

# if (knitr:::is_html_output()) {
#   mariokart %>% 
#     select(-title) %>% 
#     DT::datatable() 
# }
# 
# if (knitr:::is_latex_output()) {
#   mariokart %>% 
#     select(-title) %>% 
#     head() 
# }


geschlecht <- c("Mann", "Frau", "Frau", "Frau", "Mann",
                "Frau", "Mann", "Mann", "divers", "Frau")
geschlecht

d <-
  tribble(
    ~Produkt, ~Umsatz_2021, ~Umsatz_2022, ~Umsatz_2023,
    "Hammer", 10, 11, 12,
    "Nägel", 15, 10, 5
  )
kable(d)

d_long <-
  d |> 
  pivot_longer(cols = c(Umsatz_2021, Umsatz_2022, Umsatz_2023), names_to = "Jahr2", values_to = "Umsatz") |> 
  separate(Jahr2, into = c("k", "Jahr")) |> 
  select(-k)

kable(d_long)

d_long |> 
  ggplot(aes(x = Jahr, y = Umsatz, color = Produkt, 
             group = Produkt)) +
  geom_point() +
  geom_line() +
  scale_color_okabeito() +
  theme_modern()

d <- tibble(id = 1:20)

d <- d |> 
  mutate(
    x1 = map_dbl(id, ~mean(rnorm(n = 20))), 
    x2 = map_dbl(id, ~mean(rnorm(n = 200)))
  )

d_long <- d |> 
  pivot_longer(cols = c(x1, x2), names_to = "variable", values_to = "value")



custom_labels <- c(x1 = "Kleine Stichproben (n=20)", x2 = "Große Stichproben (n=200)")


ggplot(d_long, aes(x = id, y = value)) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_point() +
  facet_wrap(~ variable, labeller = labeller(variable = custom_labels)) +
  theme_minimal() 
  labs(
    x = "Nummer der Stichprobe",
    y = "Wert"
  )

## graph LR
##     Input --> Output
##     X --> Y
##     P[Prädiktor] --> K[Kriterium]
##     Ursache --> Wirkung
##     UV[unabhängige Variable] --> AV[abhängige Variable]

## graph TD
##     Variablen --> qualitativ
##     Variablen --> quantitativ
##     qualitativ --> nominal
##     qualitativ --> ordinal
##     quantitativ --> Intervallniveau
##     quantitativ --> Verhältnisniveau

skalen_bsps <- 
  tibble::tribble(
                        ~Variable,     ~Skalenniveau,
                      "Haarfarbe",    "Nominalskala",
                     "Augenfarbe",    "Nominalskala",
                     "Geschlecht",    "Nominalskala",
                      "Automarke",    "Nominalskala",
                         "Partei",    "Nominalskala",
                 "Lieblingsessen",    "Ordinalskala",
  "Medaillen beim 100-Meter-Lauf",    "Ordinalskala",
                     "Uniranking",    "Ordinalskala",
                             "IQ",  "Intervallskala",
                   "Extraversion",  "Intervallskala",
          "Temperatur in Celcius",  "Intervallskala",
       "Temperatur in Fahrenheit",  "Intervallskala",
           "Temperatur in Kelvin", "Verhältnisskala",
                    "Körpergröße", "Verhältnisskala",
                "Geschwindigkeit", "Verhältnisskala",
                          "Länge", "Verhältnisskala"
  )
skalen_bsps |> 
  kable()

skalenniveaus <-
  tibble::tribble(
       ~Skalenniveau, ~Quantitativ, ~`≠`, ~`≼`, ~`+`, ~`×`,
     "Nominalniveau",       "nein",  "✅",  "❌",  "❌",  "❌",
     "Ordinalniveau",       "nein",  "✅",  "✅",  "❌",  "❌",
   "Intervallniveau",         "ja",  "✅",  "✅",  "✅",  "❌",
  "Verhältnisniveau",         "ja",  "✅",  "✅",  "✅",  "✅"
  )

skalenniveaus |> 
  kable()

skalenniveaus <-
  tibble::tribble(
       ~Skalenniveau, ~Quantitativ, ~Gleichheit, ~Reihenfolge, ~Addition, ~Multiplikation,
     "Nominalniveau",       "nein",  "ja",  "nein",  "nein",  "nein",
     "Ordinalniveau",       "nein",  "ja",  "ja",  "nein",  "nein",
   "Intervallniveau",         "ja",  "ja",  "ja",  "ja",  "nein",
  "Verhältnisniveau",         "ja",  "ja",  "ja",  "ja",  "ja"
  )

skalenniveaus |> 
  kable()

## tibble(x = c(1,2,5), Liebling = c("🥩", "🍝", "🍕")) %>%
##   ggplot()+
##   aes(x=x) +
##   geom_label(aes(label = Liebling), y = 1, size = 10) +
##   theme_minimal() +
##   labs(x = "Wie sehr ich dieses Essen mag") +
##   theme(axis.text = element_blank()) +
##   scale_y_continuous(limits = c(0,2))

tibble(y = c(10, 20, 30)) %>% 
  ggplot()+
  aes(x=x) +
  annotate("segment", x = 0, xend = 0, y = 0, yend = 30) +
  theme_minimal() +
  annotate("rect", fill = "blue", alpha = .8,
           xmin = -1, xmax = 1, ymin = 10, ymax = 0) +
  theme_void() +
  geom_label(x = 0, aes(y = y, label = y))

tibble(Preis = c(1e4, 1e5),
       id = c(1, 2),
       Auto = c("🚙", "🏎️")  ) %>% 
  ggplot(aes(y = Preis, x = id)) +
  geom_col() +
  scale_x_discrete() +
  geom_bar_text()+
  #geom_label(aes(x = id, y = Preis, label = Preis)) +
  scale_y_continuous(labels = scales::dollar_format(),
                     limits = c(-1000, 1e5),
                     expand = c(0.1, 0.1)) +
  geom_label(aes(x = id, label = Auto), y = -1e3,
                          size = 10,
             nudge_y = -10000)

set.seed(42)
zeiten <- rnorm(30, mean = 10, sd = 2) %>% trunc()
zeiten_mw <- mean(zeiten)
