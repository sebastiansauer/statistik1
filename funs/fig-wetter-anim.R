library(gganimate)




# Temperatur --------------------------------------------------------------



wetter1 <- 
wetter %>%
  select(year, temp) %>%
  mutate(decade_year = year %% 10,
         decade = (year %/% 10) * 10) %>%
  group_by(decade) %>%
  summarise(temp = mean(temp, na.rm = TRUE)) %>%
  ggplot(aes(x = decade, y = temp,
             frame = decade)) +
  geom_line() +
  geom_point() +
  scale_color_viridis_c() +
  transition_reveal(decade) +
  theme_minimal()


anim1 <- animate(plot = wetter1, width = 800, height = 500, units = 'px', renderer = gifski_renderer())
anim_save(filename = "img/wetter1.gif", animation = anim1)



# Niederschlag ------------------------------------------------------------


wetter_precip <- 
wetter %>%
  select(year, precip) %>%
  mutate(decade_year = year %% 10,
         decade = (year %/% 10) * 10) %>%
  group_by(decade) %>%
  summarise(precip = mean(precip, na.rm = TRUE)) %>%
  ggplot(aes(x = decade, y = precip,
             frame = decade)) +
  geom_line() +
  geom_point() +
  scale_color_viridis_c() +
  transition_reveal(decade) +
  theme_minimal()



# wetter3 <-
# wetter %>%
#   ggplot(aes(x = temp, y = precip, color = month,
#              frame = year)) +
#   geom_point() +
#   scale_color_viridis_c() +
#   transition_time(year) +
#   labs(title = "Year: {frame_time}")



anim_precip <- animate(wetter_precip, width = 800, height = 500, units = 'px', renderer = gifski_renderer())
anim_save(filename = "img/wetter2.gif", animation = anim_precip)




# Monatstemperatur --------------------------------------------------------
wetter_anim_monat <- 
  wetter %>%
  select(year, temp, month) %>% 
  mutate(month = factor(month)) |> 
  mutate(decade_year = year %% 10,
         decade = (year %/% 10) * 10) %>% 
  group_by(decade, month) %>% 
  summarise(temp = mean(temp, na.rm = TRUE)) %>% 
  ggplot(aes(x = decade, y = temp, color = month,
             group = month,
             frame = decade)) +
  geom_line() +
  scale_color_viridis_d() +
  transition_reveal(decade) +
  theme_minimal() +
  geom_label(aes(x = decade, y = temp, label = month))


anim_monat <- animate(wetter_anim_monat, width = 800, height = 500, units = 'px', renderer = gifski_renderer())
anim_save(filename = "img/wetter3.gif", animation = anim_monat)

