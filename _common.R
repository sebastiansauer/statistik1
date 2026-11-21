
set.seed(42)

library(knitr)
# define a method for objects of the class data.frame
knit_print.head = function(x, ...) {
  res = paste(c('', '', kable(head(x))), collapse = '\n')
  asis_output(res)
}
# register the method
registerS3method("knit_print", "data.frame", knit_print.head)

base_size <- 18
base_family <- "Lato Regular"


# Define a custom ggplot theme with larger text
theme_large_text <- function(base_size = 18) {
  theme_minimal(base_size = base_size) +
    theme(
      text = element_text(size = base_size + 4),          # Base text size
      axis.title = element_text(size = base_size + 6),    # Axis title text size
      axis.text = element_text(size = base_size + 4),     # Axis tick text size
      plot.title = element_text(size = base_size + 10, face = "bold"), # Plot title size
      plot.subtitle = element_text(size = base_size + 8), # Subtitle text size
      legend.text = element_text(size = base_size + 4),   # Legend text size
      legend.title = element_text(size = base_size + 6)   # Legend title text size
    )
}



# ---------------------------------------------------------------------------
# Buchweites Diagramm-Setup (Styleguide "ggplot-Diagramme")
# Grau ist Standard; Farbe nur fuer Hervorhebung/Gruppen (Okabe-Ito, kein Gelb).
# ---------------------------------------------------------------------------

grau_dunkel <- "#4D4D4D"   # Punkte, Linien (1 Gruppe)
grau_mittel <- "#999999"   # Fuellung (1 Gruppe), Balken, Histogramm
grau_hell   <- "#D9D9D9"   # Gitterlinien
trendcol    <- "#0072B2"   # Regressionsgerade ueber Punktwolke
fast_schwarz <- "#1A1A1A"  # Text auf farbiger Flaeche

# Linien-/Fuellfarben und (abgedunkelte) Textfarben fuer Gruppen 1..6
okabe_linie <- c("#E69F00", "#0072B2", "#009E73", "#56B4E9", "#D55E00", "#CC79A7")
okabe_text  <- c("#B36B00", "#0072B2", "#007A59", "#2B7FB0", "#D55E00", "#A5527F")
formen      <- c(16, 17, 15, 18)  # Kreis, Dreieck, Quadrat, Raute

# Medium erkennen (Folien: options(plot_medium = "folien") im Setup-Chunk)
plot_medium <- function() {
  if (knitr::is_latex_output()) "pdf" else getOption("plot_medium", "html")
}

# Theme; grid: "h" = Wilke-Gitter nur horizontal (Standard: Histogramm,
# Boxplot, Dichte), "v" = nur vertikal (liegende Werteachse), "none" (Streu-
# und Liniendiagramme, Balken mit Wertelabels), "both".
# Der y-Titel wird oben ueber dem Panel gesetzt: labs(y = NULL, subtitle = "...")
theme_med <- function(medium = plot_medium(),
                      grid = c("h", "v", "none", "both"),
                      base_size = NULL) {
  medium <- match.arg(medium, c("html", "pdf", "folien"))
  grid <- match.arg(grid)
  bs <- if (is.null(base_size)) switch(medium, html = 11, pdf = 10.5, folien = 19) else base_size
  lw <- if (medium == "folien") 0.6 else 0.4
  gl <- ggplot2::element_line(color = grau_hell, linewidth = lw)
  off <- ggplot2::element_blank()

  ggplot2::theme_minimal(base_size = bs) +
    ggplot2::theme(
      plot.title.position = "plot",
      plot.title = ggplot2::element_text(face = "bold"),
      plot.subtitle = ggplot2::element_text(hjust = 0, color = fast_schwarz),
      plot.caption = ggplot2::element_text(color = grau_dunkel),
      panel.grid.minor = off,
      panel.grid.major.x = if (grid %in% c("both", "v")) gl else off,
      panel.grid.major.y = if (grid %in% c("both", "h")) gl else off,
      axis.line = off,
      axis.ticks = off,
      strip.text = ggplot2::element_text(face = "bold"),
      panel.spacing = ggplot2::unit(1.5, "lines"),
      legend.position = "bottom"   # Fallback; Linien/Balken direkt beschriften
    )
}

# Streu-/Liniendiagramm: kein Gitter, Range-Frame (Achsenlinie nur im
# Datenbereich) mit Ticks. Verwendung: + rangeframe() + theme_streu()
theme_streu <- function(medium = plot_medium(), base_size = NULL) {
  theme_med(medium, grid = "none", base_size = base_size) +
    ggplot2::theme(axis.ticks = ggplot2::element_line(color = grau_dunkel),
                   axis.ticks.length = ggplot2::unit(3, "pt"))
}
rangeframe <- function(...) ggthemes::geom_rangeframe(color = grau_dunkel, ...)

