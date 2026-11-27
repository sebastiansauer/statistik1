# ============================================================
# Umfrage unter Studierenden: Datensatz zum Aufräumen
# ------------------------------------------------------------
# Aufruf aus dem Projektordner: Rscript funs/umfrage_simulieren.R
# Erzeugt (im Ordner data/):
#   umfrage_sauber.csv       Referenz, vor der Verunreinigung
#   umfrage_roh.csv          verunreinigte Datei (Aufgabe)
#   umfrage_fehlerliste.md   Liste aller eingebauten Probleme
# Hinweis: data/umfrage_dictionary.md ist von Hand geschrieben.
#
# Reproduzierbar: fester Seed. Nur tidyverse nötig.
# Verwendet in Kapitel 030 (Abschnitt "Probleme schon beim Einlesen").
# ============================================================

library(tidyverse)

ziel <- "data"

set.seed(2026)
n <- 120


# ------------------------------------------------------------
# 1. Saubere Daten simulieren (leichte Zusammenhänge)
# ------------------------------------------------------------

# Verkehrsmittel hängt von der Entfernung ab
wahl_verkehrsmittel <- function(km) {
  if (km < 2) {
    sample(c("zu Fuss", "Fahrrad", "Bus"), 1, prob = c(.60, .35, .05))
  } else if (km < 8) {
    sample(c("Fahrrad", "Bus", "Auto", "Bahn"), 1, prob = c(.40, .30, .20, .10))
  } else {
    sample(c("Bahn", "Auto", "Bus"), 1, prob = c(.45, .35, .20))
  }
}

# Minuten pro Kilometer je Verkehrsmittel
min_pro_km <- c("zu Fuss" = 12, "Fahrrad" = 4, "Bus" = 3, "Bahn" = 2.2, "Auto" = 1.5)

sauber <-
  tibble(
    id = sprintf("S%03d", 1:n),
    # rechtsschief: die meisten Anfang 20, wenige älter
    alter = pmin(18 + round(rgamma(n, shape = 2, rate = 0.6)), 40),
    geschlecht = sample(c("weiblich", "maennlich", "divers"), n,
                        replace = TRUE, prob = c(.55, .42, .03)),
    studiengang = sample(c("Psychologie", "BWL", "Wirtschaftsinformatik", "Soziale Arbeit"),
                         n, replace = TRUE, prob = c(.35, .30, .20, .15)),
    wohnort_entfernung_km = pmin(pmax(round(rlnorm(n, log(8), 0.8), 1), 0.5), 40)
  ) |>
  mutate(
    # Semester passt grob zum Alter
    semester = pmin(pmax(round((alter - 18) * 1.2 + 1 + rnorm(n, 0, 0.8)), 1), 10),
    verkehrsmittel = map_chr(wohnort_entfernung_km, wahl_verkehrsmittel),
    # Pendelweg hängt an Entfernung und Verkehrsmittel
    pendelweg_min = round(5 + wohnort_entfernung_km *
                            unname(min_pro_km[verkehrsmittel]) *
                            exp(rnorm(n, 0, 0.15))),
    zufriedenheit = sample(1:5, n, replace = TRUE, prob = c(.05, .12, .30, .35, .18)),
    schlaf_std = pmin(pmax(round(rnorm(n, 7, 0.9) * 2) / 2, 4.5), 9.5)
  ) |>
  select(id, alter, geschlecht, studiengang, semester, pendelweg_min,
         verkehrsmittel, zufriedenheit, schlaf_std, wohnort_entfernung_km)

write_csv(sauber, file.path(ziel, "umfrage_sauber.csv"))


# ------------------------------------------------------------
# 2. Hilfsfunktionen zum Verunreinigen
# ------------------------------------------------------------

# Alles als Text, damit beliebige Fehler (z.B. "k.A.") möglich sind
roh <- sauber |> mutate(across(everything(), as.character))

# Protokoll aller eingebauten Fehler
protokoll <- tibble(art = character(), spalte = character(), id = character(),
                    ist = character(), soll = character(), hinweis = character())

# Zeilen, die noch nicht verunreinigt wurden (jede Zeile höchstens einmal)
pool <- sample(n)

ziehe <- function(k = 1, bedingung = rep(TRUE, n)) {
  kandidaten <- pool[bedingung[pool]]
  gezogen <- kandidaten[sample.int(length(kandidaten), k)]
  pool <<- setdiff(pool, gezogen)
  gezogen
}

