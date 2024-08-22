library(tidyverse)
library(easystats)
library(DataExplorer)

library(patchwork)
library(ggpubr)

source("_common.R")

mariokart <- read.csv("https://vincentarelbundock.github.io/Rdatasets/csv/openintro/mariokart.csv")

ggplot2::theme_set(theme_minimal())

set.seed(42)
d <-
  tibble(
    id = 1:100,
    x1 = rnorm(100, 0, 1),
    x2 = rnorm(100, 0, 7)
  ) %>% 
  pivot_longer(-id) %>% 
  group_by(name) %>% 
  mutate(avg = mean(value),
         e = value - avg) %>% 
  ungroup()

d_sum <-
  d %>% 
  group_by(name) %>% 
  summarise(avg = mean(value))

group_names <-
  c(x1 = "wenig Streuung:\nDiktableibtin",
    x2 = "viel Streuung:\nPfundafliptan")

d %>% 
  ggplot(aes(x = id, y = value)) +
  geom_point() +
  facet_wrap(~ name, labeller = as_labeller(group_names)) +
  geom_hline(color = okabeito_colors()[1], yintercept = 0) +
  geom_segment(aes(x = id, xend = id, y = value, yend = avg), 
               alpha = .5, color = "grey") +
  theme_minimal() +
  geom_label(x = 0, y = 0, label = "MW", color = okabeito_colors()[1]) +
  scale_x_continuous(limits = c(-10,100))

data(mariokart, package = "openintro")
m <-
  mariokart %>%
  filter(total_pr < 100) %>% 
  filter(wheels %in% c(0, 2)) %>% 
  mutate(ID = 1:nrow(.),
         total_pr_resid = total_pr - mean(total_pr),
         total_pr_resid_quad = total_pr_resid^2) %>% 
  group_by(wheels) %>% 
  mutate(total_pr_mean_group = mean(total_pr)) %>% 
  ungroup()


m_sum <- 
  m %>% 
  group_by(wheels) %>% 
  summarise(total_pr = mean(total_pr)) %>% 
  ungroup()


m %>% 
  ggplot() +
  geom_hline(aes(yintercept = mean(total_pr))) +
  geom_segment(aes(x = ID,
                   xend = ID,
                   y = total_pr,
                   yend = mean(total_pr)
                   ), color = "grey") +
  geom_point(aes(x = ID, y = total_pr)) +
  annotate("label", x = 0, y = 47, label = "MW", hjust = "left", size = 6)



m %>% 
  ggplot() +
  geom_segment(data = filter(m, wheels == 0),
               aes(x = ID,
                   xend = ID,
                   y = total_pr,
                   yend = mean(total_pr)
               ), color = "grey") +
   geom_hline(data = m_sum,
     aes(yintercept = total_pr,
                 color = factor(wheels))) +
   geom_segment(data = filter(m, wheels == 2),
               aes(x = ID,
                   xend = ID,
                   y = total_pr,
                   yend = mean(total_pr)
               ), color = "grey") +
  geom_point(
    aes(x = ID, y = total_pr, color = factor(wheels))) +
  labs(color = "wheels") +
  theme(legend.position = "none") +
  geom_label(data = m_sum,
    aes(label = paste0("MW bei ", wheels, " Räder"), y = total_pr, color = factor(wheels)), x = 3, size = 6) +
  scale_color_okabeito() +
  scale_x_continuous(limits = c(-10, 90))

d <-
  tibble(id = 1:4,
         y = c(1, -3, 1, 1))


ggplot(d) +
  aes(x = id, y = y) +
  geom_point(size = 5, alpha = .7, color = "red") +
  geom_segment(aes(x = id, xend = id, y = y, yend = mean(y))) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  annotate("label", x = 0.5, y = 0, label = "Mittelwert") +
  theme_minimal() +
  scale_x_continuous(limits = c(0, 4))

lm1 <- lm(y ~ 1, data = d)

mae(lm1)

mario_quantile2 <- 
mariokart %>% 
  filter(total_pr < 100) %>% 
  summarise(q25 = quantile(total_pr, .25),
            q50 = quantile(total_pr, .50),
            q75 = quantile(total_pr, .75))

mario_quantile <- 
  mariokart %>% 
  filter(total_pr < 100) %>% 
  reframe(qs = quantile(total_pr, c(.25, .5, .75)))

mariokart %>% 
  filter(total_pr < 100) %>%  
  ggplot(aes(x = total_pr)) +
  geom_histogram() +
  geom_vline(xintercept = mario_quantile$qs) +
  annotate("label", x =  mario_quantile$qs, y = 0, label =  mario_quantile$qs) +
  annotate("label", x =  mario_quantile$qs, y = Inf, label =  c("Q1", "Median", "Q3"), vjust = 2) +
  labs(y = "Anzahl") +
  geom_segment( 
           aes(x = q25, xend = q75), 
           y = 5, yend = 5, color = "#56B4E9",
           data = mario_quantile2, size = 3) +
  annotate("label", x = mario_quantile2$q50, y = 5,
           label = "IQR", color = "#56B4E9")

