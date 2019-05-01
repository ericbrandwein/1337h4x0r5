read_data.s2 <- function(filename) {
    tabla <- read.csv(filename, stringsAsFactors=FALSE)
    stopifnot(all(c("source", "destination") %in% names(tabla)))
    tabla
}

read_data.s2a <- function(filename) {
    tabla <- read_data.s2(filename)
    ips <- c(tabla$source, tabla$destination)
    tabla <- data.frame(ips, stringsAsFactors=FALSE)
    class(tabla) <- c(class(tabla), "sample.s2a")
    tabla
}


get_symbol_names.sample.s2a <- function(data){ unique(data$ips) }

frecuencias_absolutas.sample.s2a <- function(data) {
    sapply(sort(get_symbol_names(data)),
           function(x) sum( data$ips == x))
}

probabilidades.sample.s2a <- function(data, n = nrow(data)) {
    frecuencias_absolutas(data) / n
}

fuente.s2a <- function(data.filename) {
    data <- read_data.s2a (data.filename)
    proba <- probabilidades(data)
    symbols <- names(proba)
    info <- probas_to_informaciones(proba)
    info.src <- data.frame(symbols, proba, info, stringsAsFactors=FALSE)
    info.src <- info.src[order(info.src$info),]
    row.names(info.src) <- 1:nrow(info.src)
    class(info.src) <- c(class(info.src), "info.src")
    info.src
}


fuente <- function(data.filename) {
    data <- read_data.s2a (data.filename)
    proba <- probabilidades(data)
    symbols <- names(proba)
    info <- probas_to_informaciones(proba)
    info.src <- data.frame(symbols, proba, info, stringsAsFactors=FALSE)
    ## info.src <- info.src[order(info.src$info),]
    ## row.names(info.src) <- 1:nrow(info.src)
    ## class(info.src) <- c(class(info.src), "info.src")
    ## info.src
    info
}


punto2a <- function(data.filename) {
    s1 <- fuente.s2a(data.filename)
    entr <- entropia(s1)
    entr.max <- entropia_max(s1)
    print(s1)
    cat("entropia: ", entr)
    cat("\tentropia maxima: ", entr.max, "\n")
}

