Sys.setenv(QUARTO_CHROMIUM_HEADLESS_MODE = "new")

# Freeze-Schutz: Bei "freeze: auto" fuehrt Quarto ein Kapitel nur aus, wenn
# sich dessen .qmd geaendert hat. Aenderungen an _common.R, funs/*.R oder
# children/*.R kaemen sonst nie in den Abbildungen an. Hat sich der Hash
# dieser Dateien seit dem letzten Lauf geaendert, _freeze/ verwerfen (teure
# Modell-Chunks kommen weiter aus dem knitr-Cache).
if (!exists("helper_files_hash")) source("_common.R")
freeze_stamp <- "_freeze/.helper-files-hash"
old_hash <- if (file.exists(freeze_stamp)) readLines(freeze_stamp) else ""
if (!identical(old_hash, helper_files_hash)) {
  message("Hilfsdateien geaendert -> _freeze/ wird verworfen, alle Kapitel werden ausgefuehrt.")
  unlink("_freeze", recursive = TRUE)
}
system("quarto render --to pdf")
status_html <- system("quarto render --to html")
system("quarto render --to titlepage-pdf")

# Hash erst nach erfolgreichem HTML-Render festhalten
if (status_html == 0 && dir.exists("_freeze")) writeLines(helper_files_hash, freeze_stamp)
