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

bibilio.unique <- function() {
    bb <- unique(read_data.s2("../datos/s2/biblio.csv"))

}


biblio.sin.100.64 <- function() {
    bb <- unique(read_data.s2("../datos/s2/biblio.csv"))
    red <- "100.64"
    filas <- !startsWith(bb$source, red) &
        !startsWith(bb$destination, red)
    bb[filas,]
    
}

sacar.nodos.con <- function(tabla, prefijo) {
    filas <- !startsWith(tabla$source, prefijo) &
        !startsWith(tabla$destination, prefijo)
    tabla[filas,]
 }

filtrar.eric <- function() {
    ## solo que envian
    eric <- unique(read_data.s2("../datos/s2/casa-eric.csv"))

    quedan <- eric$destination %in% eric$source
    eric[quedan,]
}

get_symbols <- function(tabla) {
    unique(c(tabla$destination, tabla$source))
}

filtrar.exactas <- function() {
    ## solo que envian
    exac <- read_data.s2("../datos/s2/exactas-wifi-arp.csv")
    
    return(exac)
    exac <- unique(exac[c("source", "destination")])

    syms <- get_symbols(exac)

    tabla.src <- table(exac$source) > 1
    tabla.dst <- table(exac$destination) > 1

    tabla.src <- tabla.src[tabla.src]
    tabla.dst <- tabla.dst[tabla.dst]
    
    quedan <- syms %in% c(names(tabla.src), names(tabla.dst))
    quedan <- syms[quedan]
    quedan <- exac$source %in% quedan | exac$destination %in% quedan
    exac[quedan,]
}

exactas.cruzadas <- function() {
    tabla <- read_data.s2("../datos/s2/exactas-wifi-arp.csv")

    a <- "10.2."
    b <- "169.254"
    filas <- startsWith(tabla$source, a) &
        startsWith(tabla$destination, b) |
         startsWith(tabla$source, b) &
        startsWith(tabla$destination, a)
    tabla[filas,]
}

exactas.sin.10.2 <- function() {
    tabla <- read_data.s2("../datos/s2/exactas-wifi-arp.csv")
    red <- "10.2."
    filas <- !startsWith(tabla$source, red) &
        !startsWith(tabla$destination, red)
    tabla[filas,]
}

exactas.sin.169.254 <- function() {
    tabla <- read_data.s2("../datos/s2/exactas-wifi-arp.csv")
    red <- "169.254"
    filas <- !startsWith(tabla$source, red) &
        !startsWith(tabla$destination, red)
    tabla[filas,]
}

