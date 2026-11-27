# Animationen der Quantile (Quartile, Dezile, Perzentile) des Verkaufspreises
# der Mariokart-Spiele (total_pr < 100) für Abb. "fig-quantile-anim" in
# 050-zusammenfassen.qmd.
#
# Manuell ausführen (aus dem Projektordner, .Rprofile lädt _common.R):
#   Rscript funs/mariokart-quantiles-animation.R
#
# Jedes Bild zeigt die Dichte; die Fläche links vom aktuellen Quantil ist
# blau gefüllt und trägt den Anteil p. So sieht man: Das p-Quantil teilt die
# Verteilung so, dass der Anteil p der Werte links davon liegt.

library(tidyverse)
library(magick)

if (!exists("grau_dunkel")) source("_common.R")

data(mariokart, package = "openintro")

preis <- mariokart |>
  filter(total_pr < 100) |>
  pull(total_pr)

# Dichte einmal berechnen und auf den Datenbereich beschränken
dichte <- density(preis, n = 512)
d_dichte <- tibble(x = dichte$x, y = dichte$y) |>
  filter(x >= min(preis), x <= max(preis))
y_max <- max(d_dichte$y)

fuellfarbe <- modelcol   # Blau


# Ein Bild für das p-Quantil ----------------------------------------------

quantil_bild <- function(p, name, nr) {
  q <- quantile(preis, p, names = FALSE)
  links <- d_dichte |> filter(x <= q)
  # Dichte am Quantil, damit die Fläche bis an die Linie reicht
  links <- bind_rows(links, tibble(x = q, y = approx(d_dichte$x, d_dichte$y, q)$y))
  x_anteil <- (min(preis) + q) / 2
  # Label rechts der Linie, ab der Mitte links davon (nicht abschneiden)
  rechts <- q < mean(range(preis))

  ggplot(d_dichte, aes(x, y)) +
    geom_area(fill = grau_hell, color = NA) +
    geom_area(data = links, fill = fuellfarbe, alpha = 0.6, color = NA) +
    geom_line(color = grau_dunkel, linewidth = 0.8) +
    geom_rug(data = tibble(x = preis), aes(x = x), inherit.aes = FALSE,
             color = grau_dunkel, alpha = 0.3, length = unit(0.03, "npc")) +
    annotate("segment", x = q, xend = q, y = 0, yend = y_max * 1.38,
             color = grau_dunkel, linewidth = 0.9) +
    annotate("label", x = q, y = y_max * 1.38,
             label = sprintf("%s %d: %.1f Dollar\n%d %% der Preise sind kleiner",
                             name, nr, q, round(p * 100)),
             hjust = if (rechts) -0.03 else 1.03, vjust = 1, lineheight = 1.1,
             fontface = "bold", color = grau_dunkel, size = 4.5,
             fill = alpha("white", 0.9), linewidth = 0) +
    { if (q - min(preis) >= 6)
        annotate("text", x = x_anteil, y = y_max * 0.12,
                 label = sprintf("%d %%", round(p * 100)),
                 fontface = "bold", color = "white", size = 5) } +
    scale_x_continuous(limits = range(preis),
                       expand = expansion(mult = 0.02)) +
    scale_y_continuous(limits = c(0, y_max * 1.4),
                       expand = expansion(mult = c(0, 0.02))) +
    labs(x = "Verkaufspreis (Dollar)", y = NULL,
         subtitle = "Wahrscheinlichkeitsdichte") +
    theme_med("html", grid = "h", base_size = 14) +
    theme(axis.text.y = element_blank())
}


# Bilder rendern und zu GIF zusammensetzen --------------------------------

speichere_gif <- function(probs, name, datei, delay_cs) {
  tmp <- tempfile()
  dir.create(tmp)
  dateien <- map_chr(seq_along(probs), function(i) {
    f <- file.path(tmp, sprintf("bild_%03d.png", i))
    ggsave(f, quantil_bild(probs[i], name, i),
           width = 7, height = 4.5, dpi = 100, bg = "white")
    f
  })
  bilder <- image_read(dateien)
  # Letztes Bild etwas länger zeigen, dann von vorn
  verzoegerung <- c(rep(delay_cs, length(probs) - 1), delay_cs * 2)
  anim <- image_animate(bilder, delay = verzoegerung, optimize = TRUE)
  image_write(anim, datei)
  unlink(tmp, recursive = TRUE)
  invisible(datei)
}

speichere_gif(c(0.25, 0.50, 0.75), "Quartil",
              "img/p_quartiles_anim.gif", delay_cs = 150)
speichere_gif(seq(0.1, 0.9, by = 0.1), "Dezil",
              "img/p_deciles_anim.gif", delay_cs = 80)
speichere_gif(seq(0.01, 0.99, by = 0.01), "Perzentil",
              "img/p_percentile_anim.gif", delay_cs = 10)
