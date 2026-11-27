# Logo-Varianten für statistik1 als Vektorgrafik (SVG) erzeugen
# Aufruf: Rscript funs/logo-statistik1-varianten.R
# Ergebnis: img/logo-varianten/logo-{a,b,c}.svg (+ PNG, falls rsvg-convert vorhanden)

set.seed(42)
navy   <- "#062047"
navy2  <- "#1F3D6B"
orange <- "#E69F00"   # Okabe-Ito
blau   <- "#56B4E9"   # Okabe-Ito
hell   <- "#F4F1EA"

ausgabe <- "img/logo-varianten"
dir.create(ausgabe, showWarnings = FALSE, recursive = TRUE)

hex_punkte <- function(cx = 260, cy = 300, r = 286) {
  w <- (0:5) * pi / 3 - pi / 2
  paste(sprintf("%.1f,%.1f", cx + r * cos(w), cy + r * sin(w)), collapse = " ")
}

# Daten: fast perfekter linearer Zusammenhang ("Great Fit")
n <- 22
x <- sort(runif(n, 0.04, 0.96))
y <- x + rnorm(n, 0, 0.045)

# Daten in ein Plotfenster [x0, x1] × [y0, y1] (SVG-Koordinaten) abbilden
skaliere <- function(x0, x1, y0, y1) {
  list(px = x0 + x * (x1 - x0), py = y1 - y * (y1 - y0),
       lx = c(x0, x1), ly = c(y1 - 0 * (y1 - y0), y1 - 1 * (y1 - y0)))
}

punkte_svg <- function(s, fill, r = 7, opacity = 0.9, stroke = "none") {
  paste(sprintf('<circle cx="%.1f" cy="%.1f" r="%g" fill="%s" fill-opacity="%g" stroke="%s" stroke-width="2"/>',
                s$px, s$py, r, fill, opacity, stroke), collapse = "\n  ")
}

linie_svg <- function(s, col, lwd = 7) {
  sprintf('<line x1="%.1f" y1="%.1f" x2="%.1f" y2="%.1f" stroke="%s" stroke-width="%g" stroke-linecap="round"/>',
          s$lx[1], s$ly[1], s$lx[2], s$ly[2], col, lwd)
}

# Tufte-Rangeframe: Achsen nur über den Datenbereich
rahmen_svg <- function(s, col, x0, y1) {
  sprintf(paste0('<line x1="%.1f" y1="%.1f" x2="%.1f" y2="%.1f" stroke="%s" stroke-width="3"/>',
                 '<line x1="%.1f" y1="%.1f" x2="%.1f" y2="%.1f" stroke="%s" stroke-width="3"/>'),
          min(s$px), y1 + 16, max(s$px), y1 + 16, col,
          x0 - 16, min(s$py), x0 - 16, max(s$py), col)
}

kopf <- '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 520 600" width="520" height="600">
<style>text{font-family:Lato,"Source Sans Pro",Helvetica,Arial,sans-serif}</style>'

# --- Variante A: dunkel, Diagramm direkt im Hexagon (kein weißer Kasten) ----
s <- skaliere(175, 385, 245, 430)
a <- paste0(kopf, '
<polygon points="', hex_punkte(), '" fill="', navy, '" stroke="', navy2, '" stroke-width="14" stroke-linejoin="round"/>
<text x="260" y="190" text-anchor="middle" font-size="58" font-weight="900" fill="white" letter-spacing="1">statistik<tspan fill="', orange, '">1</tspan></text>
', rahmen_svg(s, "#8FA3C4", 175, 430), '
', linie_svg(s, orange), '
  ', punkte_svg(s, "white", opacity = 0.92), '
<text x="280" y="482" text-anchor="middle" font-size="26" fill="#B9C6DC" font-style="italic">du</text>
<text transform="translate(140,337) rotate(-90)" text-anchor="middle" font-size="26" fill="#B9C6DC" font-style="italic">statistik</text>
<text x="185" y="270" font-size="26" font-weight="700" fill="', orange, '">great fit!</text>
</svg>')
writeLines(a, file.path(ausgabe, "logo-a.svg"))

# --- Variante B: hell, cremefarbener Grund, dunkle Punkte -------------------
b <- paste0(kopf, '
<polygon points="', hex_punkte(), '" fill="', hell, '" stroke="', navy, '" stroke-width="22" stroke-linejoin="round"/>
<text x="260" y="190" text-anchor="middle" font-size="58" font-weight="900" fill="', navy, '" letter-spacing="1">statistik<tspan fill="', orange, '">1</tspan></text>
', rahmen_svg(s, "#9AA5B5", 175, 430), '
', linie_svg(s, orange), '
  ', punkte_svg(s, navy, opacity = 0.85), '
<text x="280" y="482" text-anchor="middle" font-size="26" fill="#5A6678" font-style="italic">du</text>
<text transform="translate(140,337) rotate(-90)" text-anchor="middle" font-size="26" fill="#5A6678" font-style="italic">statistik</text>
<text x="185" y="270" font-size="26" font-weight="700" fill="', orange, '">great fit!</text>
</svg>')
writeLines(b, file.path(ausgabe, "logo-b.svg"))

# --- Variante C: minimal – Punktwolke diagonal über das ganze Hexagon -------
s2 <- skaliere(125, 395, 130, 375)
c_svg <- paste0(kopf, '
<defs><clipPath id="hex"><polygon points="', hex_punkte(r = 280), '"/></clipPath></defs>
<polygon points="', hex_punkte(), '" fill="', navy, '" stroke="', navy2, '" stroke-width="14" stroke-linejoin="round"/>
<g clip-path="url(#hex)">
', sprintf('<line x1="40" y1="%.1f" x2="480" y2="%.1f" stroke="%s" stroke-width="8" stroke-linecap="round"/>',
           375 + (125 - 40) * 245 / 270, 375 - (480 - 125) * 245 / 270, orange), '
  ', punkte_svg(s2, blau, r = 9, opacity = 0.95), '
</g>
<text x="260" y="480" text-anchor="middle" font-size="56" font-weight="900" fill="white" letter-spacing="1">statistik<tspan fill="', orange, '">1</tspan></text>
</svg>')
writeLines(c_svg, file.path(ausgabe, "logo-c.svg"))

if (nzchar(Sys.which("rsvg-convert"))) {
  for (v in c("a", "b", "c")) {
    system2("rsvg-convert", c("-w", "518", "-o",
                              file.path(ausgabe, paste0("logo-", v, ".png")),
                              file.path(ausgabe, paste0("logo-", v, ".svg"))))
  }
}
