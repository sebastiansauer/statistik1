#QM1 SoSe 23



# Setup -------------------------------------------------------------------




library(dplyr)

library(exams)
library(teachertools)
#options(digits = 2)


#Sys.setenv(R_CONFIG_ACTIVE = "dev")  # for testing
Sys.setenv(R_CONFIG_ACTIVE = "default")  # for production
#config <- config::get()
#config

# Maschine 1 (Macbook)
ex_dir <- "/Users/sebastiansaueruser/github-repos/rexams-exercises/exercises"

path_exams_rendered <- "/Users/sebastiansaueruser/Google Drive/Lehre/Lehre_AKTUELL/2023-SoSe/QM1/Aufgaben/exs-rendered"

path_datenwerk <- "/Users/sebastiansaueruser/github-repos/datenwerk/posts"






#  Thema 1: Rahmen  ---------------------------------------------------------

ex_fragen_stellen <-
  c("variation01.Rmd", 
    "Def-Statistik01.Rmd",
    "variation02.Rmd",   # Prüfungstauglich
    "Ziele-Statistik.Rmd",
    "tidy1.Rmd",
    "Skalenniveau1a.Rmd",
    "Skalenniveau1b.Rmd",  # Prüfungstauglich
    "Kausale-Verben.Rmd"  # Prüfungstauglich
    )

# datenwerk:
teachertools::render_exs(ex_fragen_stellen,
                         my_edir = ex_dir,
                         output_path = path_datenwerk,
                         render_html = FALSE,
                         render_moodle = FALSE,
                         render_moodle = FALSE,
                         render_pdf_print = FALSE,
                         render_markdown = FALSE,
                         render_yamlrmd = TRUE,
                         thema_nr = "1")



ex_self_check <-
  c("variation02.Rmd",  # Prüfungstauglich
   
    "N-col-mariokart.Rmd",
    "Beobachtungseinheit.Rmd",
    "Messniveau.Rmd",
    "Skalenniveau1b.Rmd",  # Prüfungstauglich
    "Kausale-Verben.Rmd"  # Prüfungstauglich
  )

# Moodle:
teachertools::render_exs("Kausale-Verben.Rmd",
           my_edir = ex_dir,
           output_path = path_exams_rendered,
           render_html = FALSE,
           render_moodle = TRUE,
           render_pdf_print = FALSE,
           render_markdown = FALSE,
           render_yamlrmd = FALSE,
           thema_nr = "1")




# Thema 2: R --------------------------------------------------------------




ex_r <- c(
  "Typ-Fehler-R-07.Rmd",
  "Pfad.Rmd",  # Prüfung
  "Wertpruefen.Rmd",
  "Typ-Fehler-R-04.Rmd",
  "Typ-Fehler-R-03.Rmd",
  "Typ-Fehler-R-06a.Rmd",
  "Typ-Fehler-R-01.Rmd",
  "Typ-Fehler-R-02.Rmd",
  "Wertzuweisen_mc.Rmd",
  "there-is-no-package.Rmd",  # Prüfung
  "Wertberechnen.Rmd",  # Prüfung
  "Wertberechnen2.Rmd",  # Prüfung
  "Wertzuweisen.Rmd",  # Prüfung
  "argumente.Rmd",  # Prüfung
  "import-mtcars.Rmd", 
  "Logikpruefung1.Rmd",
  "Logikpruefung2.Rmd"
)


# datenwerk:
teachertools::render_exs(ex_r,
                         my_edir = ex_dir,
                         output_path = path_datenwerk,
                         render_html = FALSE,
                         render_moodle = FALSE,
                         render_pdf_print = FALSE,
                         render_markdown = FALSE,
                         render_yamlrmd = TRUE,
                         thema_nr = "_R")




# Thema 3: Datenjudo ------------------------------------------------------


exs_datenjudo <-
  c(
    "tidydata1.Rmd",
    "affairs-dplyr.Rmd",
    "dplyr-uebersetzen.Rmd",
    "mariokart-mean1.Rmd",
    "mariokart-mean2.Rmd",
    "mariokart-mean3.Rmd",  
    "mariokart-max1.Rmd",
    "haeufigkeit01.Rmd",
    "wrangle5.Rmd",    
    "wrangle7.Rmd",  
    "wrangle9.Rmd",  # nur als Vertiefung
    "wrangle10.Rmd",
    "summarise01.Rmd",
    "summarise02.Rmd",
    "summarise02.Rmd",
    "filter01.Rmd",
    "mutate01.Rmd"
    )



