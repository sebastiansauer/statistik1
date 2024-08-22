library(tidyverse)
library(gt)
library(ggfittext)
library(see)

theme_set(theme_minimal())

ggplot2::theme_set(theme_minimal())

knitr::include_graphics("img/r_vs_rstudio_1.png")

richtige_antwort = 42
falsche_antwort = 43
typ = "Antwort"
ist_korrekt = TRUE

richtige_antwort <- 42
falsche_antwort <- 43
typ <- "Antwort"
ist_korrekt <- TRUE

die_summe <- falsche_antwort + richtige_antwort

die_summe

die_summe <- falsche_antwort + richtige_antwort + 1

die_summe

alter <- NA
alter

Antworten <- c(42, 43)

x <- c(1, 2, 3)
y <- c(2, 1, 3)  # x und y sind ungleich (Reihenfolge der Werte)
z <- c(3.14, 2.71)  
namen <- c("Anni", "Bert", "Charli") # Text-Vektor

mean(Antworten)

## library(magick)
## img_path <- "img/function-schema.pdf"
## p <- image_read_pdf(img_path)
## p_trimmed <- image_trim(p)
## image_write(p_trimmed, "img/function-schema.png")

## mean(x, trim = 0, na.rm = FALSE, ...)

mean(Antworten, FALSE, 0)  # FALSCH, DON'T DO IT 🙅‍♀️

## mean(na.rm = FALSE, x = Antworten)  # ok
## mean(trim = 0, x = Antworten, na.rm = TRUE)  # ok

Antworten <- c(42, 43, NA)
Antworten

mean(Antworten)

mean(Antworten, na.rm = TRUE)

x <- c(1, 2, 3)

x - mean(x)

## 1 - 2
## 2 - 2
## 3 - 2

d_x <-
  tibble(x = x,
         id = 1:3)

ggplot(d_x) +
  aes(x = id, y = x) +
  geom_point(size = 3, alpha = .7, fill = "blue") +
  geom_hline(yintercept = 2) +
  geom_pointrange(aes(xmin = id, ymin = 2, ymax = x, xmax = id), linetype = "dashed") +
  theme_modern() +
  scale_x_continuous(breaks =1L:3L) +
  scale_y_continuous(breaks = c(1.0,2.0,3.0))

data("mariokart", package = "openintro")

d <- mariokart

## mariokart <- read.csv("https://vincentarelbundock.github.io/Rdatasets/csv/openintro/mariokart.csv")

glimpse(d)

## d <- read.csv("mariokart.csv")

## mariokart

x <- 42

x == 42

lgl_df <- tibble::tribble(
                ~Prüfung.auf,                 ~`R-Syntax`,
                "Gleichheit",                 "x == Wert",
              "Ungleichheit",                 "x != Wert",
           "Größer als Wert",                  "x > Wert",
   "Größer oder gleich Wert",                 "x >= Wert",
          "Kleiner als Wert",                  "x < Wert",
  "Kleiner oder gleich Wert",                 "x <= Wert",
             "Logisches UND", "(x < Wert1) & (x > Wert2)",
            "Logisches ODER", "(x < Wert1) | (x > Wert2)"
  )

lgl_df |> gt()

d <- tibble(
  Anzahl = c(1923,438255),
  Tag = c("spss", "r")
)

ggplot(d) +
  aes(x = Tag, y = Anzahl) +
  geom_col() +
  theme_minimal() +
  geom_label(aes(y = Anzahl, label = Anzahl)) +
  theme_modern()

## library(easystats)  # Das Paket muss installiert sein
## d <- data_read("https://vincentarelbundock.github.io/Rdatasets/csv/openintro/mariokart.csv")

library(easystats)
extra <- data_read("daten/extra.xls")

library(rio)
extra_path <- "https://github.com/sebastiansauer/statistik1/raw/main/daten/extra.xls"
extra <- import(extra_path)

mariokart$total_pr

verkaufspreise <- mariokart$total_pr
mean(verkaufspreise)
mean(mariokart$total_pr)  # synonym zur obigen Zeile

x <- c(1, 2, 3)
sum(abs(mean(x)-x)) 

library(openintro)  # Datensatz `mariokart`

mariokart <- read.csv("https://vincentarelbundock.github.io/Rdatasets/csv/openintro/mariokart.csv")

## data(mariokart, package = "openintro")  # Das Paket muss installiert sein
