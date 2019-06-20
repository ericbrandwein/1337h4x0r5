## install.packages("maps")
## install.packages("geosphere")

library(maps)
library(geosphere)

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

get_limits <- function(data, margen=.05) {
    res <- list(min=min(data, na.rm=TRUE), max=max(data,  na.rm=TRUE))
    margen <- (res$max-res$min) * margen
    unlist(res) + c(-1, 1) * margen
}

plot_ips_table <- function (table, out_filename) { UseMethod("plot_ips_table") }
plot_ips_table.list<- function (tables, data.dirname = NULL) {
    stopifnot(!is.null(data.dirname))
    lapply(names(tables), function(n) {
        plot_ips_table(tables[[n]], file.path(data.dirname, "plots", n))
    })
}

plot_ips_table.data.frame <- function(table, out_filename = NULL) {
    data <- table
    if (!is.null(out_filename)) {
        top.title <- basename(out_filename)
        png(paste(out_filename, "png", sep="."), height=300*2, width=720*2)
    }
    
    par(mar=c(0.,0,0,0))
    map ('world', col="#e2e2e2", fill=TRUE, bg="white", lwd=0.5,mar=rep(0,4),
         border=0,
         xlim=get_limits(data$Long),
         ylim=c(-80,80)) ##get_limits(data$Lat))

    points(x=data$Long, y=data$Lat, col="slateblue", cex=1, pch=20)
    
    for (i in 2:length(data$Lat))  {
        c1 <- c(data$Long[i-1],data$Lat[i-1])
        c2 <- c(data$Long[i],data$Lat[i])
        if (any(is.na(c(c1,c2)))) { next }
        inter <- gcIntermediate(c1, c2, n=50,
                                breakAtDateLine=FALSE,
                                addStartEnd=TRUE) 
        lines(inter, col="slateblue", lwd=2)
    }

    if (!is.null(out_filename)) {
        title(top.title)
        ##legend("topright", top.title,  horiz = TRUE, fill = colors)
        dev.off()
    }
}
