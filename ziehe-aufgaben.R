library(dplyr)

set.seed(42) # für Reproduzierbarkeit; entfernen für echte Zufallsziehung

n_gesamt <- 25

df <- read.csv("quiz-aufgaben.csv")

# Regressionskapitel ausschließen
df_pool <- df |>
  filter(!grepl("regression", qmd_datei, ignore.case = TRUE))

# Proportionale Schichtung: n pro Kapitel relativ zur Kapitelgröße
kapitel_groesse <- df_pool |>
  count(qmd_datei) |>
  mutate(
    anteil = n / sum(n),
    n_ziehen = round(anteil * n_gesamt)
  )

# Rundungsfehler korrigieren: fehlende Aufgaben dem größten Kapitel zuschlagen
diff <- n_gesamt - sum(kapitel_groesse$n_ziehen)
if (diff != 0) {
  idx <- which.max(kapitel_groelle$n) # größtes Kapitel
  idx <- which.max(kapitel_groesse$n)
  kapitel_groesse$n_ziehen[idx] <- kapitel_groesse$n_ziehen[idx] + diff
}

# Stratifizierte Ziehung
auswahl <- kapitel_groesse |>
  left_join(df_pool, by = "qmd_datei") |>
  group_by(qmd_datei) |>
  group_map(~ slice_sample(.x, n = unique(.x$n_ziehen)), .keep = TRUE) |>
  bind_rows() |>
  select(aufgabe, qmd_datei) |>
  arrange(qmd_datei)

cat("Gezogene Aufgaben (n =", nrow(auswahl), "):\n\n")
print(auswahl, n = Inf)

cat("\nAufgaben pro Kapitel:\n")
print(count(auswahl, qmd_datei))


write.csv(auswahl, "exrs_zufallsauswahl.csv")
