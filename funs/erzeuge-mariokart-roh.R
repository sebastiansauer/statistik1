# Erzeugt den "verschmutzten" Übungsdatensatz data/mariokart_roh.csv
# für Kapitel 030 (Daten aufbereiten).
#
# Ausgangspunkt ist data/mariokart.csv. Eingebaut werden bewusst typische
# Probleme von Rohdaten:
#   - Dubletten (3 doppelt erfasste Auktionen)
#   - fehlende Werte (in total_pr, ship_pr und seller_rate)
#   - ein unplausibler Wert (Tippfehler: duration = 70 statt 7 Tage)
#   - uneinheitliche Kodierung in cond ("New", "USED", "gebraucht")
# Die beiden echten Extremwerte im Preis (327 und 118 Dollar) sind
# bereits im Original enthalten und bleiben unverändert.
#
# Aufruf (aus dem Projektordner):  Rscript funs/erzeuge-mariokart-roh.R

set.seed(42)

mariokart <- read.csv("data/mariokart.csv")
mariokart$V1 <- NULL
mariokart$title <- NULL

roh <- mariokart

# Fehlende Werte
# (die beiden Extremwerte im Preis sollen erhalten bleiben)
roh$total_pr[sample(which(roh$total_pr < 100), 2)] <- NA
roh$ship_pr[sample(nrow(roh), 3)] <- NA
roh$seller_rate[sample(nrow(roh), 4)] <- NA

# Unplausibler Wert: Auktionsdauer bei eBay maximal 10 Tage
idx_dauer <- which(roh$duration == 7)[3]
roh$duration[idx_dauer] <- 70

# Uneinheitliche Kodierung
idx_new <- which(roh$cond == "new")
idx_used <- which(roh$cond == "used")
roh$cond[idx_new[5]] <- "New"
roh$cond[idx_used[c(4, 9)]] <- c("USED", "gebraucht")

# Dubletten: drei Auktionen wurden doppelt erfasst
dubletten <- roh[c(12, 57, 101), ]
roh <- rbind(roh, dubletten)

# Zeilen mischen, damit die Dubletten nicht am Ende kleben
roh <- roh[sample(nrow(roh)), ]

write.csv(roh, "data/mariokart_roh.csv", row.names = FALSE)

message("data/mariokart_roh.csv geschrieben: ", nrow(roh), " Zeilen")
