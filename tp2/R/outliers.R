#' qt es la table de student
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
    stopifnot(is.vector(data))
    data <- data[!is.na(data)]
    n <- length(data)
    if (n <= 2) { return (data) }
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

rtt_medios <- function(data, FUN = mean) {
    res <- aggregate(list(data$rtt, data$ttl), by=list(data$dst), FUN)
    names(res)  <- c("dst", "mean.rtt","ttl")
    res <- res[order(res$ttl),]
    rownames(res) <- 1:nrow(res)
    res <- res[c("dst", "ttl","mean.rtt")]
    . <- c(0, res$mean.rtt[1:(nrow(res)-1)])
    res$links <- res$mean.rtt - .
    res
}

#' simple plot:
#' data <- read.csv("mi tabla.csv")
#' x <- rtt_medios(data)
#' plot (x$links, type="l")

create_table <- function(filename) {
    data <- read.csv(filename)
    out <- rtt_medios(data)
    out.filename <- paste(tools::file_path_sans_ext(filename), "trace-table", sep=".")
    write.table(out, file=out.filename)
    cat(out.filename, " created")
}

split_outliers <- function(data) {
    stopifnot(is.vector(data))
    zeros <- data < 0
    data[zeros] <- 0
    res <- split_outliers_impl (data)
    names(res) <- c("data", "outliers")
    res
}


split_outliers_impl <- function(vec, outliers=c()) {
    data <- vec
    if (length(outliers) > 0) {
        data <- vec[vec < min(outliers)]
    }
    
    n <- length(data)
    if (n <= 2) { return (list(vec, outliers)) }

    argmin <- which.min(data)
    argmax <- which.max(data)

    x <- data.frame(
        index=c(argmin, argmax),
        value=c(data[argmin], data[argmax]),
        dist=abs(c(data[argmin], data[argmax]) - mean(data)),
        row.names=c("min","max"))

    suspected <- x[which.max(x$dist),]
    if (suspected$dist < sd(data) * tau(n)) {
        return (list(vec, outliers))
    } else {
        return (split_outliers_impl(vec,
                                    c(outliers,suspected$value)))
    }
}
