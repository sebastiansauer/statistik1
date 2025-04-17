library(ggpubr)
library(png)
library(grid)
library(patchwork)
library(gt)

source("_common.R")

ggplot2::theme_set(theme_minimal())

library(tidyverse)
library(easystats)

mariokart <- read.csv("https://vincentarelbundock.github.io/Rdatasets/csv/openintro/mariokart.csv")

mariokart <- read.csv("https://vincentarelbundock.github.io/Rdatasets/csv/openintro/mariokart.csv")

glimpse(mariokart)

mariokart <- as_tibble(mariokart)

d <- 
tibble(id = c(1, 2, 3),
       name = c("Anni", "Berti", "Charli"),
       gruppe = c("A", "A", "B"),
       note = c(2.7, 2.7, 1.7))

ra <- png::readPNG("img/rightarrow.png", native = TRUE)

p_d1 <- ggtexttable(d, rows=NULL)
p_ra <- ggplot() + inset_element(ra, 0, 0, 1, 1)

d |> gt()

d_arranged <-
  d %>% 
  arrange(note)

p_d_arranged <- ggtexttable(d_arranged, rows=NULL) 

p_d_arranged <-
  p_d_arranged %>% 
  table_cell_bg(column = 4, fill = "red", row = 2:tab_nrow(p_d_arranged))

p_text <- grid::textGrob("arrange()")

design <- 
  "
A#D
ABD
ACD
A#D
"

p_arrange <- wrap_plots(A = p_d1, 
                        B = p_text , 
                        C = p_ra, 
                        D = p_d_arranged, 
           widths = c(4,1,4),
           design = design) 
p_arrange +
  theme(plot.margin = margin(t = 5, r = 5, b = 5, l = 5, unit = "pt")) # Adjust top, right, bottom, and left margins



arrange(mariokart, total_pr)

## mario_sortiert <- arrange(mariokart, -total_pr)

d_filter <-
  d %>% 
  filter(note > 2)


p_d1 <- ggtexttable(d, rows=NULL)
p_ra <- ggplot() + inset_element(ra, 0, 0, 1, 1)
p_d_filter <- ggtexttable(d_filter, rows=NULL) 

p_d_filter <- 
  p_d_filter %>% 
  table_cell_bg(column = 1:4, fill = "red", row = 2:tab_nrow(p_d_filter))

p_text_filter <- grid::textGrob("filter()")

design <- 
  "
A#D
ABD
ACD
A#D
"

p_filter <- wrap_plots(A= p_d1, 
                       B = p_text_filter , 
                       C = p_ra, 
                       D = p_d_filter, 
                       widths = c(4,1,4),
                       design = design) 
p_filter

mariokart_neu <- filter(mariokart, stock_photo == "yes")
mariokart_neu

mario_filter1 <- filter(mariokart, stock_photo == "yes" & cond == "new")
mario_filter1

mario_filter2 <- filter(mariokart, stock_photo == "yes" | cond == "new")
mario_filter2

d_select <-
  d %>% 
  select(id, note)

p_d1 <- ggtexttable(d, rows=NULL)
p_ra <- ggplot() + inset_element(ra, 0, 0, 1, 1)
p_d_select <- ggtexttable(d_select, rows=NULL) 

p_d_select2 <- 
  p_d1 %>% 
  table_cell_bg(column = 2, fill = "red", row = 2:tab_nrow(p_d_select))

p_text_select <- grid::textGrob("select()")

design <- 
  "
A#D
ABD
ACD
A#D
"

p_select <- wrap_plots(A= p_d_select2, 
                       B = p_text_select, 
                       C = p_ra, 
                       D = p_d_select, 
                       widths = c(4,1,4),
                       design = design) 
p_select

## mario_select1 <- select(mariokart, cond, total_pr)
## mario_select1

## select(mariokart, 1, 2)  # Spalte 1 und 2
## select(mariokart, 2:5)  #  Spalten 2 *bis* 5
## select(mariokart, -1)  # Alle Spalte *aber nicht* Spalte 1

d_summ <-
  d %>% 
  summarise(note_mw = round(mean(note), 1))


p_d1 <- ggtexttable(d, rows=NULL)
p_ra <- ggplot() + inset_element(ra, 0, 0, 1, 1)
p_d_summ <- ggtexttable(d_summ, rows=NULL) 

p_text_summ <- grid::textGrob("summarise()",
                              gp=grid::gpar(fontsize=8))

design <- 
  "
A#D
ABD
ACD
A#D
"

p_summ <- wrap_plots(A= p_d1, 
                       B = p_text_summ, 
                       C = p_ra, 
                       D = p_d_summ, 
                       widths = c(4,1,4),
                       design = design) 
p_summ

mariokart_mittelwert <- summarise(mariokart, preis_mw = mean(total_pr))
mariokart_mittelwert

d_groupby <-
  d %>% 
  group_by(gruppe)

d_g1 <-
  d %>% 
  filter(gruppe == "A")

d_g2 <-
  d %>% 
  filter(gruppe == "B")


p_d_g1 <- ggtexttable(d_g1, rows=NULL) 
p_d_g2 <- ggtexttable(d_g2, rows=NULL)


p_d_g1 <- 
  p_d_g1 %>% 
  table_cell_bg(column = 3, fill = "blue", row = 2:tab_nrow(p_d_g1))

p_d_g2 <- 
  p_d_g2 %>% 
  table_cell_bg(column = 3, fill = "green", row = 2:tab_nrow(p_d_g2))

p_text_summ <- grid::textGrob("group_by(gruppe)",
                              gp=grid::gpar(fontsize=8))

design <- 
  "
A#D
ABD
ACE
A#E
"

