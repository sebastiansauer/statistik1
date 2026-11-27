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

# Decks mit webR-Zellen (quarto-live) laden über file:// nicht fertig;
# decktape liest die Folien daher über einen lokalen HTTP-Server (Projekt-Root,
# damit ../data, ../img usw. erreichbar sind). Im PDF erscheinen die Übungen
# als Aufgabe mit Code-Gerüst (ohne Ausführung).
PORT="${SLIDES_PORT:-8799}"
python3 -m http.server "$PORT" --bind 127.0.0.1 --directory "$SCRIPT_DIR/.." >/dev/null 2>&1 &
SERVER_PID=$!
trap 'kill "$SERVER_PID" 2>/dev/null || true' EXIT
sleep 1

for deck in *.qmd; do
  slug="${deck%.qmd}"
  echo "=== $slug ==="
  quarto render "$deck"
  node "$DECKTAPE_JS" reveal --chrome-path "$CHROME_PATH" \
    "http://127.0.0.1:$PORT/slides/$slug.html" "$slug.pdf"
done

echo "Fertig. PDFs liegen neben den .qmd-Dateien in slides/."
