
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

# Globales Theme mit Gitter an beiden Achsen; wilke_gitter() (unten) nimmt
# beim Bauen jedes Plots das Gitter quer zur Kategorienachse wieder weg.
# Explizit gesetzte Themes (theme_med(grid = ...), theme_streu()) bleiben.
ggplot2::theme_set(theme_med(grid = "both"))

# Aliase (Namen wie im Repo Start:Bayes und im Skill ggplot-diagramme)
dunkelgrau  <- grau_dunkel
mittelgrau  <- grau_mittel
gitterfarbe <- grau_hell
hellgrau    <- "#E5E5E5"   # helles Ende der grauen Sequenzskala
trendfarbe  <- trendcol
trend_linienbreite <- 1.2
.duenne_linie <- function(medium = plot_medium()) {
  if (identical(medium, "folien")) 0.6 else 0.4
}


# ===========================================================================
# Automatik beim Bauen jedes ggplots (Hook auf ggplot_build)
# Uebernommen aus Start:Bayes. Reihenfolge: y-Titel nach oben -> Wilke-Gitter
# -> Tufte-Stil fuer Streu-/Liniendiagramme -> Overplotting-Alpha.
# Schalter: options(y_label_oben = FALSE), options(wilke_gitter = FALSE),
# options(tufte_streu = FALSE), options(tufte_linie = FALSE),
# options(tufte_alpha = FALSE); pro Plot: + tufte_aus()
# ===========================================================================

# Guard: _common.R wird mehrfach gesourct (.Rprofile + Kapitel); Original nur einmal sichern.
if (!exists(".ggplot_build_orig", envir = globalenv(), inherits = FALSE)) {
  assign(".ggplot_build_orig",
         utils::getS3method("ggplot_build", "ggplot2::ggplot",
                            envir = asNamespace("ggplot2")),
         envir = globalenv())
}

# --- Y-Titel horizontal ueber dem Panel (statt vertikal daneben) ---
# Ausnahmen: coord_flip(), Plots ohne bzw. mit ausgeblendetem y-Titel
# (z. B. labs(y = NULL, subtitle = ...) bleibt unveraendert).
.y_label_busy <- new.env()  # Re-Entranz-Schutz: get_labs() baut den Plot selbst
.ist_markdown <- function(x) is.character(x) && grepl("<b|<span|&#", x)
y_label_nach_oben <- function(plot) {
  if (!isTRUE(getOption("y_label_oben", TRUE))) return(plot)
  if (isTRUE(.y_label_busy$on)) return(plot)
  .y_label_busy$on <- TRUE
  on.exit(.y_label_busy$on <- FALSE)
  if (inherits(plot@coordinates, "CoordFlip")) return(plot)
  ti <- tryCatch(ggplot2::calc_element("axis.title.y",
                                       ggplot2::theme_get() + plot@theme),
                 error = function(e) NULL)
  if (inherits(ti, "ggplot2::element_blank")) return(plot)
  ylab <- ggplot2::get_labs(plot)$y
  if (is.null(ylab) || !is.character(ylab) || !nzchar(ylab[1])) return(plot)
  sub <- ggplot2::get_labs(plot)$subtitle
  md <- .ist_markdown(ylab[1])
  el <- if (md) ggtext::element_markdown else ggplot2::element_text
  plot +
    ggplot2::labs(subtitle = if (is.null(sub)) ylab else
                    paste0(sub, if (md) "<br>" else "\n", ylab)) +
    ggplot2::theme(axis.title.y = ggplot2::element_blank(),
                   plot.title.position = "panel",
                   plot.subtitle = el(hjust = 0, color = fast_schwarz,
                                      margin = ggplot2::margin(b = 6)))
}

# --- Schwellenwerte des Diagrammstils (alle an einer Stelle) ---
.tufte_streu_min_n <- 10    # ab so vielen Zeilen: Streu-/Liniendiagramm
.tufte_rug_x_max_n <- 50    # Liniendiagramm: X-Rug nur darunter (oder unregelmaessige X)
.tufte_rug_max_n   <- 500   # darueber kein Rug mehr (waere nur ein grauer Balken)
.tufte_alpha_stufen <- c(`100` = 0.6, `300` = 0.35, `1000` = 0.15)