mariokart %>% 
  filter(total_pr < 100) %>%  
  ggplot(aes(x = total_pr)) +
  geom_density() +
  geom_vline(xintercept = mario_quantile$qs) +
  annotate("label", x =  mario_quantile$qs, y = 0, label =  mario_quantile$qs) +
  annotate("label", x =  mario_quantile$qs, y = Inf, label =  c("Q1", "Median", "Q3"), vjust = 2) +
  labs(y = "Anzahl") +
  geom_segment( 
           aes(x = q25, xend = q75), 
           y = 0.01, yend = 0.01, color = "#56B4E9",
           data = mario_quantile2, size = 3) +
  annotate("label", x = mario_quantile2$q50, y = .01,
           label = "IQR", color = "#56B4E9")

library(viridis)

d <-
  tibble(id = 1:4,
         y = c(0.1, -.3, .1, .1)) %>% 
  mutate(y_avg = mean(y),
         delta = y - y_avg,
         delta_abs = abs(delta),
         pos = ifelse(delta > 0, "positiv", "negativ"),
         delta_sq = delta^2)

var_smpl <- mean(d$delta_sq)

p_deltas <- 
d %>%   
  ggplot(aes(x = id, y = y)) +
  geom_hline(yintercept = mean(d$y), linetype = "dashed", show.legend = FALSE) +
  geom_segment(aes(y = mean(d$y),
                   yend = y,
                   x = id,
                   xend = id,
                   linetype = pos), show.legend = FALSE) +
  annotate(geom = "label",
           x = 0,
           hjust = 0,
           y = mean(d$y), 
           label = paste0("MW = ", round(mean(d$y), 2)), show.legend = FALSE) +
  geom_rect(aes(ymin = y_avg,
                ymax = y,
                xmin = id,
                xmax = id+delta_abs),
            fill = "#E69F00FF" ,
            alpha = .5, show.legend = FALSE) +
  geom_text(aes(label=round(delta_sq,3)),
            hjust = "left", 
            nudge_x = 0.05,
            vjust = ifelse(d$pos == "positiv", "top", "bottom"),
            nudge_y = ifelse(d$pos == "positiv", -0.05, 0.05),
            color = "#E69F00FF",
            size = 6, show.legend = FALSE) +
  geom_point(size = 5, show.legend = FALSE) +
  labs(linetype = "",
       x = "",
       y = "")  +
  scale_y_continuous(limits = c(-.3, .1)) +
  scale_x_continuous(limits = c(0, 5)) +
  theme_minimal()

p_var <- 
  d %>%   
    ggplot(aes(x = id, y = y)) + 
    geom_hline(yintercept = mean(d$y), linetype = "dashed") +
     annotate(geom = "label",
             x = 0,
             hjust = 0,
             y = mean(d$y), 
             label = paste0("MW = ", round(mean(d$y), 2))) +
    annotate("rect", 
             xmin =  5, ymin = 0, xmax = 5.2, ymax = var_smpl, 
             fill = "#56B4E9FF") +
    scale_y_continuous(limits = c(-.3, .1)) +
    scale_x_continuous(limits = c(0, 6)) +
    annotate(geom = "label",
                  x = 4,
                  hjust = 0.5,
                  y = -0.1,
                  label = "Varianz",
             color = "#56B4E9FF",
             size = 8) +
  theme_minimal() +
  annotate("label", 
           x = 3, 
           y = -0.2,
           hjust = 0.5,
           label = paste0(var_smpl, " = (0.01 + 0.01 + 0.01 + 0.09)/4"),
           size = 8)

p_deltas
p_var

mariokart_no_extreme <-
  mariokart %>%
  filter(total_pr < 100)  # ohne Extremwerte

m_summ <- 
  mariokart_no_extreme %>% 
  summarise(
    pr_mw = mean(total_pr),
    pr_iqr = IQR(total_pr),
    pr_maa = mean(abs(total_pr - mean(total_pr))),
    pr_var = var(total_pr),
    pr_sd = sd(total_pr))

m_summ %>% print_md()

## mariokart %>%
##   mariokart %>%
##   select(total_pr) %>%
##   filter(total_pr < 100) %>%  # ohne Extremwerte
##   plot_density()

mariokart %>% 
  select(total_pr) %>% 
  filter(total_pr < 100) %>%  # ohne Extremwerte
  ggplot() +
  geom_density(aes(x = total_pr)) +
  geom_rect(data = m_summ, 
               aes(
                 xmin = pr_mw - 0.5*(pr_sd),
                 xmax = pr_mw + 0.5*(pr_sd),
                 ymin = 0,
                 ymax = Inf
               ),
            alpha = .5,
            fill = "red")