# Rug (graue Striche an der Achse); sides = "bl" fuer beide Achsen
rug_grau <- function(sides = "bl", ...) {
  ggplot2::geom_rug(color = grau_dunkel, alpha = 0.3, sides = sides, ...)
}

# Overplotting-Alpha nach Anzahl Punkte
alpha_n <- function(n) {
  if (n >= 1000) 0.15 else if (n >= 300) 0.35 else if (n >= 100) 0.6 else 1
}

ggplot2::theme_set(theme_med())

# Teilbilder (zwei Diagramme nebeneinander per layout/layout-ncol):
# Chunk-Option `#| teilbild: true` setzen. Das Bild wird dann kleiner
# gerechnet (fig-width 4 statt 6) und anschliessend auf die halbe Spalte
# skaliert. So wachsen Schrift, Punkte und Linien gemeinsam um den Faktor 1.5
# und sind im halbbreiten Bild genauso gross wie im Einzelbild.
# Nicht theme_large_text() oder theme(text = ...) verwenden.
teilbild_breite <- 4
knitr::opts_hooks$set(teilbild = function(options) {
  if (isTRUE(options$teilbild)) {
    options$fig.width <- teilbild_breite
  }
  options
})

# Grau als Standardfarbe der Geome (auch fuer sichtbaren Lehr-Code)
ggplot2::update_geom_defaults("point", list(colour = grau_dunkel))
ggplot2::update_geom_defaults("line", list(colour = grau_dunkel))
ggplot2::update_geom_defaults("path", list(colour = grau_dunkel))
ggplot2::update_geom_defaults("bar", list(fill = grau_mittel))
ggplot2::update_geom_defaults("col", list(fill = grau_mittel))
ggplot2::update_geom_defaults("rect", list(fill = grau_mittel))
ggplot2::update_geom_defaults("boxplot", list(fill = "white", colour = grau_dunkel))
ggplot2::update_geom_defaults("smooth", list(colour = trendcol, fill = trendcol, alpha = 0.2, linewidth = 1.2))

knitr::opts_chunk$set(tidy = FALSE, 
                      width = 60, 
                      fig.retina = 2,
                      max.print = 100,
                      fig.dpi = 300,
                      warning = FALSE,
                      out.width = "70%", # enough room to breath
                      fig.width = 6,     # reasonable size
                      fig.asp = 0.618,   # golden ratio
                      fig.align = "center" # mostly what I want
)


options(
  dplyr.print_min = 6,
  dplyr.print_max = 6,
  pillar.max_footer_lines = 2,
  pillar.min_chars = 15,
  stringr.view_n = 6,
  # Temporarily deactivate cli output for quarto
  cli.num_colors = 0,
  cli.hyperlink = FALSE,
  pillar.bold = TRUE,
  digits = 2,
  width = 77 # 80 - 3 for #> comment
)

   

# Buchweites Farbschema (Okabe-Ito). Bei 1 Gruppe/Linie: Blau (modelcol).
# Bei 2 Gruppen: Orange + Blau (beta0col/beta1col) -- vorher Zinnober/Himmelblau,
# auf Orange/Blau vereinheitlicht fuer Konsistenz mit dem ggplot-Diagramme-Styleguide.
ycol <- "#E69F00"
modelcol <- "#0072B2"
errorcol <- "#009E73"
beta0col <- "#E69F00"
beta1col <- "#0072B2"
xcol <- "#CC79A7"

yellow <- "#F0E442FF"
blue <- "#0072B2FF"
orange <- "#E69F00FF"




#ggplot2::theme_set(see::theme_modern(axis.title.size = 18))

labeltextsize <- 8



utils::data("mariokart", package = "openintro")

mariokart_no_extreme <- mariokart[mariokart$total_pr < 100, ]


mariokart_path <- "https://vincentarelbundock.github.io/Rdatasets/csv/openintro/mariokart.csv"





if (knitr:::is_latex_output()) {
  
  # add font for plots in PDF output:
  
  showtext::showtext_auto(TRUE)  # use "showtext" automatically
  
  sysfonts::font_add("Lato Regular", regular = "/Users/sebastiansaueruser/Library/Fonts/Lato-Regular.ttf")
  
  sysfonts::font_add("Lato", regular = "/Users/sebastiansaueruser/Library/Fonts/Lato-Regular.ttf")
  
  sysfonts::font_add("Font Awesome", regular = "~/Library/Fonts/fontawesome-webfont.ttf")
  
  sysfonts::font_add("Roboto Regular", regular = "/Users/sebastiansaueruser/Library/Fonts/Roboto-Regular.ttf")
  

  
  ggplot2::theme_set(theme_med("pdf"))
  
  }
