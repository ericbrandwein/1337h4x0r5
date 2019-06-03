#' rtt_medios
#' 
#' param: data.frame
#' el parametro se obiene con
#' > read.csv("google.csv")
#'
#' value: data.frame con los ip_addr destinos, su ttl y rtt
#' promedio
#'
#' ejemplo:
#' > source("read-data.R")
#' > x <- read.csv("../data/kyoto.csv")
#' > rtt_medios(x)
rtt_medios <- function(data) {
    res <- aggregate(list(z$rtt, z$ttl), by=list(z$dst), mean)
    names(res)  <- c("dst", "mean.rtt","ttl")
    res <- res[order(res$ttl),]
    res[c("dst", "ttl","mean.rtt")]
}
