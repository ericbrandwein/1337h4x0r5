## se usa asi:
## >>> x  <- read__sniff("../datos/casa-de-erick")
## >>> tablita <- frecs(x)
## >>> head(talita, 30)


read_sniff <- function (filename) {
    sniff <- read.csv(filename, stringsAsFactors= FALSE)
    sniff
}

frecs <- function(sniff) {
    ips <- unique(c(sniff$source, sniff$destination))
    n <- nrow(sniff) * 2
    frecs <- sapply(ips, function(ip) {
        (sum(sniff$destination == ip) + sum(sniff$source == ip)) / n
    })
    
    infos <- log2(1/frecs)
    cbind (frecs, infos)
}
