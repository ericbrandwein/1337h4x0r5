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

biblio.red.a <- "10.128"
biblio.red.b <- "100.64"

dame_red <- function(tabla, red) {
    filas <- startsWith(tabla$source, red) &
        startsWith(tabla$destination, red)
    tabla[filas,]
}

sacar_red <- function(tabla, red) {
    filas <- !startsWith(tabla$source, red) &
        !startsWith(tabla$destination, red)
    tabla[filas,]
}

biblio.cruzadas <- function(tabla) {
    a <- "10.128"
    b <- "100.64"
    filas <- startsWith(tabla$source, a) &
        startsWith(tabla$destination, b) |
         startsWith(tabla$source, b) &
        startsWith(tabla$destination, a)
    tabla[filas,]
}
