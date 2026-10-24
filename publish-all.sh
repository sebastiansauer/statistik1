#!/bin/bash
# Rendert das Buch und die RevealJS-Foliendecks und veröffentlicht beides
# gemeinsam auf GitHub Pages (Branch gh-pages).
#
# Ablauf:
#   1. Buch rendern (quarto render) -> _book/ (Default-output-dir dieses Projekts)
#   2. Foliendecks neu rendern: alle Decks als HTML und als PDF (decktape,
#      via slides/make-pdfs.sh). So können keine veralteten Folien online
#      gehen, nur weil make-pdfs.sh vorher nicht von Hand gelaufen ist.
#   3. Foliendecks (slides/*.html, *.pdf, *_files, slides/slides.css) nach
#      _book/slides/ spiegeln (nur die fertigen Ausgaben, keine Quelltexte)
#   4. _book/ 1:1 auf gh-pages veröffentlichen, ohne erneut zu rendern
#      (--no-render), da Schritt 1-3 den Stand bereits hergestellt haben.
#
# Option --skip-slide-pdfs: Schritt 2 nur als HTML, ohne PDF-Export (spart
# einige Minuten, wenn sich an den Folien nichts geändert hat; die
# vorhandenen slides/*.pdf werden dann unverändert veröffentlicht).
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

skip_slide_pdfs=false
[[ "${1:-}" == "--skip-slide-pdfs" ]] && skip_slide_pdfs=true

# --- Fortschrittsanzeige ---------------------------------------------------
# Jeder Schritt meldet sich als "[n/N] Text" mit der bisher verstrichenen
# Zeit; am Ende (oder bei Abbruch) die Gesamtdauer und ggf. der Schritt, in
# dem es schiefging. Farbig nur, wenn die Ausgabe ein Terminal ist.
TOTAL_STEPS=4
current_step=0
current_label="Start"
start_time=$(date +%s)
if [[ -t 1 ]]; then c_on=$'\e[1;34m'; c_ok=$'\e[1;32m'; c_err=$'\e[1;31m'; c_off=$'\e[0m'
else c_on=""; c_ok=""; c_err=""; c_off=""; fi

elapsed() {
  local s=$(( $(date +%s) - start_time ))
  printf '%dm%02ds' $((s / 60)) $((s % 60))
}

step() {
  current_step=$((current_step + 1))
  current_label="$1"
  printf '\n%s==> [%d/%d] %s%s  (bisher %s)\n' \
    "$c_on" "$current_step" "$TOTAL_STEPS" "$current_label" "$c_off" "$(elapsed)"
}

on_exit() {
  local rc=$?
  if [[ $rc -eq 0 ]]; then
    printf '\n%s==> Fertig nach %s: https://sebastiansauer.github.io/statistik1/%s\n' \
      "$c_ok" "$(elapsed)" "$c_off"
  else
    printf '\n%s==> ABGEBROCHEN in Schritt %d/%d (%s) nach %s, Exit-Code %d%s\n' \
      "$c_err" "$current_step" "$TOTAL_STEPS" "$current_label" "$(elapsed)" "$rc" "$c_off" >&2
  fi
}
trap on_exit EXIT

step "Buch rendern"
quarto render

if $skip_slide_pdfs; then
  step "Folien: Decks als HTML rendern (PDF-Export übersprungen)"
  (cd slides && for deck in *.qmd; do quarto render "$deck"; done)
else
  step "Folien: Decks als HTML rendern und als PDF exportieren"
  slides/make-pdfs.sh
fi

step "Foliendecks nach _book/slides/ spiegeln"
mkdir -p _book/slides
# Allowlist statt Ausschlussliste: nur die fertigen Ausgaben
# (*.html, *.pdf, *_files/, slides.css) werden gespiegelt. Das ist bewusst
# robust gegen alles andere, was in slides/ (z.B. Hilfsskripte, Tool-Ordner
# mit node_modules, Quelltexte) liegen könnte, auch wenn es dort noch nicht
# existiert(e) -- so landet so etwas nie versehentlich auf gh-pages.
rsync -a --delete --delete-excluded \
  --include='/*.html' \
  --include='/*.pdf' \
  --include='/*_files/' \
  --include='/*_files/**' \
  --include='/slides.css' \
  --exclude='*' \
  slides/ _book/slides/

step "Veröffentlichen auf gh-pages"
quarto publish gh-pages --no-render --no-prompt
