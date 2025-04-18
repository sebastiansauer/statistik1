set.seed(42)  # For reproducibility





my_grid <- expand_grid(x1 = seq(-3, 3, by = 0.10), 
                       x2 = seq(-3, 3, by = 0.10))


my_grid2 <- 
  my_grid %>% 
  mutate(lm3d = predict(lm3d, newdata = data.frame(x1, x2)))


grid_wide <- 
  my_grid2 %>% 
  pivot_wider(names_from = x2, values_from = lm3d) %>% 
  select(-1) %>%  # kick the name's column out
  as.matrix()


scatterplot_3d <- plot_ly(df_3d,
                          x = ~ x1,
                          y = ~ x2,
                          z = ~ y,
                          type = "scatter3d")



scatterplot_3d_with_trace <- 
  add_trace(p = scatterplot_3d,
            z = grid_wide,
            x = seq(-3, 3, by = .10),
            y = seq(-3, 3, by = .10),
            type = "surface")

