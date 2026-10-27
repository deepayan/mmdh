## utilities to read CSV files with various customiations

## read CSV file named <var>.csv and assign to binding <var>

csv2var <- function(var, ...) {
    file <- paste0(var, ".csv")
    read.csv(file, ...) |> assign(x = var, pos = parent.frame())
}


## NSS region definitions are available as PDF tables that are
## difficult to parse; some initial manual editing has been used to
## insert commas and remove redundant whitespace, but some columns
## (mainly state) still span multiple rows. These are handled here
## rather than being edited manually.

fillPrev <- function(x) {
    if (is.character(x)) x[x == ""] <- NA
    for (i in seq_along(x)[-1]) {
        if (is.na(x[[i]])) x[[i]] <- x[[i-1]]
    }
    x
}

combineStrings <- function(dsub, vars) {
    ## s is either a non-empty character vector ending in (code), or a
    ## vector of empty strings

    for (v in vars) {
        x <- paste(trimws(dsub[[v]]),
                   collapse = " ") |> trimws()
        dsub[[v]] <- x
    }
    dsub
}

separateStateUT_Code <- function(s) {
    stopifnot(all(endsWith(s, ")")))
    parts <-
        gsub(")", "", s, fixed = TRUE) |>
        strsplit(split = "(", fixed = TRUE)
    data.frame(StateUT = sapply(parts, "[[", 1),
               StateUTCode = sapply(parts, "[[", 2))
}


nssCleanup <- function(file, ...) {

    d <- read.csv(file, ...)

    d <-
        within(d,
               {
                   NR_no <- fillPrev(NR_no)
                   NSS_Region_code <- fillPrev(NSS_Region_code)
               })

    s <- split(d, ~ NSS_Region_code)
    u <- do.call(rbind,
                 lapply(s, combineStrings,
                        vars = c("StateUT_with_code", "description")))

    u <-
        within(u,
               {
                   StateUT_with_code <- fillPrev(StateUT_with_code)
                   description <- fillPrev(description)
               })

    ## finally, split StateUT_with_code ino StateUT and code

    stcode <- separateStateUT_Code(u$StateUT_with_code)

    dfinal <- cbind(u, stcode) |> sort_by(~ NR_no + dist_no)
    rownames(dfinal) <- NULL

    keep <- 
        c("NR_no", "NSS_Region_code", "StateUT", "StateUTCode",
          "description", "district", "district_code")

    dfinal[keep]
}


nss2var <- function(var, ...) {
    file <- paste0(var, ".csv")
    nssCleanup(file, ...) |> assign(x = var, pos = parent.frame())
}