mariokart %>% 
  select(total_pr) %>% 
  filter(total_pr < 100) %>%  # ohne Extremwerte
  ggplot() +
  geom_violin(aes(
    x = 1,
    y = total_pr)) +
  geom_jitter(aes(
    x = 1,
    y = total_pr),
    width = 0.1) +
  scale_x_continuous(limits = c(0, 2)) +
  geom_rect(data = m_summ, 
               aes(
                 ymin = pr_mw - 0.5*(pr_sd),
                 ymax = pr_mw + 0.5*(pr_sd),
                 xmin = -Inf,
                 xmax = Inf
               ),
            alpha = .5,
            fill = "red")

library(easystats)

mariokart %>% 
  select(total_pr) %>% 
  describe_distribution()

lm1 <- lm(total_pr ~ 1, data = mariokart)
mae(lm1)

lm2 <- lm(total_pr ~ wheels, data = mariokart)
mae(lm2)

lm_mario1 <- lm(total_pr ~ 1, data = mariokart)

mae(lm_mario1)  # Mean absolute error
mse(lm_mario1)  # Mean squared error
rmse(lm_mario1)  # Root mean squared error

mariokart_no_extreme <- 
  mariokart %>% 
  filter(total_pr < 100)

mariokart_no_extreme <-
  mariokart_no_extreme %>% 
  mutate(abw = 47.4 - total_pr)


gghistogram(mariokart_no_extreme, x = "total_pr", 
            add = "mean",  # Mittelwert wird hinzugefügt
            add.params = list(color = okabeito_colors()[1], size = 3))  +# Schnickschnack zur Verschönerung
  annotate("label", x=47, y = 0, label = "Mittelwert")

gghistogram(mariokart_no_extreme, x = "abw",
            add = "mean",  # Mittelwert wird hinzugefügt
            add.params = list(color =  okabeito_colors()[1], size = 3))  +# Schnickschnack zur Verschönerung
  annotate("label", x= 0, y = 0, label = "Mittelwert")

mariokart_no_extreme <-
  mariokart_no_extreme %>% 
  mutate(abw = 47.4 - total_pr)

mw <- 47.4
streuung <- 9.11

d <- 
  tibble(groesse = rnorm(1e5, mw, streuung),
         groesse_zentriert = groesse - mean(groesse))

d_sum <-
  d %>% 
  pivot_longer(everything()) %>%
  group_by(name) %>% 
  summarise(MW = mean(value))
  

d %>% 
  ggplot() +
  geom_density(aes(x = groesse), color = "#E69F00FF", size = 2) +
  geom_density(aes(x = groesse_zentriert), color = "#56B4E9FF", size = 2) +
  theme_minimal() +
  geom_vline(data = d_sum,
             aes(xintercept = MW),
             color = "grey") +
  geom_label(data = d_sum,
             aes(label = paste0("MW: ", round(MW, 0)), x = MW),
             y = 0) +
  labs(x = "(zentrierte) Variable", 
       y = "") +
  annotate("segment", x = mw, xend = 0, y = 0.01, yend = 0.01,
           arrow = arrow(type = "closed", length = unit(0.02, "npc")))



# d %>% 
#   pivot_longer(everything()) %>% 
#   ggplot() +
#   aes(x = value) +
#   geom_density() +
#   facet_wrap(~ name) +
#   theme_minimal() +
#   geom_vline(data = d_sum,
#              aes(xintercept = MW), color = "red") +
#   geom_label(data = d_sum,
#              aes(label = paste0("MW: ", round(MW, 0)), x = MW),
#              y = 0) +
#   labs(x = "(zentrierte) Körpergröße", 
#        y = "")

mariokart_no_extreme <-
  mariokart_no_extreme %>% 
  mutate(abw_std = abw / sd(abw),  # std wie "standardisiert"
         abw_std2 = abw / mean(abs(abw)))  

p1 <- gghistogram(mariokart_no_extreme, x = "abw",
            add = "mean",  # Mittelwert wird hinzugefügt
            add.params = list(color = okabeito_colors()[1], size = 3)) +
  labs(title = "Rohwerte") +
  annotate("label", x = 0, y = 0, label = "MW", hjust = "bottom")

p2 <-  gghistogram(mariokart_no_extreme, x = "abw_std",
            add = "mean",  # Mittelwert wird hinzugefügt
            add.params = list(color = okabeito_colors()[1], size = 3)) +
  labs(title = "Standardisierte Werte") +
  annotate("label", x = 0, y = 0, label = "MW", hjust = "bottom")

arrow_down <- png::readPNG("img/arrow-down.png", native = TRUE)
p_ad <- ggplot() + inset_element(arrow_down, 0, 0, 1, 1)

plots(p1, p_ad, p2, n_rows = 3)

data_path <- "https://raw.githubusercontent.com/sebastiansauer/statistik1/main/daten/Smartphone-Nutzung%20(Responses)%20-%20Form%20responses%201.csv"

smartphone_raw <- read.csv(data_path)

item_labels <- names(smartphone_raw)

names(smartphone_raw) <- paste0("item",1:ncol(smartphone_raw))

glimpse(smartphone_raw)
