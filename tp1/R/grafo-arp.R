grafo.arp <- function(data) {
    
    src <- as.character(data$source)
    dest <- as.character(data$destination)

    difes <- src != dest

    src <- src [difes]
    dest <- dest [difes]
    
    qgraph(unique(data.frame(src, dest)))
}

grafo.arp.tmp <- function(data) {
    png("tmp.png", width=4800, height=4800)

    src <- as.character(data$source)
    dest <- as.character(data$destination)

    difes <- src != dest

    src <- src [difes]
    dest <- dest [difes]
    
    qgraph(unique(data.frame(src, dest)))
    dev.off()
}
