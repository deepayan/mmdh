

## Extract state / district / subdistrict level data for census 2011 from Table A-01

A1 <- read.csv("census2011_A01_all.csv") # exported from XLSX available at <https://censusindia.gov.in/nada/index.php/catalog/42526>

for (v in names(A1)) if (is.character(A1[[v]])) A1[[v]] <- trimws(A1[[v]])

## Some district / subdistrict names are tagged with note marked by
## one or more '#', '*", '^' etc --- In addition to giving wrong
## names, the first one triggers errors because # is a comment
## character. We will remove them. There are other such notes --- the
## ones for India and are Jammu and Kashmir (Total) are retained.

dropChar <- function(x, s) gsub(s, "", x, fixed = TRUE)
A1$Name <- A1$Name |> dropChar("#")  |> dropChar("*")  |> dropChar("^") |> trimws()
A1$Name <- gsub("\n", " ", A1$Name) # remove embedded newlines


fixComma <- function(x) gsub(",", "", x, fixed = TRUE) |> as.numeric()

A1fixed <-
    within(A1,
           {
               VillagesInhabited <- fixComma(VillagesInhabited)
               VillagesUninhabited <- fixComma(VillagesUninhabited)
               Towns <- fixComma(Towns)
               Households <- fixComma(Households)
               PopTotal <- fixComma(PopTotal)
               PopMale <- fixComma(PopMale)
               PopFemale <- fixComma(PopFemale)
               AreaSqKm <- fixComma(AreaSqKm)
               PopPerSqKm <- fixComma(PopPerSqKm)
           })

table(A1fixed$Level)



get_subset <- function(L) {
    subset(A1fixed, Level == L)
}
        
A1_sub <- sapply(c("INDIA", "STATE", "DISTRICT", "SUB-DISTRICT"),
                 get_subset, simplify = FALSE)

export_csv <- function(x, file) write.csv(x, file = file, quote = FALSE, row.names = FALSE)

export_csv(A1_sub[["INDIA"]],        file = "census2011A01_India.csv")
export_csv(A1_sub[["STATE"]],        file = "census2011A01_State.csv")
export_csv(A1_sub[["DISTRICT"]],     file = "census2011A01_District.csv")
export_csv(A1_sub[["SUB-DISTRICT"]], file = "census2011A01_Subdistrict.csv")


## State + District + Subdistrict Codes. Use Rural subset to avoid
## duplicates (Note: 'Total' for J&K has a note)

subset(A1_sub[["STATE"]], Type == "Rural", select = c(StateCode, Name)) |> export_csv(file = "census2011_StateCodes.csv")
subset(A1_sub[["DISTRICT"]], Type == "Rural", select = c(StateCode, DistrictCode, Name)) |> export_csv(file = "census2011_DistrictCodes.csv")
subset(A1_sub[["SUB-DISTRICT"]], Type == "Rural", select = c(StateCode, DistrictCode, SubDistrictCode, Name)) |> export_csv(file = "census2011_SubdistrictCodes.csv")


