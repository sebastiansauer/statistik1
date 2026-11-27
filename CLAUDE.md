# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A German-language introductory statistics textbook (Quarto Book) titled "Statistik1 – Einführung in die Prognose-Modellierung" by Sebastian Sauer. It is written in German and uses R/knitr for all code execution. The book is published online (CC-BY-NC-ND-4.0) and as a printed edition.

## Building the book

```bash
# Render HTML only (most common during development)
quarto render --to html

# Render all formats (HTML + PDF via LuaHBTeX)
Rscript render-book.R

# Render a single chapter
quarto render 010-rahmen.qmd --to html
```

**Troubleshooting**: If rendering fails with a cryptic error, delete all `*_cache/` directories — stale cache is the most common cause.

## Project structure

- `NNN-<name>.qmd` — numbered book chapters (005–130); the order in `_quarto.yml` is canonical
- `_common.R` — sourced at the top of every chapter; sets knitr options, ggplot theme (`see::theme_modern()`), color palette constants, and loads the `mariokart` dataset
- `exs/` — individual exercise files in R/exams `.Rmd` format (one exercise per file); referenced from chapters via `exams2forms`
- `children/` — reusable `.qmd` snippets included with `{{< include children/... >}}`
- `funs/` — standalone R helper scripts (not auto-sourced; run manually as needed)
- `data/` — CSV/XLSX datasets used in chapters (`mariokart.csv`, `mtcars.csv`, etc.)
- `specifics/` — bibliography (`bib-local.bib`), CSL style (`apa7.csl`), LaTeX style files
- `R-code-for-all-chapters/` — R scripts auto-extracted from chapters via `funs/write-r-code-for-all-chapters-to-filesl.R`
- `_freeze/` — frozen execution results; committed to git so CI doesn't need R

## Exercise / quiz system

Exercises are stored as R/exams `.Rmd` files in `exs/`. They are embedded in chapters using the `exams2forms` package. The file `quiz-aufgaben.csv` lists all exercises with their chapter assignments. `ziehe-aufgaben.R` performs stratified random sampling from that list (excluding regression chapters) to draw exam question sets.

## Key configuration

- `execute: freeze: auto` in `_quarto.yml` — code only re-executes when source changes; delete cache/freeze to force re-render
- `_common.R` must be `source()`d in each chapter that uses ggplot or the shared dataset
- Language is `de-DE` throughout; all prose, comments, and variable names are in German
- `renv` is used for R package management — run `renv::restore()` to install dependencies

## Text conventions

- Decimal separator is a **point** everywhere (prose, math, quiz files in `exs/`, inline R output): `0.5`, `$\alpha = 0.05$`. Always write the leading zero (`0.5`, not `.5`). Thousands in prose may use a point (`20.000`).
- Density plots: y title `"Wahrscheinlichkeitsdichte"` (not "Dichte", "density", "Anteil (Dichte)").
- Chunk options only as `#|` pipe comments; the chunk header holds at most the engine (`{r}`), no label or other options (duplicates trigger knitr warnings and the pipe value wins anyway).
- Sources (data, figure and content origins) are cited from `specifics/bib-local.bib` (`[@key]`, `Bildquelle: @key.`), not as raw URLs in footnotes. Navigational links (downloads, exercise pages, apps) stay as `[Text](url)^[<url>]` so they remain usable in print.

## Diagram style

Design decisions live centrally in `_common.R` (loaded via `.Rprofile`); don't hard-code colours, themes or grid overrides in individual plots — use the named constants (`grau_dunkel`/`dunkelgrau`, `grau_mittel`/`mittelgrau`, `okabe_linie`, `trendcol`, …) and helpers. Read the global skill `ggplot-diagramme` before writing plot code; the automation is the same as in the Start:Bayes repo (`references/start-bayes.md` in that skill). `_common.R` hooks into every `ggplot_build()`:

- `y_label_nach_oben()` — y title moved above the panel (skipped for `coord_flip()` and for plots with `labs(y = NULL, subtitle = …)`).
- `wilke_gitter()` — grid only along the value axis (skipped if the plot sets `panel.grid*` itself, e.g. via `theme_med(grid = …)` or `theme_streu()`).
- `tufte_streu()` — range frame, rug and ticks in the data range for scatter/line plots with ≥ 10 rows (skipped if the plot already has `rangeframe()`/`geom_rug()`, for `coord_flip()`, heatmaps, DAGs).
- `tufte_alpha()` — translucent points against overplotting (explicit `alpha` wins).

Switches: `+ tufte_aus()` (computed curves drawn with `geom_line`, e.g. a function of r), `options(tufte_streu = FALSE)`, `options(tufte_linie = FALSE)`, `options(tufte_alpha = FALSE)`, `options(wilke_gitter = FALSE)`, `options(y_label_oben = FALSE)`. Also set centrally: Okabe-Ito as default discrete palette (no yellow), grey continuous fill scale, bars/histograms with white border (use `geom_bar(color = NA)` for very thin bars), ggpubr functions use the book theme. Building blocks (use instead of hand-written styling, each takes `...` for exceptions): `referenzlinie(xintercept = / yintercept = / intercept =, slope =)` and `referenz_text()` for dashed grey reference lines, `ohne_gitter()`, `gitter_nur("y"/"x")`, `ohne_y_achse()`, `tufte_rahmen(data, aes(x, y))`, `achsentext_gross()`, `theme_leer()` instead of `theme_void()`/`theme_minimal()` (never `theme_set()` in a chapter), `theme_balken()`, `geom_balken()`, `balken_textfarbe()`, `scale_fill_gruppen()`. Grouped plots get no legend: colour AND shape per group, labels at the lines, key via `gruppen_schluessel(namen, farben, formen)` — in `labs(y = …)` it renders automatically, in `labs(y = NULL, subtitle = …)` add `theme(plot.subtitle = ggtext::element_markdown())`; `textfarbe()` gives the readable text colour. Side-by-side figures: with `layout-ncol >= 2` the figure is computed at 2/3 width automatically (`#| teilbild: false` to switch off, `#| teilbild: true` to force for `layout: [[…]]`); don't enlarge fonts by hand. Project specifics for the skill: `references/statistik1.md`. Layout CSS (sub-figure gap, Mermaid width, centred videos) lives in `specifics/layout.css`; `specifics/styles.css` is currently disabled. Figure chunks get a hash of `_common.R`, `funs/*.R`, `children/*.R` in `cache.extra`, so editing those redraws all figures; `render-book.R` also wipes `_freeze/` when that hash changes.
