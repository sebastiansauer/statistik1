#!/bin/bash
# Rendert alle RevealJS-Foliendecks in slides/ und exportiert sie zusätzlich als PDF (via decktape).
#
# Einmalige Vorbereitung:
#   cd slides/tools && npm install
#
# Aufruf (aus dem Projekt-Root oder aus slides/):
#   ./slides/make-pdfs.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

DECKTAPE_JS="$SCRIPT_DIR/tools/node_modules/decktape/decktape.js"
if [ ! -f "$DECKTAPE_JS" ]; then
  echo "decktape nicht gefunden. Bitte zuerst installieren: (cd slides/tools && npm install)" >&2
  exit 1
fi

CHROME_PATH="$(command -v google-chrome || command -v google-chrome-stable || command -v chromium || command -v chromium-browser || true)"
if [ -z "$CHROME_PATH" ]; then
  echo "Kein Chrome/Chromium gefunden. Bitte installieren oder CHROME_PATH-Variable setzen." >&2
  exit 1
fi

for deck in *.qmd; do
  slug="${deck%.qmd}"
  echo "=== $slug ==="
  quarto render "$deck"
  node "$DECKTAPE_JS" reveal --chrome-path "$CHROME_PATH" "$slug.html" "$slug.pdf"
done

echo "Fertig. PDFs liegen neben den .qmd-Dateien in slides/."
