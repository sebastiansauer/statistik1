# Fehlerliste: `umfrage_roh.csv`

Automatisch erzeugt von `funs/umfrage_simulieren.R` (Seed 2026). Dient als Musterlösung und Korrekturhilfe.

*Zeile in Datei* ist die Zeilennummer in der Textdatei (Zeile 1 = Notizzeile). 
*Soll* ist der Wert in `umfrage_sauber.csv`. Bei Entscheidungsfällen (Grenzfälle) gibt es keine eindeutig richtige Lösung, entscheidend ist die begründete, dokumentierte Entscheidung.

## Übersicht

| Art | Anzahl |
|---|---|
| Notizzeile | 1 |
| Kaputte Kopfzeile | 1 |
| Doppelte Kopfzeile | 1 |
| Leere Zeile | 3 |
| Summenzeile | 1 |
| Fehlend: leere Zelle | 4 |
| Fehlend: k.A. | 2 |
| Fehlend: -99 | 2 |
| Unplausibel | 3 |
| Extremwert | 2 |
| Zahl als Text | 2 |
| Schreibweise | 5 |
| Tippfehler | 4 |
| Mehrdeutig | 1 |
| Konsistenz (Bonus) | 2 |
| Dublette (exakt) | 2 |
| Dublette (unscharf) | 1 |

## Alle Probleme

| Nr | Art | Spalte | ID | Zeile in Datei | In der Datei | Soll |
|---|---|---|---|---|---|---|
| 1 | Notizzeile | - | - | 1 | `Umfrage Studierende WS 2026; Export aus Excel; Stand 12.10.2026` | entfernen / korrigieren |
| 2 | Kaputte Kopfzeile | - | - | 2 | `(siehe Hinweis)` | entfernen / korrigieren |
| 3 | Doppelte Kopfzeile | - | - | 64 | `(Kopfzeile wiederholt)` | entfernen / korrigieren |
| 4 | Leere Zeile | - | - | 47 | `(nur Kommas)` | entfernen / korrigieren |
| 5 | Leere Zeile | - | - | 92 | `(nur Kommas)` | entfernen / korrigieren |
| 6 | Leere Zeile | - | - | 103 | `(nur Kommas)` | entfernen / korrigieren |
| 7 | Summenzeile | - | - | 130 | `Summe, ...` | entfernen / korrigieren |
| 8 | Fehlend: leere Zelle | alter | S029 | 31 | `(leer)` | `25` |
| 9 | Fehlend: leere Zelle | semester | S085 | 91 | `(leer)` | `2` |
| 10 | Fehlend: leere Zelle | pendelweg_min | S034 | 36 | `(leer)` | `23` |
| 11 | Fehlend: leere Zelle | verkehrsmittel | S028 | 30 | `(leer)` | `Bus` |
| 12 | Fehlend: k.A. | wohnort_entfernung_km | S045 | 49 | `k.A.` | `40` |
| 13 | Fehlend: k.A. | wohnort_entfernung_km | S099 | 107 | `k.A.` | `19` |
| 14 | Fehlend: -99 | zufriedenheit | S013 | 15 | `-99` | `4` |
| 15 | Fehlend: -99 | schlaf_std | S023 | 25 | `-99` | `4.5` |
| 16 | Unplausibel | alter | S009 | 11 | `3` | `20` |
| 17 | Unplausibel | alter | S109 | 117 | `199` | `23` |
| 18 | Unplausibel | zufriedenheit | S096 | 104 | `6` | `3` |
| 19 | Extremwert | wohnort_entfernung_km | S068 | 74 | `70` | `7.8` |
| 20 | Extremwert | pendelweg_min | S068 | 74 | `180` | `24` |
| 21 | Extremwert | schlaf_std | S098 | 106 | `14` | `7` |
| 22 | Zahl als Text | pendelweg_min | S047 | 52 | `17 min` | `17` |
| 23 | Zahl als Text | semester | S014 | 16 | `5. Sem.` | `5` |
| 24 | Schreibweise | geschlecht | S105 | 113 | `w` | `weiblich` |
| 25 | Schreibweise | geschlecht | S070 | 76 | `W` | `weiblich` |
| 26 | Schreibweise | geschlecht | S106 | 114 | `m` | `maennlich` |
| 27 | Schreibweise | verkehrsmittel | S005 | 7 | `bahn` | `Bahn` |
| 28 | Schreibweise | studiengang | S060 | 66 | `psychologie` | `Psychologie` |
| 29 | Tippfehler | studiengang | S002 | 4 | `Psycholgie` | `Psychologie` |
| 30 | Tippfehler | studiengang | S119 | 128 | `Pschologie` | `Psychologie` |
| 31 | Tippfehler | verkehrsmittel | S040 | 43 | `Fahrad` | `Fahrrad` |
| 32 | Tippfehler | studiengang | S007 | 9 | `Wirtschaftsinformatk` | `Wirtschaftsinformatik` |
| 33 | Mehrdeutig | studiengang | S021 | 23 | `BW` | `BWL` |
| 34 | Konsistenz (Bonus) | wohnort_entfernung_km | S036 | 39 | `80` | `11.2` |
| 35 | Konsistenz (Bonus) | pendelweg_min | S036 | 39 | `5` | `26` |
| 36 | Konsistenz (Bonus) | alter | S092 | 99 | `19` | `20` |
| 37 | Konsistenz (Bonus) | semester | S092 | 99 | `12` | `3` |
| 38 | Dublette (exakt) | alle | S069 | 50 und 75 | `identische Kopie` | eine Zeile |
| 39 | Dublette (exakt) | alle | S107 | 37 und 115 | `identische Kopie` | eine Zeile |
| 40 | Dublette (unscharf) | pendelweg_min | S112 | 120 und 121 | `19` | `9` |

