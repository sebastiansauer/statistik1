

histogram_to_boxplot <- function(d = mariokart, 
                                 var_chosen = "total_pr", 
                                 plot_it = FALSE, 
                                 binwidth = 1,
                                 digits = 0){
  
  library(gridExtra)
  library(ggplot2)
  #library(grid)
  #library(patchwork)
  
  # based on this source: https://stackoverflow.com/questions/16083275/histogram-with-marginal-boxplot-in-r
 
  focus_var <- d[[var_chosen]]
  
  var_mean <- mean(d[[var_chosen]])
  var_md <- median(d[[var_chosen]])
  var_q1 <- quantile(d[[var_chosen]], probs = .25)
  var_q3 <- quantile(d[[var_chosen]], probs = .75)
  
  
  out <-
    ggplot(aes(x = .data[[var_chosen]]), data = d) +
    geom_histogram(color = "black", binwidth = binwidth) +
    scale_x_continuous(limits = c((min(d[[var_chosen]])),(max(d[[var_chosen]]))), 
                       breaks = pretty(d[[var_chosen]], n = 10)) +
    labs(x = "", y = "Anzahl") +
    scale_y_continuous(breaks = c(0, 5, 10, 15)) +
    geom_vline(xintercept = var_md, linetype = "dashed", color = okabeito_colors()[1]) +
    geom_vline(xintercept = var_q1, linetype = "dashed", color = okabeito_colors()[2]) +
    geom_vline(xintercept = var_q3, linetype = "dashed", color = okabeito_colors()[2]) +
    geom_boxplot(aes(y = -1), width = 1.5, outlier.size = 2, color = "black", fill = "grey40") +
    annotate("label", x = var_md, y = Inf, label = paste0("Md: ", round(var_md, digits)), vjust = "top") +
    annotate("label", x = var_q1, y = -0.5, label = paste0("Q1: ", round(var_q1, digits)), vjust = "bottom") +
    annotate("label", x = var_q3, y = -0.5, label = paste0("Q3: ", round(var_q3, digits)), vjust = "bottom") 
    
  # p2 <-
  #   ggplot(aes(x = 0, .data[[var_chosen]]), data = d) +
  #   stat_boxplot(geom ='errorbar') +
  #   geom_boxplot(outlier.colour = "red") +
  #   coord_flip() +
  #   scale_y_continuous(limits = c((min(d[[var_chosen]])),(max(d[[var_chosen]]))), 
  #                      breaks = pretty(d[[var_chosen]], n = 10)) +
  #   labs(x = "", y = var_chosen)  +
  #   annotate("label", y = var_md, x = 0.5 , label = paste0("Md")) +
  #   annotate("label", y = var_q1, x = -2 + 0.5 , label = paste0("Q1"), vjust = "bottom") +
  #   annotate("label", y = var_q3, x = -2 + 0.5, label = paste0("Q3"), vjust = "bottom") +
  #   scale_x_continuous(limits = c(-2,1), breaks = NULL)
  # 
  # 
  # out <- (p1 / p2)
  
  if (plot_it) plot(out)
  
  return(out)
}
