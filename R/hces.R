

## Function to preprocess HCES data.

## MoSPI provides data in various DDI compliant formats. For now, we
## will focus on the .SAV (SPSS) files as these can be easily
## converted to R data frames (via foreign::read.spss)


## Data formats and details can change in different cycles, so we may
## need to adjust code accordingly. For now, the approach is as follows:

## - HCES data come in different files (named by LEVEL)

## - Each file duplicates the information about survey design

## - We will take the following approach:
##
##     * Load each file
##     * Create and add a unique household identifier
##     * Optionally drop some columns

## The columns to keep / drop should be specified manually via `keep`
## / `drop` arguments, to be manually specified. This is to keep
## flexibility across cycles.



## Make a unique household identifier --- check whether this works
## universally.


make_hces_hh_id <- function(data)
{
  to_string <- function(s, format) {
    trimws(s) |> as.numeric() |> sprintf(fmt = format)
  }
  with(data,
       sprintf("%s%s-%s-%s%s", 
               Survey_Name, Year,
               to_string(FSU_Serial_No, "%05d"), 
               to_string(Second_Stage_Stratum_No, "%01d"), 
               to_string(Sample_Household_No, "%02d")))
}

read_hces_sav <- function(file, keep = NULL, drop = NULL)
{
    use_keep <- !missing(keep)
    use_drop <- !missing(drop)
    if (use_keep && use_drop)
        stop("At most one of 'keep' and 'drop' may be specified")
    d <- read.spss(file, to.data.frame = TRUE)
    hhid <- make_hces_hh_id(d)
    cols <- names(d)
    keep <-
        if (!use_keep && use_drop) {
            cols[!(cols %in% drop)]
        }
        else keep %||% TRUE
    if (!isTRUE(keep))
        stopifnot("Unknown columns requested" = all(keep %in% cols))
    cbind(HHID = hhid, d[, keep])
}

## Columns that should be kept in LEVEL 1 and dropped for other files

HCES_2324_survey_vars <- 
    c("Survey_Name", "Year", "FSU_Serial_No", "Sector", "State", 
      "NSS_Region", "District", "Stratum", "Sub_stratum", "Panel", 
      "Sub_sample", "FOD_Sub_Region", "Sample_SU_No", "Sample_Sub_Division_No", 
      "Second_Stage_Stratum_No", "Sample_Household_No", 
      "Multiplier")


