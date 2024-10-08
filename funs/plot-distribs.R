
plot_distribs <- function(plot_it = FALSE) {
  
  #library(openintro)
  suppressPackageStartupMessages(library(mosaic))
  
  # Fleishman, Allen I. "A method for simulating non-normal distributions." Psychometrika 43.4 (1978): 521-532.
  
  dev34<-function(x, sk=0, ku=0)
  {
    b<-x[1]
    d<-x[2]
    a<-sqrt(abs((1-(b^2+15*d^2+6*b*d))/2))
    skew<-2*a*(b^2+24*b*d+105*d^2+2)
    kurt<-24*(b*d+a^2*(1+b^2+28*b*d)+d^2*(12+48*b*d+141*a^2+225*d^2))
    dev<-(sk-skew)^2+(ku-kurt)^2
    return(dev)
  }
  findFleish<-function(skew=0, kurt=0)
  {
    erg <- optim(c(0,0), dev34, sk=skew, ku=kurt, control=list(abstol=1e-6, maxit=1000))
    b<-erg$par[1]
    d<-erg$par[2]
    if (erg$value>0.0001) warning("Fleishmansystem unreliable")
    a<-sqrt(abs((1-(b^2+15*d^2+6*b*d))/2))
    erg<-c(-a, b, a, d)
    return(erg)
  }
  rfleish <- function(n=n, mean=0, var=1, skew=0, kurt=3)
  {
    x <- rnorm(n)
    if (kurt-skew^2-1<0) warning("Impossible Skewness, Kurtosis Values!")
    pars <- findFleish(skew=abs(skew), kurt=kurt-3)
    if (skew>0) x <- pars[1]+pars[2]*x+pars[3]*x^2+pars[4]*x^3
    else x <- -pars[1]+pars[2]*x-pars[3]*x^2+pars[4]*x^3
    x <- x*sqrt(var)+mean
    return(x)
  }
  
  n <- 10000
  
  xn <- rnorm(n = n)
  nor <- data.frame(Verteilung = "Symmetrisch (Normal)", x = xn)
  
  xls <- rfleish(n = n, skew = -0.65)
  xrs <- rfleish(n = n, skew = 0.65)
  st <- c(rep("Linksschief", n), rep("Rechtsschief", n))
  x <- c(xls, xrs)
  schiefe <- data.frame(Verteilung = st, x = x)
  
  xl <- rnorm(0.65*n, mean = -1,sd = 0.5)
  xr <- rnorm(0.35*n, mean = 1, sd = 0.5)
  xmm <- c(xl,xr)
  xmm <- (xmm - mean(xmm))/sd(xmm)
  bimod <- data.frame(Verteilung = "Bimodal", x = xmm)
  
  x1 <- rnorm(0.35*n, mean = -1,sd = 0.5)
  x2 <- rnorm(0.25*n, mean = 3, sd = 1)
  x3 <- rnorm(0.40*n, mean = -5, sd = 0.5)
  xmm <- c(x1,x2,x3)
  xmm <- (xmm - mean(xmm))/sd(xmm)
  multimod <- data.frame(Verteilung = "Multimodal", x = xmm)
  
  xg <- runif(n)
  xg <- (xg - mean(xg))/sd(xg)
  gleich <- data.frame(Verteilung = "Gleichverteilung", x = xg)
  
  dat <- rbind(nor, schiefe,  bimod, multimod, gleich)
  
  
  out <- 
    gf_histogram(~x | Verteilung, data = dat) %>% 
    gf_theme(axis.text = element_blank(), 
             axis.text.y = element_blank(), 
             axis.title.x = element_blank(), 
             axis.title.y = element_blank(), 
             axis.ticks = element_blank())
  
  if (plot_it) plot(out)
  
  return(out)
}
