## -*- mode:r -*-

source("outliers.R")
get_ips_table <- function(filename = NULL) {
    if (is.null(filename)) { filename = "../data/ip-location.csv" }
    read.csv(filename, stringsAsFactors=FALSE)
}


get_table <-  function(filename, ips_table = NULL, first_hop = 1) {
    stopifnot(!is.null(ips_table))
    data <- read_trace_data(filename)
    rtt_medios(data, ips_table, first_hop)
}

get_trace_tables <- function(data_dirname, first_hop = 1) {
    stopifnot(!is.null(data_dirname))
    dirname <- normalizePath(data_dirname)
    tables_dirname <- file.path(dirname, "scapy-traceroute/muestra")
    ips_table <- get_ips_table(file.path(dirname, "ip-location.csv"))

    trace_tables_fnames <- list.files(tables_dirname, pattern="csv$",
                         full.names=TRUE)

    res <- lapply(trace_tables_fnames, function(fnames)
        get_table(fnames, ips_table, first_hop))
    
    names(res) <- sapply(trace_tables_fnames, function(x) {
        gsub("-", ".", basename(tools::file_path_sans_ext(x)))
    })
    res
}



get_raw_tables <- function(dirname) {
    stopifnot(!is.null(dirname))
    
    tables <- list.files(dirname, pattern="csv$", full.names=TRUE)
    read.csv.na.rm <- function(filename) {
        x <- read.csv(filename)
        x[complete.cases(x),]
    }

    res <- lapply(tables, read.csv.na.rm)
    foo <- function(x) {
        gsub("-", ".", basename(tools::file_path_sans_ext(x)))
    }
    names(res) <- sapply(tables, foo)

    res
}
