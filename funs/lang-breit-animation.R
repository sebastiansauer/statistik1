# Animation Breitformat <-> Langformat (pivot_longer / pivot_wider) am
# Hämmer-und-Nägel-Beispiel für Abb. "fig-lang-breit" in 010-rahmen.qmd.
# Idee nach tidyexplain (Garrick Aden-Buie): Jede Tabellenzelle ist eine
# Kachel, die von ihrem Platz in der einen Form an ihren Platz in der anderen
# Form wandert.
#
# Manuell ausführen (aus dem Projektordner, .Rprofile lädt _common.R):
#   Rscript funs/lang-breit-animation.R
#
# Ergebnis:
#   img/lang-breit-anim.gif    (HTML: breit -> lang -> breit als Schleife)
#   img/lang-breit-statisch.pdf/.png (PDF: beide Formen nebeneinander)
#
# Farbe = Jahr: Der Spaltenkopf "Umsatz_2021" und seine Werte haben dieselbe
# Farbe. Beim Umformen wird der Kopf zu Werten der Spalte "Jahr" (das Präfix
# "Umsatz_" fällt weg, wie mit names_prefix = "Umsatz_").

library(tidyverse)
library(magick)

if (!exists("grau_dunkel")) source("_common.R")


# Daten -------------------------------------------------------------------

produkte <- c("Hämmer", "Nägel")
jahre    <- c("2021", "2022", "2023")
umsatz   <- matrix(c(10, 11, 12,
                     15, 10,  5), nrow = 2, byrow = TRUE)

jahr_farbe <- setNames(okabe_linie[1:3], jahre)       # Orange, Blau, Grün
mische_weiss <- function(farbe, anteil = 0.55) {
  m <- grDevices::col2rgb(farbe) / 255
  m <- m + (1 - m) * anteil
  grDevices::rgb(m[1, ], m[2, ], m[3, ])
}
jahr_hell <- setNames(mische_weiss(jahr_farbe), jahre)

kopf_grau   <- grau_mittel
produkt_grau <- "#E5E5E5"


# Kacheln mit Position in beiden Formen -----------------------------------
# Spalte j, Zeile i (Kopfzeile i = 0). Jede Kachel hat Position, Text und
# Deckkraft in der breiten (_b) und der langen (_l) Form.

breite_spalte <- 2.0
hoehe_zeile   <- 0.7
pos_x <- function(j) j * breite_spalte
pos_y <- function(i) -i * hoehe_zeile

# Zeile in der Langform: Produkt p, Jahr k -> (p - 1) * 3 + k
lang_zeile <- function(p, k) (p - 1) * 3 + k

kacheln <- bind_rows(
  # Kopf "Produkt": bleibt
  tibble(id = "kopf_produkt", j_b = 0, i_b = 0, j_l = 0, i_l = 0,
         text_b = "Produkt", text_l = "Produkt",
         fuellung = kopf_grau, kopf = TRUE, a_b = 1, a_l = 1),
  # Neue Köpfe "Jahr" und "Umsatz": erscheinen nur in der Langform
  tibble(id = c("kopf_jahr", "kopf_umsatz"), j_b = c(1, 2), i_b = 0,
         j_l = c(1, 2), i_l = 0,
         text_b = c("Jahr", "Umsatz"), text_l = c("Jahr", "Umsatz"),
         fuellung = kopf_grau, kopf = TRUE, a_b = 0, a_l = 1),
  # Produkt-Zellen: je Produkt drei Kopien, die in der Breitform übereinander
  # liegen und sich in der Langform auf drei Zeilen verteilen
  expand_grid(p = 1:2, k = 1:3) |>
    transmute(id = paste0("produkt_", p, "_", k),
              j_b = 0, i_b = p, j_l = 0, i_l = lang_zeile(p, k),
              text_b = produkte[p], text_l = produkte[p],
              fuellung = produkt_grau, kopf = FALSE, a_b = 1, a_l = 1),
  # Jahres-Köpfe: zwei Kopien (je Produkt eine), werden zu Werten von "Jahr"
  expand_grid(p = 1:2, k = 1:3) |>
    transmute(id = paste0("jahr_", p, "_", k),
              j_b = k, i_b = 0, j_l = 1, i_l = lang_zeile(p, k),
              text_b = paste0("Umsatz_", jahre[k]), text_l = jahre[k],
              fuellung = jahr_farbe[k], kopf = TRUE, a_b = 1, a_l = 1),
  # Umsatzwerte: wandern in die Spalte "Umsatz"
  expand_grid(p = 1:2, k = 1:3) |>
    transmute(id = paste0("wert_", p, "_", k),
              j_b = k, i_b = p, j_l = 2, i_l = lang_zeile(p, k),
              text_b = as.character(umsatz[cbind(p, k)]),
              text_l = as.character(umsatz[cbind(p, k)]),
              fuellung = jahr_hell[k], kopf = FALSE, a_b = 1, a_l = 1)
) |>
  mutate(textfarbe = ifelse(toupper(fuellung) == toupper(okabe_linie[2]),
                            "white", fast_schwarz),
         # Jahres-Kacheln in der Langform sind Werte, kein Kopf mehr
         fett_b = kopf, fett_l = kopf & !startsWith(id, "jahr_"))

# Zeichenreihenfolge: Kopien, die in der Breitform übereinander liegen,
# sollen sauber wirken -> Köpfe zuletzt
kacheln <- kacheln |> arrange(kopf)


# Ein Bild für Zwischenstand t (0 = breit, 1 = lang) -----------------------

glatt <- function(t) t * t * (3 - 2 * t)   # sanftes Anfahren und Bremsen