setze <- function(zeile, spalte, wert, art, hinweis = "") {
  soll <- roh[[spalte]][zeile]
  roh[[spalte]][zeile] <<- wert
  protokoll <<- add_row(protokoll,
                        art = art, spalte = spalte, id = roh$id[zeile],
                        ist = if (is.na(wert)) "(leer)" else wert,
                        soll = soll, hinweis = hinweis)
}


# ------------------------------------------------------------
# 3. Fehler in den Werten einbauen
# ------------------------------------------------------------

# Fehler 1: Fehlende Werte als leere Zelle (4)
z <- ziehe(4)
setze(z[1], "alter",          NA_character_, "Fehlend: leere Zelle")
setze(z[2], "semester",       NA_character_, "Fehlend: leere Zelle")
setze(z[3], "pendelweg_min",  NA_character_, "Fehlend: leere Zelle")
setze(z[4], "verkehrsmittel", NA_character_, "Fehlend: leere Zelle")

# Fehler 2: Fehlende Werte als "k.A." (2) -- Spalte wird als Text eingelesen
z <- ziehe(2)
setze(z[1], "wohnort_entfernung_km", "k.A.", "Fehlend: k.A.")
setze(z[2], "wohnort_entfernung_km", "k.A.", "Fehlend: k.A.")

# Fehler 3: Fehlcode -99 (2) -- Spalte bleibt numerisch, Mittelwert wird still verzerrt
z <- ziehe(2)
setze(z[1], "zufriedenheit", "-99", "Fehlend: -99")
setze(z[2], "schlaf_std",    "-99", "Fehlend: -99")

# Fehler 4: Unplausible Werte (3)
z <- ziehe(3)
setze(z[1], "alter",         "3",   "Unplausibel")
setze(z[2], "alter",         "199", "Unplausibel")
setze(z[3], "zufriedenheit", "6",   "Unplausibel", "Skala geht nur von 1 bis 5")

# Fehler 5: Extremwerte, die möglich sind (2) -- Grenzfälle
z <- ziehe(1, sauber$verkehrsmittel == "Bahn")
setze(z, "wohnort_entfernung_km", "70",  "Extremwert",
      "Entfernung hier ebenfalls auf 70 km gesetzt: 180 Min. Pendelweg ist damit möglich")
setze(z, "pendelweg_min",         "180", "Extremwert",
      "Grenzfall: Fernpendler? Gehört die Person zur Fragestellung?")
z <- ziehe(1)
setze(z, "schlaf_std", "14", "Extremwert", "Grenzfall: möglich, aber sehr ungewöhnlich")

# Fehler 6: Zahl als Text (2)
z <- ziehe(2)
setze(z[1], "pendelweg_min", paste0(roh$pendelweg_min[z[1]], " min"),   "Zahl als Text")
setze(z[2], "semester",      paste0(roh$semester[z[2]], ". Sem."),       "Zahl als Text")

# Fehler 7: Tippfehler und Schreibweisen
# Stufe 1: Schreibweise (5)
setze(ziehe(1, sauber$geschlecht == "weiblich"),        "geschlecht",     "w",           "Schreibweise")
setze(ziehe(1, sauber$geschlecht == "weiblich"),        "geschlecht",     "W",           "Schreibweise")
setze(ziehe(1, sauber$geschlecht == "maennlich"),       "geschlecht",     "m",           "Schreibweise")
setze(ziehe(1, sauber$verkehrsmittel == "Bahn"),        "verkehrsmittel", "bahn",        "Schreibweise")
setze(ziehe(1, sauber$studiengang == "Psychologie"),    "studiengang",    "psychologie", "Schreibweise")
# Stufe 2: Buchstabendreher und Tippfehler (4)
setze(ziehe(1, sauber$studiengang == "Psychologie"),           "studiengang",    "Psycholgie",           "Tippfehler")
setze(ziehe(1, sauber$studiengang == "Psychologie"),           "studiengang",    "Pschologie",           "Tippfehler")
setze(ziehe(1, sauber$verkehrsmittel == "Fahrrad"),            "verkehrsmittel", "Fahrad",               "Tippfehler")
setze(ziehe(1, sauber$studiengang == "Wirtschaftsinformatik"), "studiengang",    "Wirtschaftsinformatk", "Tippfehler")
# Stufe 3: mehrdeutig (1)
setze(ziehe(1, sauber$studiengang == "BWL"), "studiengang", "BW", "Mehrdeutig",
      "Grenzfall: aus den Daten nicht sicher zu erkennen (BWL?), im Zweifel NA")