# Erster Layer der angegebenen Geoms mit genug Zeilen und passenden Daten
# (X numerisch oder Datum/Zeit, Y numerisch). NULL, wenn keiner passt.
.tufte_layer_daten <- function(plot, geoms) {
  tryCatch({
    for (l in plot@layers) {
      if (!inherits(l$geom, geoms)) next
      d <- l$data
      if (inherits(d, "waiver") || is.null(d)) d <- plot@data
      else if (is.function(d)) d <- d(plot@data)
      if (!is.data.frame(d) || nrow(d) < .tufte_streu_min_n) next
      m <- if (isFALSE(l$inherit.aes)) l$mapping else
        ggplot2::aes(!!!utils::modifyList(as.list(plot@mapping), as.list(l$mapping)))
      if (is.null(m$x) || is.null(m$y)) next
      x <- rlang::eval_tidy(m$x, d); y <- rlang::eval_tidy(m$y, d)
      x_ok <- is.numeric(x) || inherits(x, c("Date", "POSIXct"))
      if (!x_ok || !is.numeric(y) || length(x) < .tufte_streu_min_n) next
      return(list(d = d, m = ggplot2::aes(x = !!m$x, y = !!m$y), x = x, y = y))
    }
    NULL
  }, error = function(e) NULL)
}

# --- Tufte-Stil fuer Streu- und Liniendiagramme ---
# Kein Gitter, Range-Frame (Achsenlinie nur im Datenbereich), Ticks im
# Datenbereich, grauer Rug. Ersetzt "+ rangeframe() + theme_streu()" von Hand.
# Uebersprungen: coord_flip(), Plots mit vorhandenem geom_rug()/
# geom_rangeframe() (also alle bisher von Hand gestalteten), Heatmaps,
# DAGs, Punkt-Layer < 10 Zeilen, Linien mit Flaechen-/Dichte-Layer.
tufte_streu <- function(plot) {
  if (!isTRUE(getOption("tufte_streu", TRUE))) return(plot)
  if (inherits(plot@coordinates, "CoordFlip")) return(plot)
  gtypes <- vapply(plot@layers, function(l) class(l$geom)[1], character(1))
  if (any(gtypes %in% c("GeomRug", "GeomRangeFrame"))) return(plot)
  if (any(gtypes %in% c("GeomRaster", "GeomTile", "GeomContourFilled",
                        "GeomDensity2dFilled"))) return(plot)
  if (any(grepl("^Geom(Dag|DAG|Edge|Node)", gtypes))) return(plot)
  hex <- any(gtypes == "GeomHex")
  res <- if (hex) .tufte_layer_daten(plot, "GeomHex") else {
    r <- .tufte_layer_daten(plot, "GeomPoint")
    if (is.null(r) && !"GeomPoint" %in% gtypes)
      r <- .tufte_layer_daten(plot, "GeomText")
    r
  }
  rug_seiten <- if (hex) "" else "bl"
  linie_ok <- isTRUE(getOption("tufte_linie", TRUE)) &&
    !isTRUE(plot@meta$tufte_aus) &&
    !any(gtypes %in% c("GeomArea", "GeomRibbon", "GeomDensity", "GeomPolygon"))
  if (is.null(res) && linie_ok) {
    res <- .tufte_layer_daten(plot, c("GeomLine", "GeomPath"))
    if (!is.null(res)) {
      xu <- sort(unique(as.numeric(res$x)))
      regelmaessig <- length(xu) > 2 && {
        dx <- diff(xu); max(dx) <= 1.15 * min(dx)
      }
      rug_x <- length(xu) < .tufte_rug_x_max_n || !regelmaessig
      rug_seiten <- if (rug_x) "bl" else "l"
    }
  }
  if (is.null(res)) return(plot)
  if (length(res$x) > .tufte_rug_max_n) rug_seiten <- ""

  lw <- .duenne_linie()
  nur_im_bereich <- function(v) {
    r <- range(v, na.rm = TRUE)
    function(lims) {
      b <- scales::extended_breaks()(lims)
      b[b >= r[1] - 1e-9 & b <= r[2] + 1e-9]
    }
  }
  if (is.null(plot@scales$get_scales("x")) && is.numeric(res$x))
    plot <- plot + ggplot2::scale_x_continuous(breaks = nur_im_bereich(res$x))
  if (is.null(plot@scales$get_scales("y")))
    plot <- plot + ggplot2::scale_y_continuous(breaks = nur_im_bereich(res$y))

  plot +
    ggthemes::geom_rangeframe(data = res$d, mapping = res$m, inherit.aes = FALSE,
                              color = dunkelgrau, size = lw) +
    (if (nzchar(rug_seiten))
      tufte_rug(data = res$d, mapping = res$m, inherit.aes = FALSE,
                sides = rug_seiten)
     else NULL) +
    ggplot2::theme(panel.grid = ggplot2::element_blank(),
                   panel.grid.major = ggplot2::element_blank(),
                   panel.grid.major.x = ggplot2::element_blank(),
                   panel.grid.major.y = ggplot2::element_blank(),
                   panel.grid.minor = ggplot2::element_blank(),
                   axis.ticks = ggplot2::element_line(color = dunkelgrau, linewidth = lw),
                   axis.ticks.length = grid::unit(3, "pt"))
}

