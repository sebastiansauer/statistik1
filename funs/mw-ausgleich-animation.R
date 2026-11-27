# Animation "Mittelwert als Ausgleichen" für Abb. "fig-mw2" in
# 050-zusammenfassen.qmd (Beispiel exm-mw: Anna 1, Berta 2, Carla 3).
# Idee: Jede Note ist ein Stapel aus Blöcken. Carla gibt ihren obersten Block
# an Anna ab; danach sind alle drei Stapel gleich hoch. Diese gemeinsame Höhe
# ist der Mittelwert, der "typische Vertreter" der Zahlenreihe.
#
# Manuell ausführen (aus dem Projektordner, .Rprofile lädt _common.R):
#   Rscript funs/mw-ausgleich-animation.R
#
# Ergebnis:
#   img/mw-ausgleich-anim.gif         (HTML: vorher -> ausgleichen -> nachher)
#   img/mw-ausgleich-statisch.pdf/.png (PDF: vorher und nachher nebeneinander)

library(tidyverse)
library(magick)

if (!exists("grau_dunkel")) source("_common.R")


# Daten -------------------------------------------------------------------

namen <- c("Anna", "Berta", "Carla")
noten <- c(1, 2, 3)
mw    <- mean(noten)

block_grau  <- grau_mittel
block_farbe <- okabe_linie[2]   # der wandernde Block (Blau)

breite <- 0.62                  # Blockbreite (Stapelabstand = 1)
luecke <- 0.08                  # Abstand zwischen Blöcken
kasten_h <- 3.35                # Höhe des Rahmens (Platz für 3 Blöcke)

# Alle Blöcke; der oberste von Carla wandert zu Anna
bloecke <- tibble(
  stapel = rep(seq_along(noten), noten),
  ebene  = unlist(map(noten, seq_len))
) |>
  mutate(wandert = stapel == 3 & ebene == 3,
         x_von = stapel, y_von = ebene,
         x_nach = ifelse(wandert, 1, stapel),
         y_nach = ifelse(wandert, 2, ebene),
         fuellung = ifelse(wandert, block_farbe, block_grau))

kaesten <- tibble(x = seq_along(noten), name = namen)


# Ein Bild für Zwischenstand t (0 = vorher, 1 = ausgeglichen) --------------

glatt <- function(t) t * t * (3 - 2 * t)   # sanftes Anfahren und Bremsen

ausgleich_bild <- function(t, titel, linie = 0, medium = "html",
                           groesse_name = 5.2) {
  # Weg des wandernden Blocks in drei Abschnitten: aus dem Rahmen heben,
  # über die Rahmen hinweg gleiten, in Annas Rahmen absenken
  flug_y <- kasten_h + 1.05
  t3 <- pmin(pmax(3 * t - 0:2, 0), 1)       # Fortschritt je Abschnitt
  s <- glatt(t3)
  d <- bloecke |>
    mutate(x = ifelse(wandert, x_von + (x_nach - x_von) * s[2], x_von),
           y = case_when(!wandert ~ y_von,
                         t3[1] < 1 ~ y_von + (flug_y - y_von) * s[1],
                         t3[2] < 1 ~ flug_y,
                         TRUE ~ flug_y + (y_nach - flug_y) * s[3]))

  p <- ggplot() +
    geom_rect(data = kaesten,
              aes(xmin = x - 0.4, xmax = x + 0.4, ymin = 0.4, ymax = 0.4 + kasten_h),
              fill = NA, color = grau_dunkel, linewidth = 0.7) +
    geom_tile(data = d, aes(x, y, fill = I(fuellung)),
              width = breite, height = 1 - luecke) +
    geom_text(data = kaesten, aes(x, 0.05, label = name),
              size = groesse_name, color = grau_dunkel)

  if (linie > 0) {
    p <- p +
      annotate("segment", x = 0.5, xend = 3.5, y = mw + 0.5, yend = mw + 0.5,
               linetype = "dashed", color = grau_dunkel, linewidth = 0.7,
               alpha = linie) +
      annotate("text", x = 3.55, y = mw + 0.5, hjust = 0,
               label = "Mittelwert\n= 2", size = groesse_name * 0.85,
               color = grau_dunkel, lineheight = 0.9, alpha = linie)
  }

  p +
    coord_fixed(xlim = c(0.5, 4.95), ylim = c(-0.25, kasten_h + 1.7), expand = FALSE) +
    labs(title = titel) +
    theme_leer(medium) +
    theme(plot.title = element_text(face = "bold", size = 16, color = grau_dunkel,
                                    hjust = 0.5, margin = margin(b = 6)),
          plot.margin = margin(10, 10, 10, 10))
}


# GIF ---------------------------------------------------------------------
# vorher (Pause) -> Block wandert -> Linie erscheint (Pause) -> zurück

n_schritte <- 30
schritte <- seq(0, 1, length.out = n_schritte)
n_linie <- 8

titel_vorher <- "Noten: 1 + 2 + 3 = 6"
titel_weg    <- "Ausgleichen: Carla gibt Anna einen Block"
titel_nach   <- "2 + 2 + 2 = 6: Jede hat den Mittelwert"

bilder_folge <- c(
  list(list(t = 0, titel = titel_vorher, linie = 0)),
  map(schritte[-1], \(t) list(t = t, titel = titel_weg, linie = 0)),
  map(seq(0, 1, length.out = n_linie)[-1],
      \(a) list(t = 1, titel = titel_nach, linie = a)),
  list(list(t = 1, titel = titel_nach, linie = 1)),
  map(rev(schritte)[-c(1, n_schritte)],
      \(t) list(t = t, titel = titel_vorher, linie = 0))
)
verzoegerung <- c(220, rep(6, n_schritte - 1), rep(6, n_linie - 1), 320,
                  rep(4, n_schritte - 2))

tmp <- tempfile()
dir.create(tmp)
dateien <- imap_chr(bilder_folge, function(b, i) {
  f <- file.path(tmp, sprintf("bild_%03d.png", i))
  ggsave(f, ausgleich_bild(b$t, b$titel, b$linie),
         width = 5.6, height = 4.6, dpi = 100, bg = "white")
  f
})
anim <- image_animate(image_read(dateien), delay = verzoegerung, optimize = TRUE)
image_write(anim, "img/mw-ausgleich-anim.gif")
unlink(tmp, recursive = TRUE)


# Standbild für das PDF: vorher links, nachher rechts ----------------------

statisch <- function() {
  vorher <- ausgleich_bild(0, "Vorher: 1 + 2 + 3", medium = "pdf",
                           groesse_name = 3.4) +
    theme(plot.title = element_text(size = 11))
  nachher <- ausgleich_bild(1, "Nachher: 2 + 2 + 2", linie = 1, medium = "pdf",
                            groesse_name = 3.4) +
    theme(plot.title = element_text(size = 11))
  patchwork::wrap_plots(vorher, nachher, nrow = 1)
}

ggsave("img/mw-ausgleich-statisch.pdf", statisch(),
       width = 6.5, height = 2.9, device = cairo_pdf)
ggsave("img/mw-ausgleich-statisch.png", statisch(),
       width = 6.5, height = 2.9, dpi = 200, bg = "white")
