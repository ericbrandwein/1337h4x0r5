
grafico_barras0.s1 <- function(info.src) {
    stopifnot("info.src" %in% class(info.src))
    entr <- entropia(info.src)
    entr.max <- entropia_max(info.src)
    
    ggplot(data = info.src, aes(x=symbols, y=info)) +
        geom_bar (stat = "identity") +
        geom_hline(yintercept = entr, color = "blue") +
        geom_hline(yintercept = entr.max, color   = "red") +
        annotate ("text", 0.75, entr * 1.1 , label = "entropía") +
        annotate ("text", 1, entr.max * 1.1 , label = "entropía máxima") +

        ggtitle("Información de cada símbolo")
}



grafico_barras.s1 <- function(info.src) {
    stopifnot("info.src" %in% class(info.src))
    ggplot(data = info.src, aes(x=symbols, y=info)) +
        geom_bar (stat = "identity") +
        geom_hline(aes(yintercept = entropia(info.src), colour = "entropía")) +
        geom_hline(aes(yintercept = entropia_max(info.src), colour = "entropía\nmáxima")) +
        ggtitle("Información de cada símbolo")
}


grafico_linea.s2 <- function(info.src) {
    info.src <- info.src[order(info.src$info),]
    nodos = 1:nrow(info.src)
    stopifnot("info.src" %in% class(info.src))
    ggplot(data = info.src, aes(x=nodos, y=info)) +
        geom_bar (stat = "identity") +
        geom_hline(aes(yintercept = entropia(info.src), colour = "entropía")) +
        geom_hline(aes(yintercept = entropia_max(info.src), colour = "entropía\nmáxima")) +
        ggtitle("Información de cada símbolo")
}
