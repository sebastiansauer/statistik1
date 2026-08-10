#!/bin/bash
# Rendert das Buch und die RevealJS-Foliendecks und veröffentlicht beides
# gemeinsam auf GitHub Pages (Branch gh-pages).
#
# Ablauf:
#   1. Buch rendern (quarto render) -> _book/ (Default-output-dir dieses Projekts)
#   2. Foliendecks (slides/*.html, slides/*_files, slides/slides.css) nach
#      _book/slides/ spiegeln (nur die fertigen Ausgaben, keine Quelltexte)
#   3. _book/ 1:1 auf gh-pages veröffentlichen, ohne erneut zu rendern
#      (--no-render), da Schritt 1+2 den Stand bereits hergestellt haben.
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

echo "==> Buch rendern..."
quarto render

echo "==> Foliendecks nach _book/slides/ spiegeln..."
mkdir -p _book/slides
# Allowlist statt Ausschlussliste: nur die fertigen RevealJS-Ausgaben
# (*.html, *_files/, slides.css) werden gespiegelt. Das ist bewusst robust
# gegen alles andere, was in slides/ (z.B. Hilfsskripte, Tool-Ordner mit
# node_modules, PDFs, Quelltexte) liegen könnte, auch wenn es dort noch
# nicht existiert(e) -- so landet so etwas nie versehentlich auf gh-pages.
rsync -a --delete --delete-excluded \
  --include='/*.html' \
  --include='/*_files/' \
  --include='/*_files/**' \
  --include='/slides.css' \
  --exclude='*' \
  slides/ _book/slides/

echo "==> Veröffentlichen auf gh-pages..."
quarto publish gh-pages --no-render --no-prompt

echo "==> Fertig: https://sebastiansauer.github.io/statistik1/"
