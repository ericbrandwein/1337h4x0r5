#install.packages("tidyverse")  parece no hacer falta
#install.packages("maps")
#install.packages("geosphere")

#library(tidyverse)
library(maps)
library(geosphere)

args <- commandArgs(trailingOnly = TRUE)


if(length(args) == 1)
{
    tabla <- read.csv(args[1])
    attach(tabla)
    tabla <- as.matrix(tabla)
	


    par(mar=c(0,0,0,0))
    map('world',col="#e2e2e2", fill=TRUE, bg="white", lwd=0.5,mar=rep(0,4),border=0, ylim=c(-80,80) )
   

    data <- do.call(rbind,coor)    
    data <- as.data.frame(data)
    #colnames(data) <- c("long","lat")   

    points(x=Long, y=Lat, col="slateblue", cex=3, pch=20)


    
    for(i in 2:length(Lat))
     {

	c1 <- c(Long[i-1],Lat[i-1])

	c2 <- c(Long[i],Lat[i])
	inter <- gcIntermediate(c1, c2, n=50, addStartEnd=TRUE, breakAtDateLine=F)             
        lines(inter, col="slateblue", lwd=2)
     }
    
}
