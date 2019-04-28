read_data.s1 <- function (filename) {
    tabla <- read.csv(filename)
    stopifnot(all(names(tabla) == c("method", "dest_type")))
    tabla$dest_type <- as.numeric(tabla$dest_type) - 1
    class(tabla) <- c(class(tabla), "sample.s1")
    tabla
}

get_symbol_table.sample.s1 <- function(data) {
    res <- unique(data)
    row.names(res) <- 1:nrow(res)
    res
}

get_symbol_names.sample.s1 <- function (data) {
    symbols <- unique(data)
    row.names(symbols) <- 1:nrow(symbols)
    symbols$dest_type <- ifelse(symbols$dest_type == 0, "unicast", "broadcast")
    apply(symbols, 1, function(row) paste(row, collapse=":"))
}


frecuencias_absolutas.sample.s1 <- function(data) {
    apply(get_symbol_table.sample.s1(data), 1, function(r0) sum(apply(data, 1, function(r) all(r == r0))))
}

probabilidades.sample.s1 <- function(data, n = nrow(data)) {
    frecuencias_absolutas(data) / n
}


fuente.s1 <- function(data.filename) {
    data <- read_data.s1 (data.filename)
    fuente <- get_symbol_table.sample.s1(data)
    symbols <- get_symbol_names(fuente)
    proba <- probabilidades(data)
    info <- probas_to_informaciones(proba)
    info.src <- data.frame(symbols, proba, info)
    class(info.src) <- c(class(info.src), "info.src")
    info.src
}

punto1 <- function(data.filename) {
    s1 <- fuente.s1(data.filename)
    entr <- entropia(s1)
    entr.max <- entropia_max(s1)
    print(s1)
    cat("entropia: ", entr)
    cat("\tentropia maxima: ", entr.max, "\n")
}
