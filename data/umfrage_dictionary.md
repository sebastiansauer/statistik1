# Data-Dictionary: Umfrage unter Studierenden

Fiktive Umfrage unter Studierenden einer Hochschule (Wintersemester 2026). Eine Zeile ist eine befragte Person. Die Daten sind simuliert und dienen zum Üben der Datenaufbereitung.

Rohdatei: `umfrage_roh.csv` (UTF-8, Komma als Trenner, Punkt als Dezimalzeichen).

## Variablen

| Variable | Name in der Rohdatei | Beschreibung | Einheit / erlaubte Werte |
|---|---|---|---|
| `id` | `ID` | Kennung der Person, eindeutig | `S001` bis `S120` |
| `alter` | `alter (Jahre)` | Alter der Person | Jahre, ganze Zahl |
| `geschlecht` | `Geschlecht` | Geschlecht laut Selbstangabe | `weiblich`, `maennlich`, `divers` |
| `studiengang` | `STUDIENGANG` | Studiengang der Person | `Psychologie`, `BWL`, `Wirtschaftsinformatik`, `Soziale Arbeit` |
| `semester` | `Semester` | Fachsemester | ganze Zahl, ab 1 |
| `pendelweg_min` | `Pendelweg [min]` | Dauer des Wegs von zu Hause zur Hochschule (einfache Strecke) | Minuten, ganze Zahl |
| `verkehrsmittel` | `verkehrsmittel (häufigstes)` | am häufigsten genutztes Verkehrsmittel für diesen Weg | `zu Fuss`, `Fahrrad`, `Bus`, `Bahn`, `Auto` |
| `zufriedenheit` | `Zufriedenheit (1-5)` | Zufriedenheit mit dem Studium | 1 (sehr unzufrieden) bis 5 (sehr zufrieden) |
| `schlaf_std` | `Schlaf in Std.` | durchschnittliche Schlafdauer pro Nacht | Stunden, in Schritten von 0,5 |
| `wohnort_entfernung_km` | `Wohnort-Entfernung (km)` | Entfernung zwischen Wohnort und Hochschule (einfache Strecke) | Kilometer, eine Nachkommastelle |

## Fehlende Angaben

Fehlende Angaben sind in der Rohdatei nicht einheitlich gekennzeichnet:

- leere Zelle
- `k.A.`
- `-99` (Fehlcode in den Spalten `schlaf_std` und `zufriedenheit`)

## Hinweise zur Datei

- Die Datei wurde aus Excel exportiert und von mehreren Personen zusammengeführt.
- Die Spaltennamen in der Rohdatei sind nicht für die Analyse gedacht. Die Variablennamen in der ersten Spalte dieser Tabelle sind die Zielnamen.