p_group <- wrap_plots(A= p_d1, 
                       B = p_text_summ, 
                       C = p_ra, 
                       D = p_d_g1, 
                       E = p_d_g2,
                       widths = c(3,1,3),
                       design = design) 
p_group

mariokart_gruppiert <- group_by(mariokart, cond)

summarise(mariokart_gruppiert, preis_mw = mean(total_pr))

mariokart_gruppiert_foto <- group_by(mariokart, stock_photo)
mariokart_verkaufspreis_foto <- summarise(mariokart_gruppiert_foto,
                                          total_pr_avg = mean(total_pr),
                                          total_pr_max = max(total_pr))

mariokart_verkaufspreis_foto

d_mutate <-
  d %>% 
  mutate(punkte = c(73, 72, 89))

p_d_mutate <- ggtexttable(d_mutate, rows=NULL) 

p_d_mutate <- 
  p_d_mutate %>% 
  table_cell_bg(column = 5, fill = "red", row = 2:tab_nrow(p_d_select))

p_text_mutate <- grid::textGrob("mutate()",
                              gp=grid::gpar(fontsize=7))

design <- 
  "
A#D
ABD
ACD
A#D
"

p_mutate <- wrap_plots(A= p_d1, 
                       B = p_text_mutate, 
                       C = p_ra, 
                       D = p_d_mutate, 
                       widths = c(3,1,4),
                       design = design) 
p_mutate

mariokart2 <- mutate(mariokart, total_pr_yen = total_pr * 133)
mariokart2 <- select(mariokart2, total_pr_yen, total_pr)
mariokart2

mariokart_duration_wochen <- 
  mutate(mariokart, duration_week = duration / 7)

mariokart_duration_wochen <-
   select(mariokart_duration_wochen, duration, duration_week)
mariokart_duration_wochen

mariokart_duration_wochen <- 
  mutate(mariokart, duration_week = duration / 7)

mariokart_duration_wochen_gerundet <-
  mutate(mariokart_duration_wochen, duration_week_gerundet = round(duration_week, digits = 0))

mariokart_duration_wochen_schmal <-
  select(mariokart_duration_wochen_gerundet, duration, duration_week, duration_week_gerundet)
mariokart_duration_wochen_schmal

mariocart_counted <- count(mariokart, cond)
mariocart_counted

mutate(mariocart_counted, Anteil = n / sum(n))

## flowchart LR
##   A["▥"] --> B[tidyverse-Befehl] --> C["▥"]

x <- c(1, 2, 3)

sum(x - mean(x))

## flowchart TD
##   A["meine Daten 🗳"] --filter_zeilen-->B["▥"]
##   B --wähle_spalten--> C["▥"]
##   C --gruppiere--> D["▥"]
##   D --fasse_zusammen--> E["▥ Fertig. 🤩"]
## 

# Hey R:
mariokart %>%   # nimm die Tabelle "mariokart" und dann …
  filter(total_pr < 100) %>%  # filter nur die günstigen Spiele und dann …
  select(cond, total_pr) %>%  # wähle die zwei Spalten und dann …
  group_by(cond) %>%  # gruppiere die Tabelle nach Zustand des Spiels und dann …
  summarise(total_pr_mean = mean(total_pr))  # fasse beide Gruppen nach dem mittleren Preis zusammen

mariokart %>% 
  filter(stock_photo == "yes") %>% 
  group_by(cond) %>% 
  summarise(total_pr_max = max(total_pr))

x <- c(1, 2, 10)
max(x)

mariokart %>%
  count(wheels)

mariokart %>%
  filter(wheels < 3) %>% 
  group_by(wheels) %>% 
  summarise(mittlere_versandkosten = mean(ship_pr),
            anzahl_spiele = n())

mariokart %>% 
  select(total_pr) %>% 
  mutate(total_pr_yen = total_pr * 133) %>% 
  summarise(preis_yen_mw = mean(total_pr_yen),
            preis_yen_mw_minus_10proz = preis_yen_mw - 0.1*preis_yen_mw)

pr_mean <- round(mean(mariokart$total_pr), 0)

mariokart_wheels <- 
mariokart %>% 
  group_by(wheels) %>% 
  summarise(pr_mean = mean(total_pr),
            count_n = n())  # n() gibt die Anzahl der Zeilen pro Gruppe an

mariokart_wheels

mariokart_wheels %>% 
  summarise(mean(pr_mean))

## viewof bill_length_min = Inputs.range(
##   [32, 50],
##   {value: 35, step: 1, label: "Bill length (min):"}
## )
## viewof islands = Inputs.checkbox(
##   ["Torgersen", "Biscoe", "Dream"],
##   { value: ["Torgersen", "Biscoe"],
##     label: "Islands:"
##   }
## )

## Plot.rectY(filtered,
##   Plot.binX(
##     {y: "count"},
##     {x: "body_mass_g", fill: "species", thresholds: 20}
##   ))
##   .plot({
##     facet: {
##       data: filtered,
##       x: "sex",
##       y: "species",
##       marginRight: 80
##     },
##     marks: [
##       Plot.frame(),
##     ]
##   }
## )

## Inputs.table(filtered)

## data = FileAttachment("daten/penguins.csv").csv({ typed: true })

## filtered = data.filter(function(penguin) {
##   return bill_length_min < penguin.bill_length_mm &&
##          islands.includes(penguin.island);
## })

data(mtcars)
library(dplyr)  # nicht "tidyverse", denn "dplyr" reicht

mtcars %>% 
  filter(am = 0)  # den kürzesten Code, der Ihren Fehler entstehen lässt!

sessionInfo()  # gibt Infos zur R-Version etc. aus