# Fehler 8: Konsistenzfehler, nur über zwei Spalten erkennbar (Bonus, 2)
z <- ziehe(1, sauber$verkehrsmittel == "Auto")
setze(z, "wohnort_entfernung_km", "80", "Konsistenz (Bonus)")
setze(z, "pendelweg_min",         "5",  "Konsistenz (Bonus)",
      "80 km in 5 Minuten ist nicht möglich")
z <- ziehe(1)
setze(z, "alter",    "19", "Konsistenz (Bonus)")
setze(z, "semester", "12", "Konsistenz (Bonus)",
      "Mit 19 Jahren 12. Semester ist unwahrscheinlich")

# Fehler 9: Dubletten (3) -- aus unveränderten Zeilen
z <- ziehe(3)
kopie_exakt   <- roh[z[1:2], ]
kopie_unscharf <- roh[z[3], ]
kopie_unscharf$pendelweg_min <- as.character(as.numeric(kopie_unscharf$pendelweg_min) + 10)

protokoll <- protokoll |>
  add_row(art = "Dublette (exakt)", spalte = "alle", id = roh$id[z[1]],
          ist = "identische Kopie", soll = "eine Zeile", hinweis = "") |>
  add_row(art = "Dublette (exakt)", spalte = "alle", id = roh$id[z[2]],
          ist = "identische Kopie", soll = "eine Zeile", hinweis = "") |>
  add_row(art = "Dublette (unscharf)", spalte = "pendelweg_min", id = roh$id[z[3]],
          ist = kopie_unscharf$pendelweg_min, soll = roh$pendelweg_min[z[3]],
          hinweis = "Gleiche id, aber abweichender Pendelweg: Welche Zeile gilt? Entscheidung begründen")

# Kopien an zufällige Stellen einsortieren
roh <-
  roh |>
  mutate(.pos = as.numeric(row_number())) |>
  bind_rows(
    bind_rows(kopie_exakt, kopie_unscharf) |>
      mutate(.pos = sample(1:n, 3) + 0.5)
  ) |>
  arrange(.pos) |>
  select(-.pos)


# ------------------------------------------------------------
# 4. Fehler in der Dateistruktur einbauen (auf Textebene)
# ------------------------------------------------------------

# Kaputte Kopfzeile: uneinheitliche Schreibweise, Klammern, Umlaut, Sonderzeichen
kopf <- c("ID", "alter (Jahre)", "Geschlecht", "STUDIENGANG", "Semester",
          "Pendelweg [min]", "verkehrsmittel (häufigstes)", "Zufriedenheit (1-5)",
          "Schlaf in Std.", "Wohnort-Entfernung (km)")
kopf_text <- paste(kopf, collapse = ",")

# Datenzeilen als Text (leere Zelle für NA)
tmp <- tempfile(fileext = ".csv")
write_csv(roh, tmp, na = "", col_names = FALSE)
zeilen <- read_lines(tmp)

# Leere Zeile = nur Kommas (wie bei einem Excel-Export)
leer_text <- strrep(",", length(kopf) - 1)

# Doppelte Kopfzeile nach Datenzeile 60, drei leere Zeilen an zufälligen Stellen
einfuegen <- tibble(
  nach = c(60, sort(sample(c(10:55, 65:110), 3))),
  text = c(kopf_text, rep(leer_text, 3))
) |>
  arrange(desc(nach))   # von hinten einfügen, damit die Positionen stimmen

for (i in seq_len(nrow(einfuegen))) {
  zeilen <- append(zeilen, einfuegen$text[i], after = einfuegen$nach[i])
}

# Notizzeile oben (ohne Komma), Summenzeile unten
notiz <- "Umfrage Studierende WS 2026; Export aus Excel; Stand 12.10.2026"
summe <- c("Summe", sum(sauber$alter), "", "", "", sum(sauber$pendelweg_min),
           "", "", sum(sauber$schlaf_std), "")
zeilen <- c(notiz, kopf_text, zeilen, paste(summe, collapse = ","))

write_lines(zeilen, file.path(ziel, "umfrage_roh.csv"))


# ------------------------------------------------------------
# 5. Fehlerliste (Markdown) aus dem Protokoll erzeugen
# ------------------------------------------------------------

ids <- str_extract(zeilen, "^[^,]*")
zeile_von <- function(id) paste(which(ids == id), collapse = " und ")