exs_datenjudo_pruef <-
  c("MWberechnen.Rmd",
    "mariokart-mean4.Rmd",  # Prüfung
    "mariokart-max2.Rmd",  # Prüfung
    "wrangle1.Rmd",
    "wrangle3.Rmd",
    "wrangle4.Rmd"
  )


# datenwerk:
teachertools::render_exs(c(exs_datenjudo, exs_datenjudo_pruef),
                         my_edir = ex_dir,
                         output_path = path_datenwerk,
                         render_html = FALSE,
                         render_moodle = FALSE,
                         render_pdf_print = FALSE,
                         render_markdown = FALSE,
                         render_yamlrmd = TRUE,
                         thema_nr = "_R")





# Thema 4: Vis ------------------------------------------------------------

exs_vis <-
  c(
  
   
    "Diamonds-Histogramm-Vergleich2.Rmd", # prüf
    "Histogramm-in-Boxplot.Rmd",  # prüf
  
    "Ridges-vergleichen.Rmd",
 
  
    "max-corr1.Rmd", #prüf
    "max-corr2.Rmd",  #prf
 
    "boxhist.Rmd",
    "Boxplot-Aussagen.Rmd",
    "boxplots-de1a.Rmd",
    "movies-vis1.Rmd",
    "movies-vis2.Rmd"
    
  )


# datenwerk:
teachertools::render_exs(exs_vis,
                         my_edir = ex_dir,
                         output_path = path_datenwerk,
                         render_html = FALSE,
                         render_moodle = FALSE,
                         render_pdf_print = FALSE,
                         render_markdown = FALSE,
                         render_yamlrmd = TRUE,
                         thema_nr = "_vis")



exs_vis_pruef <- 
  c(
    "diamonds-histogram.Rmd",  # prüf
    "Diamonds-Histogramm-Vergleich.Rmd", # prüf
    "Streudiagramm.Rmd",  #prüf
     "n-vars-diagram.Rmd",  # prüf
    "wozu-streudiagramm.Rmd",  #prüf
    "wozu-balkendiagramm.Rmd",  #pür+f
    "min-corr1.Rmd", #prf
  
    
  )




# punktmodelle1 -----------------------------------------------------------


exs_punktmodelle1 <-
  c(
    "Kennwert-robust.Rmd",
    "Schiefe1.Rmd",
    "Schiefe-erkennen.Rmd",
    "nasa01.Rmd",
    "nasa02.Rmd",
    "summarise01.Rmd",
    "summarise02.Rmd",
    "summarise03.Rmd",  
    "mariokart-max1.Rmd",
    "mariokart-max2.Rmd",
    "mw-berechnen.Rmd",
    "mariokart-mean1.Rmd",
    "mariokart-mean2.Rmd",
    "mariokart-mean3.Rmd",   
    "mariokart-mean4.Rmd", 
    "wrangle10.Rmd"
  )

# datenwerk:
teachertools::render_exs(exs_punktmodelle1,
                         my_edir = ex_dir,
                         output_path = path_datenwerk,
                         render_html = FALSE,
                         render_moodle = FALSE,
                         render_pdf_print = FALSE,
                         render_markdown = FALSE,
                         render_yamlrmd = TRUE,
                         thema_nr = "_vis")




# Modellguete -------------------------------------------------------------


ex_modellguete <-
  c("sd-vergleich.Rmd",
    "summarise04.Rmd",
    "summarise05.Rmd",   
    "summarise06.Rmd",   
    "vis-mariokart-variab.Rmd",
    "mariokart-desk01.Rmd",
    "sd-vergleich.Rmd",
    "Streuung-Histogramm.Rmd",
    "nasa01.Rmd",
    "Kennwert-robust2.Rmd",
    "Kennwert-robust.Rmd",
    "mariokart-sd1.Rmd",
    "mariokart-sd2.Rmd",
    "mariokart-sd3.Rmd"
    )


# datenwerk:
teachertools::render_exs(ex_modellguete,
                         my_edir = ex_dir,
                         output_path = path_datenwerk,
                         render_html = FALSE,
                         render_moodle = FALSE,
                         render_pdf_print = FALSE,
                         render_markdown = FALSE,
                         render_yamlrmd = TRUE,
                         thema_nr = "_vis")

