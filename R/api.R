
BASE_URL <- "https://microdata.gov.in/NADA/index.php/api"
MAX_RETRIES <- 5
RETRY_DELAY <- 5 # seconds

set_api_key <- function(key)
{
    Sys.setenv("MOSPI_API_KEY" = key)
}

add_key <- function(x, key)
{
    if (nzchar(key)) req_headers(x, "X-API-KEY" = api_key)
    else x
}

#' Make an HTTP request with automatic retry on 401/5xx errors
.request_with_retry <- function(req) {
    ## Configure retries matching Python's exponential backoff-ish behavior
    ## httr2 handles 429 and 5xx by default, we add 401 to the transient status codes
    req |> 
        req_retry(
            max_tries = MAX_RETRIES,
            backoff = function(attempt) RETRY_DELAY * attempt,
            is_transient = function(resp) {
                resp_status(resp) %in% c(401, 429, 500, 502, 503, 504)
            }
        ) |> 
        req_perform()
}

#' Fetch a single page of datasets from the API
.fetch_page <- function(api_key, page) {
    req <- request(paste0(BASE_URL, "/listdatasets")) |>
        req_headers("X-API-KEY" = api_key) |>
        req_url_query(page = page)
    
    tryCatch({
        resp <- .request_with_retry(req)
        resp_check_status(resp) 
        return(resp_body_json(resp))
    }, error = function(e) {
        message(paste("Error fetching dataset list:", e$message))
        return(NULL)
    })
}


dataset2df <- function(x, na.string = "") {
    n <- sapply(x, length)
    if (any(n > 1)) stop("Expected 1 row, found ", max(n))
    for (i in which(n == 0))
        x[[i]] <- na.string
    list2DF(x)
}


#' List datasets from the MoSPI Microdata Portal
list_datasets <-
    function(page = NULL, na.string = "", as_data_frame = TRUE,
             api_key = Sys.getenv("MOSPI_API_KEY"))
{
    if (!is.null(page)) {
        data <- .fetch_page(api_key, page)
        if (is.null(data)) return(NULL)
        rows <- data$result$rows
    }
    else {
        first_page <- .fetch_page(api_key, 1)
        if (is.null(first_page)) return(NULL)
        
        result <- first_page$result
        rows <- result$rows
        total <- as.integer(result$total)
        limit <- as.integer(result$limit)
        pages <- (total %/% limit) + if (total %% limit > 0) 1 else 0
        
        for (p in seq_len(pages-1)) {
            data <- .fetch_page(api_key, p + 1)
            if (is.null(data)) break
            rows <- c(rows, data$result$rows)
        }
    }

    rows <- lapply(rows, dataset2df, na.string = na.string)
    if (as_data_frame) rows <- do.call(rbind, rows)
    attr(rows, "info") <- list(total = total, limit = limit)
    return(rows)
}

#' List files available for a specific dataset
list_files <-
    function(id, na.string = "", as_data_frame = TRUE,
             api_key = Sys.getenv("MOSPI_API_KEY"))
{
    url <- paste0(BASE_URL, "/datasets/", id, "/fileslist")
    req <- request(url) |> req_headers("X-API-KEY" = api_key)
    
    tryCatch({
        resp <- .request_with_retry(req)
        resp_check_status(resp)
        data <- resp_body_json(resp)
        rows <- data$files %||% list()
    }, error = function(e) {
        message(paste0("Error fetching file list for '", id, "': ", e$message))
        return(NULL)
    })
    if (!length(rows)) return(NULL)
    rows <- lapply(rows, dataset2df, na.string = na.string)
    if (as_data_frame) rows <- do.call(rbind, rows)
    rows
}

#' Download a single file from a dataset
download_file <-
    function(id, base64,
             destfile, destfolder = ".",
             api_key = Sys.getenv("MOSPI_API_KEY"))
{
    url <- paste0(BASE_URL, "/fileslist/download/", id, "/", base64)
    if (identical(destfile, basename(destfile))) { # use destfolder
        destfile <- file.path(destfolder, destfile)
    }
    else {
        destfolder <- dirname(destfile)
    }
    dir.create(destfolder, showWarnings = FALSE, recursive = TRUE)
    req <- request(url) |> req_headers("X-API-KEY" = api_key)
    
    tryCatch({
        ## Directly stream the download to disk
        resp <- req |> 
            req_retry(
                max_tries = MAX_RETRIES,
                backoff = function(attempt) RETRY_DELAY * attempt
            ) |> 
            req_perform(path = destfile)
        
        message(paste("Downloaded:", destfile))
        return(destfile)
    }, error = function(e) {
        message(paste0("Error downloading target with base64='", base64, "': ", e$message))
        return(NULL)
    })
}


