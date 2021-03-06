source("locate-ip.R")
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

remove_lost_traces <- function(data) {

    for (ip in levels(data$dst)) {
        min_ttl <- min(data[data$dst == ip,]$ttl)
        max_ttl <- max(data[data$dst == ip,]$ttl)
        if (min_ttl == max_ttl) { next }
        excluded <- (data$dst == ip) & (data$ttl > min_ttl)
        data <- data[!excluded,]
    }
    data
}

read_trace_data <- function(filename) {
    x <- read.csv(filename)
    x <- x[complete.cases(x),]
    remove_lost_traces(x)
    
}

mean_rtt_to_delta <- function(data) {
    data <- data[order(data$ttl),]
    . <- c(0, data$mean.rtt[1:(nrow(data) - 1)])
    data$mean.rtt - .
}

rtt_medios <- function(data, first_hop = 1, FUN = mean) {
    
    res <- aggregate(list(data$rtt, data$ttl), by=list(data$dst), FUN)
    names(res)  <- c("dst", "mean.rtt","ttl")
    res <- res[order(res$ttl),]
    rownames(res) <- 1:nrow(res)
    res <- res[c("dst", "ttl","mean.rtt")]

    res$deltas <- mean_rtt_to_delta(res)
    res$deltas[res$deltas < 0] <- 0
 
    if (first_hop > 1) { res <- res[first_hop:nrow(res), ] }
 
    outs <- split_outliers(res$deltas)
    res$outlier <- res$deltas %in% outs$outliers
    class(res) <- c("rtt_medios", class(res))

    row.names(res) <- 1:nrow(res)
    res
}

add_ips_locations <- function(data, ips_table = NULL) {
    stopifnot(!is.null(ips_table))
    res <- merge(data, ips_table, by.x="dst", by.y="Host", all.x = TRUE)
    res[order(res$ttl),]
}


add_other_ips_locations <- function(data, ips_table = NULL) {
    stopifnot(!is.null(ips_table))
    res <- merge(data, ips_table, by="dst",  all.x = TRUE)
    res[order(res$ttl),]

}



#' simple plot:
#' data <- read.csv("mi tabla.csv")
#' x <- rtt_medios(data)
#' plot (x$deltas, type="l")

## create_table <- function(filename) {
##     data <- read_trace_data(filename)
##     out <- rtt_medios(data)
##     out.filename <- paste(tools::file_path_sans_ext(filename), "trace-table", sep=".")
##     write.table(out, file=out.filename)
##     cat(out.filename, " created")
## }

split_outliers <- function(data) {
    stopifnot(is.vector(data))
    zeros <- data < 0
    data[zeros] <- 0
    res <- split_outliers_impl (data)
    names(res) <- c("data", "outliers")
    res
}


split_outliers_impl <- function(vec, outliers=c()) {
    data <- vec[which(0 < vec)]
    n <- length(data)
    if (n <= 2) { return (list(data, outliers)) }

    argmin <- which.min(data)
    argmax <- which.max(data)

    x <- data.frame(
        index=c(argmin, argmax),
        value=c(data[argmin], data[argmax]),
        dist=abs(c(data[argmin], data[argmax]) - mean(data)),
        row.names=c("min","max"))

    suspected <- x[which.max(x$dist),]
    if (suspected$dist < sd(data) * tau(n)) {
        return (list(data, outliers))
    } else {
        return (split_outliers_impl(data[-suspected$index],
                                    c(outliers,suspected$value)))
    }
}

count_outliers <- function(data) { sum(data$outlier) }
