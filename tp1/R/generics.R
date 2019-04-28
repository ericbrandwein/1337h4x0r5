#get_symbol_table <- function(data) UseMethod("get_symbol_table")
get_symbol_names <- function (fuente) {
    UseMethod("get_symbol_names")
}

frecuencias_absolutas <- function(data) {
    UseMethod("frecuencias_absolutas")
}

probabilidades <- function(data, n) {
    UseMethod("probabilidades")
}

entropia <- function(fuente) { UseMethod("entropia") }
entropia_max <- function(fuente) { UseMethod("entropia_max") }
entropia.info.src <- function(fuente) {
    sum(fuente$proba * fuente$info)
}
entropia_max.info.src <- function(fuente) { log2(nrow(fuente)) }


probas_to_informaciones <- function(probas) { log2(1/probas) }

