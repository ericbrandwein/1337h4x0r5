ip_to_num <- function(ip_string) {
    stopifnot(length(ip_string) == 1 && "character" %in% class(ip_string))
    nums <- as.numeric(strsplit(ip_string, ".", fixed=T)[[1]])
    stopifnot(length(nums) == 4)
    stopifnot(all(nums < 256))
    res <- nums[1] * 2^24 + nums[2] * 2^16 + nums[3] * 256 + nums[4]
    res
}

get_ip_database <- function(data_dirname) {
    filename <- file.path(normalizePath(data_dirname), "IpToCountry.csv")
    data=read.csv(filename, skip=328, header=FALSE)
    names(data) <- c("ip.from", "ip.to", "registry", "assigned", "ctry", "cntry", "country")
    data
}

find_ip <- function(ip_num, ip_database) {
    stopifnot(is.numeric(ip_num))
    row <- ip_database$ip.from <= ip_num & ip_num <= ip_database$ip.to
    ip_database[row, ]
}

find_ip_index <- function(ips, ips_ranges) UseMethod("find_ip_index")
find_ip_index.character <- function(ips, ips_ranges) {
    find_ip_index(sapply(ips, ip_to_num), ips_ranges)
    ##sapply(ips, function(ips) find_ip_index(ip_to_num(ips), ips_ranges))
    ##sapply(data, functionfind_ip_index (ip_to_num (data))
}
find_ip_index.numeric <- function(ip_num, ip_database) {
    sapply(ip_num, function(ip) find_single_ip_index(ip, ip_database))
}
find_single_ip_index <- function(ip_num, ip_database) {
    stopifnot(length(ip_num) == 1)
        row <- ip_database$ip.from < ip_num & ip_num < ip_database$ip.to
    row <- which(row)
    if (length(row) == 0) {
        row <- 0
    } else if (length(row) > 1) {
        for (x in row) {
            cat("matched: ", x, " ")
        }
        cat("\n")
        row <- row[1]
    }
    row

}
create_ip_table <- function(ips_strings,  ip_database) {
    #ips <- sapply(ips_strings, ip_to_num)
    res <- data.frame()
    for (ip_str in ips_strings) {
        ip <- ip_to_num(ip_str)
        row <- find_ip(ip, ip_database)
        if (length(row) == 0) {
            stop("remove unknown ips")
        }
        row$dst <- ip_str
        res <- rbind(res, row)
    }
    res
}

get_geolite2_data <- function (data_dirname) {
    filename <- file.path(normalizePath(data_dirname), "GeoLite2-City-CSV_20190618/GeoLite2-City-Blocks-IPv4.csv")
    data=read.csv(filename, stringsAsFactors=FALSE)
    data
}

#' Esta funcion tarda mucho, pero es solo para una vez
create_geolite2_data_resumen <- function(ips_database, ips) {
    UseMethod("create_geolite2_data_resumen")
}
create_geolite2_data_resumen.character <- function(ips_database, ips) {
    ## ips_database es el nombre de ./data :)
    create_geolite2_data_resumen (get_geolite2_data(ips_database), ips)
}

create_geolite2_data_resumen.data.frame <- function(geolite2, ips) {

    ip.ranges <- network_to_range(geolite2$network)
    ip.indexes <- find_ip_index(ips, ip.ranges)
    stopifnot(length(ips) == length(ip.indexes))
    ##return(ip.indexes)
    res <- data.frame()
    geo.cols <- geolite2[c("latitude","longitude")]
    #geo.cols[ip.indexes,]
    for (i in 1:length(ips)) {
        index <- ip.indexes[i]
        row <- geo.cols[index,]
        if (nrow(row) == 0) {
            cat(ips[i], " not found\n")
            next 
        } 
        res <- rbind(res, cbind(ips[i], row, index))
    }
    names(res) <- c("dst","latitud","longitud", "index")
    cat ("encontramos ", nrow(res), " ips.\n")
    res
}

get_geolite2_data_resumen <- function (data_dirname) {
    filename <- file.path(normalizePath(data_dirname))
    data=read.csv(filename)
    data[c("dst", "latitud", "longitud")]
}

network_to_range <- function(networks) {
    net_mask <- strsplit(networks, "/", fixed=TRUE)
    qss <- lapply(net_mask, function(x) as.integer(unlist(strsplit(x[[1]], ".", fixed=TRUE))))
    foo <- function(qs) qs[1] * 2^24 + qs[2] * 2^16 + qs[3] * 256 + qs[4]
    ipfrom <- unlist(lapply(qss, foo))

    ipto <- unlist(lapply(net_mask, function(x) as.integer(x[[2]])))
    ipto <- 2 ^ (32 - ipto)
    ipto <- ipfrom + ipto
    as.data.frame(cbind(ip.from=unlist(ipfrom), ip.to=ipto))
}


