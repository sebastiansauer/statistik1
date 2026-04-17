# Probeklausur


```{r}
#| include: false

library(exams2forms)
source("_common.R")
```


Siehe diese [Prüfungshinweise](https://hinweisbuch.netlify.app/030-hinweise-pruefung-klausur-frame) und alle weiteren Hinweise.





```{r def-exs-probeklausur}
#| echo: false
exrs_probe <- 
list(
   "Aufgaben_Statistik.Rmd",
   "Skalenniveau_Intervall.Rmd",
   "Skalenniveau_Ordinal.Rmd",
   "variation01.Rmd",

   # vis:
 "Achsen_Trick.Rmd",
  "Praxis_Datenjudo.Rmd",
  "Okabe_Ito.Rmd",
  "Torten_Kritik.Rmd",
  "Schein_Korr.Rmd",
  "Balken_Normierung.Rmd",
  "Bosplot_Schiefe.Rmd",
  "Scatter_Ellipse.Rmd",
  "Normal_Rechnen.Rmd",
  "Plot_Wahl.Rmd",
  "Anscombe_Logik.Rmd",
# zusammenfassen
  "exs/File_Drawer_Problem.Rmd",
  "exs/Definition_Punktmodell.Rmd",
  "exs/Median_Gerade_N.Rmd",
  "exs/Gruppen_Modell_Vorteil.Rmd",
  "exs/Quantil_Transfer.Rmd",
  "exs/Modell_Gleichung.Rmd",
  "exs/Schiefe_Interpolation.Rmd",
  "exs/Nullmodell_R.Rmd",
  "exs/MW_Eigenschaft.Rmd",
  "exs/Normal_Rechnen.Rmd",
  # modellgüte:

 )
```

```{r quiz-probe, echo = FALSE, message = FALSE, results = "asis"}
exams2forms(exrs_probe, box = TRUE, check = TRUE, edir = "exs", sdir = "exs")
```



