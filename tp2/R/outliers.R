#' qt es la tabla de student
#'
#' Por ejemplo, para el valor crítico de student
#' con alfa = .05 (dos colas) y 20 grados de libertad:
#'
#' > qt (1 - .05/2, 20)
#'
tau <- function(n) {
    stopifnot(n > 2)
    student <- qt(.975, n-2)
    (student * (n-1)) / (sqrt(n) * sqrt(n-2+student*student))
}

thompson_tau <- function(data) {
    n <- length(data)
    sample_mean <- mean(data)
    s <- sd(data)

    argmin <- which.min(data)
    argmax <- which.max(data)
    x <- data.frame(
        index=c(argmin, argmax),
        value=c(data[argmin], data[argmax]),
        dist=abs(c(data[argmin], data[argmax]) - sample_mean),
        row.names=c("min","max"))
    suspected <- x[which.max(x$dist),]

    if (suspected$dist < s * tau(n)) {
        return (data)
    } else {
        return (thompson_tau(data[- suspected$index]))
    }
}