x_bereich <- c(pos_x(0) - breite_spalte / 2 - 0.05, pos_x(3) + breite_spalte / 2 + 0.05)
y_bereich <- c(pos_y(6) - hoehe_zeile / 2 - 0.05, pos_y(0) + hoehe_zeile / 2 + 0.05)

tabelle_bild <- function(t, titel, groesse = 4.6) {
  s <- glatt(t)
  d <- kacheln |>
    mutate(x = pos_x(j_b + (j_l - j_b) * s),
           y = pos_y(i_b + (i_l - i_b) * s),
           a = a_b + (a_l - a_b) * s,
           text = if (s < 0.5) text_b else text_l,
           fett = if (s < 0.5) fett_b else fett_l)

  ggplot(d, aes(x, y)) +
    geom_tile(aes(fill = I(fuellung), alpha = I(a)),
              width = breite_spalte - 0.08, height = hoehe_zeile - 0.08,
              color = "white", linewidth = 0.6) +
    geom_text(aes(label = text, color = I(textfarbe), alpha = I(a),
                  fontface = ifelse(fett, "bold", "plain")),
              size = groesse) +
    coord_fixed(xlim = x_bereich, ylim = y_bereich, expand = FALSE) +
    labs(title = titel) +
    theme_leer("html") +
    theme(plot.title = element_text(face = "bold", size = 17,
                                    color = grau_dunkel,
                                    family = if (grepl("\\(", titel)) "mono" else "",
                                    hjust = 0.5,
                                    margin = margin(b = 8)),
          plot.margin = margin(12, 12, 12, 12))
}


# GIF: breit (Pause) -> lang (Pause) -> breit ------------------------------

n_schritte <- 18
schritte <- seq(0, 1, length.out = n_schritte)

bilder_folge <- c(
  list(list(t = 0, titel = "Breitformat")),
  map(schritte[-1], \(t) list(t = t, titel = "pivot_longer()")),
  list(list(t = 1, titel = "Langformat")),
  map(rev(schritte)[-1], \(t) list(t = t, titel = "pivot_wider()"))
)
# Pausen: Ruhebilder lange zeigen, Bewegung flüssig
verzoegerung <- c(250, rep(7, n_schritte - 1), 250, rep(7, n_schritte - 1))

tmp <- tempfile()
dir.create(tmp)
dateien <- imap_chr(bilder_folge, function(b, i) {
  f <- file.path(tmp, sprintf("bild_%03d.png", i))
  ggsave(f, tabelle_bild(b$t, b$titel),
         width = 6.4, height = 5, dpi = 100, bg = "white")
  f
})
anim <- image_animate(image_read(dateien), delay = verzoegerung, optimize = TRUE)
image_write(anim, "img/lang-breit-anim.gif")
unlink(tmp, recursive = TRUE)


# Standbild für das PDF: breit links, lang rechts --------------------------

statisch <- function() {
  breit <- kacheln |>
    filter(a_b > 0) |>
    # Kopien in der Breitform nur einmal zeichnen
    distinct(j_b, i_b, .keep_all = TRUE) |>
    transmute(x = pos_x(j_b), y = pos_y(i_b), text = text_b, fuellung,
              textfarbe, fett = fett_b)
  versatz <- pos_x(3) + breite_spalte * 2.3
  lang <- kacheln |>
    transmute(x = pos_x(j_l) + versatz, y = pos_y(i_l), text = text_l,
              fuellung, textfarbe, fett = fett_l)
  d <- bind_rows(breit, lang)

  pfeil_x <- c(pos_x(3) + breite_spalte * 0.7, versatz - breite_spalte * 0.7)
  pfeil_mitte <- mean(pfeil_x)

  ggplot(d, aes(x, y)) +
    geom_tile(aes(fill = I(fuellung)),
              width = breite_spalte - 0.08, height = hoehe_zeile - 0.08,
              color = "white", linewidth = 0.6) +
    geom_text(aes(label = text, color = I(textfarbe),
                  fontface = ifelse(fett, "bold", "plain")), size = 2.6) +
    annotate("segment", x = pfeil_x[1], xend = pfeil_x[2],
             y = pos_y(1.3), yend = pos_y(1.3),
             arrow = arrow(length = unit(2.5, "mm"), type = "closed"),
             color = grau_dunkel, linewidth = 0.6) +
    annotate("text", x = pfeil_mitte, y = pos_y(0.85),
             label = "pivot_longer()", family = "mono", size = 3,
             color = grau_dunkel) +
    annotate("segment", x = pfeil_x[2], xend = pfeil_x[1],
             y = pos_y(2.7), yend = pos_y(2.7),
             arrow = arrow(length = unit(2.5, "mm"), type = "closed"),
             color = grau_dunkel, linewidth = 0.6) +
    annotate("text", x = pfeil_mitte, y = pos_y(2.25),
             label = "pivot_wider()", family = "mono", size = 3,
             color = grau_dunkel) +
    annotate("text", x = pos_x(1.5), y = pos_y(-0.85), label = "Breitformat",
             fontface = "bold", size = 4, color = grau_dunkel) +
    annotate("text", x = pos_x(1) + versatz, y = pos_y(-0.85),
             label = "Langformat", fontface = "bold", size = 4,
             color = grau_dunkel) +
    coord_fixed(expand = FALSE,
                xlim = c(-breite_spalte / 2 - 0.05,
                         pos_x(2) + versatz + breite_spalte / 2 + 0.05),
                ylim = c(pos_y(6.5), pos_y(-1.2))) +
    theme_leer("pdf")
}

ggsave("img/lang-breit-statisch.pdf", statisch(),
       width = 6.5, height = 2.9, device = cairo_pdf)
ggsave("img/lang-breit-statisch.png", statisch(),
       width = 6.5, height = 2.9, dpi = 200, bg = "white")
