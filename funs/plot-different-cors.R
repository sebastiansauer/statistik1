
plot_different_cors <- function(plot_it = FALSE, short = FALSE){
  
  #### Quelle http://moderndive.com/scripts/06-regression.R
  ## Leichte Anpassungen durch N. Markgraf
  # library(mosaic)
  library(mvtnorm) 
  set.seed(2009)
  
  correlation <- c(-0.999999, -0.90, -0.75, -0.30, 0.00, 0.30, 0.75, 0.90, 0.999999)
  if (short) correlation <- setdiff(correlation, c(-0.999999, 0.999999, -0.75, 0.75, -0)) 
  eps <- 0.00001
  n_sim <- 100
  
  values <- NULL
  for (i in 1:length(correlation)) {
    rho <- correlation[i]
    rs <- rho * sqrt(50)
    sigma <- matrix(c(5, rs, rs, 10), 2, 2) 
    sim <- rmvnorm(
      n = n_sim,
      mean = c(20,40),
      sigma = sigma
    )
    r <- cor(sim[,1],sim[,2])
    new_err <- NULL
    new_r <- NULL
    err <- abs(rho - r)
    for (j in 1:1000) {
      sim_t <- rmvnorm(
        n = n_sim,
        mean = c(20,40),
        sigma = sigma
      )
      new_r <- cor(sim_t[,1], sim_t[,2])
      new_err <- abs(rho - new_r)
      if (new_err < err) {
        # cat(paste("want:",rho,"- got:",r,"- err:",err,"- new:",new_r,"new-err:",new_err,"\n"))
        sim <- sim_t
        r <- new_r
        err <- new_err
      }
      if (new_err < eps) {
        break
      }
    }
    sim %>%   
      as.data.frame() %>% 
      mutate(correlation = round(rho,2)) %>%
      mutate(reel_correlation = round(cor(V1,V2),2)) %>%
      mutate(reel_correlation_2 = round(r,2)) %>%
      mutate(cor_err = err) -> sim
    
    values <- bind_rows(values, sim)
  }
  
  
  if (!short){
    out <- ggplot(data = values, mapping = aes(V1, V2)) +
      geom_point() + 
      # stat_ellipse(level=0.999, type="norm", color="darkgreen", linetype="dotted", alpha=0.25) +
      # geom_lm(level=0.999) +
      facet_wrap(~ correlation, ncol = 3)  +
      labs(x = "", y = "") + 
      coord_fixed(ratio=25/40) + # (30-5)/(60-20)
      theme(
        axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks = element_blank()
      )  +
      geom_smooth(method = "lm", se= FALSE)
    #unique(values$correlation)
    #unique(values$reel_correlation)
    #unique(values$reel_correlation_2)
    #unique(values$cor_err)
  }
  
  if (short) {
    values <-
      values %>% 
      mutate(Richtung = ifelse(correlation > 0, "positiv", "negativ"),
             Staerke = ifelse(abs(correlation) > .5, "stark", "schwach"))
    out <- ggplot(data = values, mapping = aes(V1, V2)) +
      geom_point() + 
      facet_grid(Staerke ~ Richtung ) +
      labs(x = "", y = "") + 
      coord_fixed(ratio=25/40) + # (30-5)/(60-20)
      theme(
        axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks = element_blank()
      )  +
      geom_smooth(method = "lm", se= FALSE) +
      stat_ellipse( type="norm", color="blue", linetype="dotted", alpha=0.75)
  }
  
  #detach("package:mvtnorm", unload=TRUE)
  #detach("package:bindrcpp", unload=TRUE)
  
  if (plot_it) plot(out)
  
  return(out)
}

