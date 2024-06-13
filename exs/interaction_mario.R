# AUFGABE
# Variieren Sie das folgende Modell mit einer bzw. beiden UV bzw. mit Interaktionseffekt
# Welches Modell ist am besten?


library(easystats)

# Modell a
lm_mario_2uv <- lm(total_pr ~ start_pr + ship_pr, data = mariokart %>% filter(total_pr < 100))

r2(lm_mario_2uv)


# Modell b
lm_mario_start_pr <- lm(total_pr ~ start_pr, data = mariokart %>% filter(total_pr < 100))

r2(lm_mario_start_pr)


# Modell c
lm_mario_ship_pr <- lm(total_pr ~  ship_pr, data = mariokart %>% filter(total_pr < 100))

r2(lm_mario_ship_pr)

# Modell d
lm_mario_2uv_interaktion <- lm(total_pr ~ start_pr + ship_pr + start_pr:ship_pr, data = mariokart %>% filter(total_pr < 100))

r2(lm_mario_2uv_interaktion)



# BONUS
# Visualisieren Sie das Streudiagramm


library(DataExplorer)

mariokart |> 
  select(total_pr, ship_pr) |> 
  filter(total_pr < 100) |> 
  plot_scatterplot( "total_pr")


library(ggpubr)

ggscatter(mariokart |> filter(total_pr < 100),
          x = "ship_pr",
          y = "total_pr",
          add = "reg.line")