struktur <- tibble(
  art    = c("Notizzeile", "Kaputte Kopfzeile", "Doppelte Kopfzeile",
             rep("Leere Zeile", 3), "Summenzeile"),
  spalte = "-",
  id     = "-",
  zeile  = c(1, 2, which(zeilen == kopf_text)[2],
             which(zeilen == leer_text), length(zeilen)),
  ist    = c(notiz, "(siehe Hinweis)", "(Kopfzeile wiederholt)",
             rep("(nur Kommas)", 3), "Summe, ...")
) |>
  mutate(soll = "entfernen / korrigieren", hinweis = "")

struktur$hinweis[2] <- paste("Namen:", paste0("`", kopf, "`", collapse = ", "))

werte <- protokoll |>
  mutate(zeile = map_chr(id, zeile_von))

liste <-
  bind_rows(
    struktur |> mutate(zeile = as.character(zeile)),
    werte
  ) |>
  mutate(nr = row_number())

md_tabelle <- function(d) {
  kopfzeile <- paste0("| ", paste(names(d), collapse = " | "), " |")
  trenner   <- paste0("|", paste(rep("---", ncol(d)), collapse = "|"), "|")
  datenzeilen <- apply(d, 1, \(r) paste0("| ", paste(r, collapse = " | "), " |"))
  c(kopfzeile, trenner, datenzeilen)
}

tab_liste <-
  liste |>
  transmute(Nr = nr, Art = art, Spalte = spalte, ID = id,
            `Zeile in Datei` = zeile,
            `In der Datei` = paste0("`", ist, "`"),
            Soll = if_else(soll %in% c("entfernen / korrigieren", "eine Zeile"),
                           soll, paste0("`", soll, "`")))

# Fälle zählen, nicht Protokollzeilen (ein Fall kann zwei Zellen betreffen)
uebersicht <-
  liste |>
  distinct(art, id, zeile) |>
  count(art, name = "Anzahl") |>
  mutate(art = factor(art, levels = unique(liste$art))) |>
  arrange(art) |>
  rename(Art = art)

anmerkungen <-
  liste |>
  filter(hinweis != "") |>
  transmute(text = paste0("- ", art, ", Nr. ", nr, " (Zeile ", zeile, "): ", hinweis))

md <- c(
  "# Fehlerliste: `umfrage_roh.csv`",
  "",
  "Automatisch erzeugt von `funs/umfrage_simulieren.R` (Seed 2026). Dient als Musterlösung und Korrekturhilfe.",
  "",
  "*Zeile in Datei* ist die Zeilennummer in der Textdatei (Zeile 1 = Notizzeile). ",
  "*Soll* ist der Wert in `umfrage_sauber.csv`. Bei Entscheidungsfällen (Grenzfälle) gibt es keine eindeutig richtige Lösung, entscheidend ist die begründete, dokumentierte Entscheidung.",
  "",
  "## Übersicht",
  "",
  md_tabelle(uebersicht |> mutate(across(everything(), as.character))),
  "",
  "## Alle Probleme",
  "",
  md_tabelle(tab_liste |> mutate(across(everything(), as.character))),
  "",
  "## Anmerkungen und Grenzfälle",
  "",
  anmerkungen$text,
  "",
  "## Hinweise zum Einlesen",
  "",
  "- Ohne `skip = 1` wird die Notizzeile als Kopfzeile gelesen und die Datei hat nur eine Spalte.",
  "- Die doppelte Kopfzeile in den Daten macht beim Einlesen *alle* Spalten zu Text. Es gibt keine Fehlermeldung, erst `glimpse()` verrät es.",
  "- Leere Zeilen aus Kommas werden als Zeilen mit lauter `NA` eingelesen. Völlig leere Zeilen würde `read_csv()` dagegen stillschweigend überspringen.",
  "- `read_csv()` entfernt Leerzeichen am Rand von Werten und Namen automatisch (`trim_ws = TRUE`). Darum gibt es hier keinen Fehler vom Typ `\"BWL \"`.",
  "- `-99` ist ein gültiger Zahlenwert und bleibt unauffällig, solange man nicht `min()` oder `count()` ansieht.",
  "- Komma als Dezimalzeichen wurde bewusst nicht eingebaut: `read_csv()` liest `\"7,5\"` als 75."
)

write_lines(md, file.path(ziel, "umfrage_fehlerliste.md"))

message("Fertig: data/umfrage_sauber.csv, data/umfrage_roh.csv, data/umfrage_fehlerliste.md")