## Anmerkungen und Grenzfälle

- Kaputte Kopfzeile, Nr. 2 (Zeile 2): Namen: `ID`, `alter (Jahre)`, `Geschlecht`, `STUDIENGANG`, `Semester`, `Pendelweg [min]`, `verkehrsmittel (häufigstes)`, `Zufriedenheit (1-5)`, `Schlaf in Std.`, `Wohnort-Entfernung (km)`
- Unplausibel, Nr. 18 (Zeile 104): Skala geht nur von 1 bis 5
- Extremwert, Nr. 19 (Zeile 74): Entfernung hier ebenfalls auf 70 km gesetzt: 180 Min. Pendelweg ist damit möglich
- Extremwert, Nr. 20 (Zeile 74): Grenzfall: Fernpendler? Gehört die Person zur Fragestellung?
- Extremwert, Nr. 21 (Zeile 106): Grenzfall: möglich, aber sehr ungewöhnlich
- Mehrdeutig, Nr. 33 (Zeile 23): Grenzfall: aus den Daten nicht sicher zu erkennen (BWL?), im Zweifel NA
- Konsistenz (Bonus), Nr. 35 (Zeile 39): 80 km in 5 Minuten ist nicht möglich
- Konsistenz (Bonus), Nr. 37 (Zeile 99): Mit 19 Jahren 12. Semester ist unwahrscheinlich
- Dublette (unscharf), Nr. 40 (Zeile 120 und 121): Gleiche id, aber abweichender Pendelweg: Welche Zeile gilt? Entscheidung begründen

## Hinweise zum Einlesen

- Ohne `skip = 1` wird die Notizzeile als Kopfzeile gelesen und die Datei hat nur eine Spalte.
- Die doppelte Kopfzeile in den Daten macht beim Einlesen *alle* Spalten zu Text. Es gibt keine Fehlermeldung, erst `glimpse()` verrät es.
- Leere Zeilen aus Kommas werden als Zeilen mit lauter `NA` eingelesen. Völlig leere Zeilen würde `read_csv()` dagegen stillschweigend überspringen.
- `read_csv()` entfernt Leerzeichen am Rand von Werten und Namen automatisch (`trim_ws = TRUE`). Darum gibt es hier keinen Fehler vom Typ `"BWL "`.
- `-99` ist ein gültiger Zahlenwert und bleibt unauffällig, solange man nicht `min()` oder `count()` ansieht.
- Komma als Dezimalzeichen wurde bewusst nicht eingebaut: `read_csv()` liest `"7,5"` als 75.