# Rug im Buchstil; auch fuer Dichten mit Rohdaten: geom_density(...) + tufte_rug()
tufte_rug <- function(sides = "b", ...) {
  do.call(ggplot2::geom_rug, utils::modifyList(
    list(sides = sides, color = dunkelgrau, alpha = 0.3, linewidth = 0.3,
         length = grid::unit(0.02, "npc")),
    list(...)))
}

# --- Wilke-Gitter nur an der Werteachse ---
# Werteachse = y, ausser bei coord_flip() oder diskretem y (liegend), dann x.
# Greift nur, wenn der Plot das Gitter nicht selbst setzt.
.y_diskret <- function(plot) {
  tryCatch({
    sk <- plot@scales$get_scales("y")
    if (!is.null(sk)) return(sk$is_discrete())
    for (l in plot@layers) {
      m <- if (isFALSE(l$inherit.aes)) l$mapping else
        utils::modifyList(as.list(plot@mapping), as.list(l$mapping))
      if (is.null(m$y)) next
      d <- l$data
      if (inherits(d, "waiver") || is.null(d)) d <- plot@data
      else if (is.function(d)) d <- d(plot@data)
      y <- rlang::eval_tidy(m$y, d)
      return(is.character(y) || is.factor(y) || is.logical(y))
    }
    FALSE
  }, error = function(e) FALSE)
}
wilke_gitter <- function(plot) {
  if (!isTRUE(getOption("wilke_gitter", TRUE))) return(plot)
  th <- plot@theme
  eigen <- c("panel.grid", "panel.grid.major", "panel.grid.major.x",
             "panel.grid.major.y")
  if (any(vapply(eigen, function(e) !is.null(th[[e]]), logical(1)))) return(plot)
  liegend <- inherits(plot@coordinates, "CoordFlip") || .y_diskret(plot)
  off <- ggplot2::element_blank()
  if (liegend) plot + ggplot2::theme(panel.grid.major.y = off)
  else plot + ggplot2::theme(panel.grid.major.x = off)
}

# Opt-out pro Plot: "+ tufte_aus()" (z. B. geom_line einer berechneten Kurve)
tufte_aus <- function() structure(list(), class = "tufte_aus")
base::registerS3method("ggplot_add", "tufte_aus",
                       function(object, plot, object_name) {
                         plot@meta$tufte_aus <- TRUE
                         plot
                       },
                       envir = asNamespace("ggplot2"))

