
set.seed(42)  # For reproducibility

modelcol <- "#56B4E9"
ycol <- "#E69F00"

df_3d <-
  tibble(x1 = rnorm(mean = 0, sd = 1, n=  100), 
         x2 =  rnorm(mean = 0, sd = 1, n=  100), 
         y = 3 + 2*x1 + x2 + rnorm(mean = 0, sd = 0.1, n = 100) 
  )
lm_rand <- lm(y ~ x1 + x2, data =df_3d)



# Create a 3D scatter plot
s3d <- scatterplot3d(
  x = df_3d$x1,       # X-axis
  y = df_3d$x2,      # Y-axis
  z = df_3d$y,       # Z-axis DV!
  pch = 16,        # Use solid circles for points
  color = ycol,  # Color of points
  angle = 10,
  xlab = "x1", # X-axis label
  zlab = "y",  # Y-axis label
  ylab = "x2",        # Z-axis label
  main = "y ~ x1 + x2" # Main title
)




s3d$points3d(x = df_3d$x1, y = df_3d$x2, z = df_3d$y)

# Add the regression plane to the plot
s3d$plane3d(lm_rand)
