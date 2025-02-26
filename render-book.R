Sys.setenv(QUARTO_CHROMIUM_HEADLESS_MODE = "new")
system("quarto render --to pdf")
system("quarto render --to html")
system("quarto render --to titlepage-pdf")
