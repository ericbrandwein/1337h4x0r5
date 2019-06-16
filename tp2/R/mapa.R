#install.packages("tidyverse")  parece no hacer falta
#install.packages("maps")
#install.packages("geosphere")

#library(tidyverse)
library(maps)
library(geosphere)

## args <- commandArgs(trailingOnly = TRUE)


plot_map <- function(filename) {
    data <- read.csv(filename)
    png(filename="mapa.png",height=256, width=720)
    par(mar=c(0,0,0,0))
    map('world',col="#e2e2e2", fill=TRUE, bg="white", lwd=0.5,mar=rep(0,4),
        border=0, ylim=c(-80,80) )
    points(x=data$Long, y=data$Lat, col="slateblue", cex=1, pch=20)
    
    for(i in 2:length(data$Lat))
    {
	c1 <- c(data$Long[i-1],data$Lat[i-1])
	c2 <- c(data$Long[i],data$Lat[i])
	inter <- gcIntermediate(c1, c2, n=50, addStartEnd=TRUE, breakAtDateLine=F)             
        lines(inter, col="slateblue", lwd=2)
     }
	
    dev.off()
}
