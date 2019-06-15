#install.packages("tidyverse")  parece no hacer falta
#install.packages("maps")
#install.packages("geosphere")

#library(tidyverse)
library(maps)
library(geosphere)

## args <- commandArgs(trailingOnly = TRUE)


plot_map <- function(filename) {
    data <- read.csv(filename)
    par(mar=c(0,0,0,0))
    map('world',col="#e2e2e2", fill=TRUE, bg="white", lwd=0.5,mar=rep(0,4),
        border=0, ylim=c(-80,80) )
    points(x=data$Long, y=data$Lat, col="slateblue", cex=3, pch=20)
}
