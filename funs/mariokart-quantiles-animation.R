# mario quartiles animation:

data(mariokart, package = "openintro")
library(tidyverse)
library(gganimate)

mariokart2 <-
  mariokart |> 
  filter(total_pr < 100)

d_anim_quartile <- 
  mariokart2|> 
  select(total_pr) |> 
  mutate(quart = cut(total_pr,
                     breaks = quantile(mariokart2$total_pr, probs = c(0, .25, .5, .75)),
                     include.lowest = TRUE, 
                     labels = 1:3)) |> 
  group_by(quart) |> 
  mutate(total_pr_max = max(total_pr))


d_anim2 <-
  d_anim_decile |> 
  ungroup() |> 
  select(total_pr)

p_quartiles  <- 
  d_anim_quartile |> 
  ggplot(aes(x = total_pr)) +
  geom_density(data = d_anim2) + 
  geom_vline(aes(xintercept = total_pr_max)) +
  geom_label(aes(label = quart, x = total_pr_max), y = 0)

p_quantiles_anim <-
  p_quartiles +
  transition_states(quart, transition_length = 2, state_length = 1) +
  ggtitle("Quartil: {closest_state}") +
  enter_fade() +
  exit_fade()

anim_save("img/p_quartiles_anim.gif", p_quantiles_anim, 
          renderer = gifski_renderer())





# Mario Deciles animation -------------------------------------------------





#| echo: false
#| eval: false
k <- 0:10
d_anim_decile <- 
  mariokart2 |> 
  select(total_pr) |> 
  mutate(decile = cut(total_pr,
                      breaks = quantile(mariokart2$total_pr, probs = k * .1),
                      include.lowest = TRUE, 
                      labels = 1:10)) |> 
  group_by(decile) |> 
  mutate(total_pr_max = max(total_pr))

d_anim_decile2 <-
  d_anim_decile |> 
  ungroup() |> 
  select(total_pr)

p_decile  <- 
  d_anim_decile |> 
  ggplot(aes(x = total_pr)) +
  geom_density(data = d_anim_decile2) + 
  geom_vline(aes(xintercept = total_pr_max)) +
  geom_label(aes(label = decile, x = total_pr_max), y = 0)

p_decile_anim <-
  p_decile +
  transition_states(decile, transition_length = 2, state_length = 1) +
  ggtitle("Dezil: {closest_state}") +
  enter_fade() +
  exit_fade()

anim_save("img/p_deciles_anim.gif", p_decile_anim, renderer = gifski_renderer())




# Mario Percentiles animation ---------------------------------------------




k <- 1:100
breaks_percentiles <- quantile(mariokart2$total_pr, probs = k * .01) 

breaks_percentiles <- 
  breaks_percentiles + 
  runif(n = length(breaks_percentiles), min = -.01, max = .01)

cuts_percentiles <- cut(mariokart2$total_pr,
                        breaks = breaks_percentiles,
                        include.lowest = TRUE,
                        labels = 1:99)

d_anim_percentile <-
  mariokart2 |> 
  select(total_pr) |> 
  mutate(perc = cuts_percentiles) |> 
  group_by(perc) |> 
  mutate(total_pr_max = max(total_pr))


d_anim_percentile2 <-
  d_anim_percentile |> 
  ungroup() |> 
  select(total_pr)

p_percentile  <- 
  d_anim_percentile |> 
  ggplot(aes(x = total_pr)) +
  geom_density(data = d_anim_percentile2) + 
  geom_vline(aes(xintercept = total_pr_max)) +
  geom_label(aes(label = perc, x = total_pr_max), y = 0)


p_percentile_anim <-
  p_percentile +
  transition_states(perc, transition_length = 2, state_length = 1) +
  ggtitle("Perzentil: {closest_state}") +
  enter_fade() +
  exit_fade()

library(gifski)
anim_save("img/p_percentile_anim.gif", p_percentile_anim, renderer = gifski_renderer())


