duplicated_hops <- function(data) {

    foo <- function(dst) {
        x <- data[data$dst == dst,]
        !all(x$ttl[1] == x$ttl)
    }
    any(sapply(unique(data$ttl), foo))
}


ips_vector <- function(data) {
    unique(unlist(lapply(data, function(x) levels(x$dst))))
}