# --- Overplotting: Punkt-Layer ohne gesetztes/gemapptes alpha werden ab
# 100/300/1000 Zeilen durchsichtig (0.6/0.35/0.15). Explizites alpha gewinnt.
tufte_alpha <- function(plot) {
  if (!isTRUE(getOption("tufte_alpha", TRUE))) return(plot)
  for (i in seq_along(plot@layers)) {
    l <- plot@layers[[i]]
    if (!inherits(l$geom, "GeomPoint")) next
    if (!is.null(l$aes_params$alpha) || !is.null(l$mapping$alpha) ||
        (!isFALSE(l$inherit.aes) && !is.null(plot@mapping$alpha))) next
    d <- tryCatch({
      d <- l$data
      if (inherits(d, "waiver") || is.null(d)) plot@data
      else if (is.function(d)) d(plot@data) else d
    }, error = function(e) NULL)
    if (!is.data.frame(d)) next
    grenzen <- as.numeric(names(.tufte_alpha_stufen))
    stufe <- sum(nrow(d) >= grenzen)
    if (stufe == 0) next
    plot@layers[[i]] <- .layer_mit_alpha(l, unname(.tufte_alpha_stufen[stufe]))
  }
  plot
}
# Kopie des Layers, damit das Plot-Objekt selbst unveraendert bleibt
.layer_mit_alpha <- function(eltern, alpha) {
  ggplot2::ggproto(NULL, eltern, aes_params = c(eltern$aes_params, list(alpha = alpha)))
}

base::registerS3method("ggplot_build", "ggplot2::ggplot",
                       function(plot) .ggplot_build_orig(
                         tufte_alpha(tufte_streu(wilke_gitter(y_label_nach_oben(plot))))),
                       envir = asNamespace("ggplot2"))


# --- Standard-Skalen ---
# Diskrete Farbe/Fuellung: Okabe-Ito-Folge ohne Gelb (fuer jedes gemappte
# color/fill ohne eigene Skala). Kontinuierliche Fuellung: graue Sequenzskala.
options(
  ggplot2.discrete.colour = okabe_linie,
  ggplot2.discrete.fill = okabe_linie,
  ggplot2.continuous.fill = function(...)
    ggplot2::scale_fill_gradient(low = hellgrau, high = dunkelgrau, ...)
)

# Abweichende Reihenfolge der Okabe-Ito-Farben, z. B. scale_fill_gruppen(c(2, 1))
scale_colour_gruppen <- function(reihenfolge = seq_along(okabe_linie), ...) {
  ggplot2::scale_colour_manual(values = unname(okabe_linie[reihenfolge]), ...)
}
scale_color_gruppen <- scale_colour_gruppen
scale_fill_gruppen <- function(reihenfolge = seq_along(okabe_linie), ...) {
  ggplot2::scale_fill_manual(values = unname(okabe_linie[reihenfolge]), ...)
}


# --- ggpubr: Buch-Theme und Buchfarben statt theme_pubr() und Schwarz ---
# Muss vor library(ggpubr) laufen (_common.R wird per .Rprofile vorab geladen).
if (requireNamespace("ggpubr", quietly = TRUE)) {
  utils::assignInNamespace("theme_pubr", function(...) ggplot2::theme(),
                           ns = "ggpubr")
  .ggpubr_defaults <- function(fn, color, fill = NULL) {
    for (f_name in c(fn, paste0(fn, "_core"))) {
      if (!exists(f_name, envir = asNamespace("ggpubr"), inherits = FALSE)) next
      f <- get(f_name, envir = asNamespace("ggpubr"))
      fm <- formals(f)
      fm$color <- color
      if (!is.null(fill) && "fill" %in% names(fm)) fm$fill <- fill
      formals(f) <- fm
      utils::assignInNamespace(f_name, f, ns = "ggpubr")
    }
  }
  for (fn in c("ggline", "ggscatter", "ggdensity", "ggboxplot", "ggviolin",
               "ggstripchart", "ggdotchart", "ggecdf", "ggqqplot"))
    .ggpubr_defaults(fn, color = dunkelgrau, fill = mittelgrau)
  for (fn in c("ggbarplot", "gghistogram"))
    .ggpubr_defaults(fn, color = "white", fill = mittelgrau)
  .ggpubr_defaults(".plotter",
                   color = bquote(if (isTRUE(fun_name == "barplot") ||
                                      identical(fun, gghistogram_core))
                                    "white" else .(dunkelgrau)),
                   fill = mittelgrau)
}

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
# Balken und Histogrammsaeulen mit weissem Trennrand
ggplot2::update_geom_defaults("bar", list(fill = grau_mittel, colour = "white"))
ggplot2::update_geom_defaults("col", list(fill = grau_mittel, colour = "white"))
ggplot2::update_geom_defaults("rect", list(fill = grau_mittel))
ggplot2::update_geom_defaults("boxplot", list(fill = "white", colour = grau_dunkel))
ggplot2::update_geom_defaults("smooth", list(colour = trendcol, fill = trendcol, alpha = 0.2, linewidth = 1.2))
# Bezugslinien dunkelgrau statt schwarz
for (g in c("vline", "hline", "abline"))
  ggplot2::update_geom_defaults(g, list(colour = grau_dunkel))
