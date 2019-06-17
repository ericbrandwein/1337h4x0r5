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


find_ip_index <- function(ip_num, ip_database) {
    stopifnot(is.numeric(ip_num))
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

get_ip_table <- function(ips_strings,  ip_database) {
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


