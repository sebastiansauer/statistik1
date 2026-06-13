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