# Flaechen und Violinen (1 Gruppe) mittelgrau. Bewusst NICHT geom_density
# (bleibt Umriss; gefuellte Dichten setzen fill = grau_mittel explizit).
ggplot2::update_geom_defaults("area", list(fill = grau_mittel))
ggplot2::update_geom_defaults("violin", list(fill = grau_mittel))
# Beschriftungskaesten ohne Rahmen auf leicht durchsichtigem Weiss
ggplot2::update_geom_defaults("label", list(fill = scales::alpha("white", 0.85),
                                            linewidth = 0))


# Cache-Schutz fuer Abbildungen: knitr erneuert einen gecachten Chunk nur,
# wenn sich SEIN Code aendert -- nicht, wenn sich _common.R oder ein per
# source() eingebundenes Hilfsskript aendert. Daher geht fuer Abbildungs-
# Chunks ein Hash ueber diese Dateien in cache.extra ein: Aendert sich eine
# davon, werden alle Abbildungen neu gezeichnet; Chunks ohne Abbildung
# (z. B. Modellschaetzungen) bleiben im Cache. render-book.R verwirft
# zusaetzlich _freeze/, wenn sich der Hash seit dem letzten Lauf geaendert hat.
helper_files_hash <- local({
  files <- c(Sys.glob(c("funs/*.R", "children/*.R")), "_common.R")
  files <- files[file.exists(files)]
  paste(unname(tools::md5sum(sort(files))), collapse = "")
})

knitr::opts_hooks$set(label = function(options) {
  code <- paste(options$code, collapse = "\n")
  is_fig_chunk <-
    grepl("^fig-", options$label) ||
    !is.null(options$fig.cap) ||
    grepl(paste0("\\bgg[a-zA-Z0-9_.]*\\s*\\(",      # ggplot(), gghistogram() ...
                 "|plot[_a-zA-Z0-9]*\\s*\\(",        # plot(), plot_xyz() ...
                 "|[a-zA-Z0-9]_?plot\\b|plot_[a-zA-Z0-9_]+",
                 "|\\bgeom_|\\blabs\\(",
                 "|source\\(\\s*[\"'](\\./)?(funs|children)/",
                 "|(?m)^\\s*p[0-9a-z_]*\\s*$"),      # gespeicherter Plot, z. B. "p3"
          code, perl = TRUE)
  if (is_fig_chunk) {
    options$cache.extra <- list(options$cache.extra, helper_files_hash)
  }
  options
})

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
  
  # Schrift ueber die systemweite Fontregistrierung suchen (macOS/Linux/
  # Windows) statt fester Pfade; fehlt sie, mit Hinweis ueberspringen.
  add_system_font <- function(sysfonts_name, family) {
    hit <- systemfonts::system_fonts()
    hit <- hit[tolower(hit$family) == tolower(family) &
                 tolower(hit$style) %in% c("regular", "normal"), ]
    if (nrow(hit) == 0) {
      hit <- systemfonts::system_fonts()
      hit <- hit[tolower(hit$family) == tolower(family), ]
    }
    if (nrow(hit) == 0) {
      message("Schrift '", family, "' nicht gefunden -- ",
              "ueberspringe font_add() fuer '", sysfonts_name, "'.")
      return(invisible(NULL))
    }
    sysfonts::font_add(sysfonts_name, regular = hit$path[1])
  }

  add_system_font("Lato Regular", "Lato")
  add_system_font("Lato", "Lato")
  add_system_font("Font Awesome", "FontAwesome")
  add_system_font("Roboto Regular", "Roboto")


  
  ggplot2::theme_set(theme_med("pdf"))
  
  }
