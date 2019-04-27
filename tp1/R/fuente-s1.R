read_s1_data <- function (filename) {
    tabla <- read.csv(filename)
    stopifnot(all(names(tabla) == c("method", "dest_type")))
    tabla$dest_type <- as.numeric(tabla$dest_type) - 1
    tabla
}

get_symbol_table <- function(data) {
    res <- unique(data)
    row.names(res) <- 1:nrow(res)
    res
}

get_symbol_names <- function (fuente) {
    fuente$dest_type <- ifelse(fuente$dest_type == 0, "unicast", "broadcast")
    apply(fuente, 1, function(row) paste(row, collapse=":"))
}


frecuencias_absolutas <- function(data) {
    apply(get_symbol_table(data), 1, function(r0) sum(apply(data, 1, function(r) all(r == r0))))
}

probabilidades <- function(data, n = nrow(data)) {
    frecuencias_absolutas(data) / n
}

probas_to_informaciones <- function(probas) { log2(1/probas) }

fuente <- function(data.filename) {
    data <- read_s1_data (data.filename)
    fuente <- get_symbol_table(data)
    symbols <- get_symbol_names(fuente)
    proba <- probabilidades(data)
    info <- probas_to_informaciones(proba)
    data.frame(symbols, proba, info)
}

entropia <- function(fuente) { sum(fuente$proba * fuente$info) }

entropia.max <- function(fuente) { log2(nrow(fuente)) }

punto1 <- function(data.filename) {
    s1 <- fuente(data.filename)
    entr <- entropia(s1)
    entr.max <- entropia.max(s1)
    print(s1)
    cat("entropia: ", entr)
    cat("\tentropia maxima: ", entr.max, "\n")
}
