library(tidyverse)
library(magick)

img_path <- "https://statistik1.netlify.app/index_files/figure-html/unnamed-chunk-2-1.png"

img <- image_read(img_path)
img %>% 
  image_convert("png") %>% 
  image_resize("1080 x 200")%>% 
  image_fill(color="white", point="+45") %>% 
  image_annotate("Great Fit", size=38, location = "+32+58", color="black") -> res

res

library(hexSticker)

final_res<-sticker(res, package="statistik1", p_size=20,
                   p_y = 1.5,
                   s_x=1, s_y=0.8, s_width=1.1,
                   s_height = 14,
                   filename="statistik1_icon.png",h_fill="#062047",h_color = "#062047")

plot(final_res)
