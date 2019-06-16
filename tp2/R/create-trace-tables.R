## -*- mode:r -*-

source("outliers.R")

get_table <-  function(filename) {
    data <- read_trace_data(filename)
    rtt_medios(data)
}

get_trace_tables <- function(dirname) {
    stopifnot(!is.null(dirname))
    
    tables <- list.files(dirname, pattern="csv$", full.names=TRUE)
    res <- lapply(tables, get_table)
    foo <- function(x) {
        gsub("-", ".", basename(tools::file_path_sans_ext(x)))
    }
    names(res) <- sapply(tables, foo)
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
