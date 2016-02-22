library(rvest)
library(httr)
library(readr)
library(readxl)

library(dplyr)
library(purrr)
library(tidyr)
library(lubridate)

library(taxize)
library(imager)

# function to download and resize images for use in vignette
dl_images <- function() {
  cache_img <- function(src, dest, width = 120L) {
    im <- imager::load.image(src)
    a <- height(im) / width(im)
    im <- resize(im, interpolation_type = 2, size_x = width, size_y = round(a * width))
    imager::save.image(im, dest)
    return (data_frame(status = "Processed", src = src, dest = dest))
  }
  images <- textConnection("path, width, url
    fig/logo.png, 240, http://www.fageltaxering.lu.se/sites/default/files/fageltaxering-logo2x.png
    fig/lu.png, 120, http://www.fageltaxering.lu.se/sites/default/files/files/Logotyper/lulogo.jpg
    fig/nv.png, 120, http://www.fageltaxering.lu.se/sites/default/files/files/Logotyper/nv_logo_sv-200.png
    fig/ls.png, 120, http://www.fageltaxering.lu.se/sites/default/files/files/Logotyper/lst_topplogo.gif
    fig/sof.png, 120, http://www.fageltaxering.lu.se/sites/default/files/files/Logotyper/sof_logotyp_birdlife.png
    fig/ebcc.png, 120, http://www.fageltaxering.lu.se/sites/default/files/EBCC-4col_0.gif")
  df <- read.csv(images, stringsAsFactors = FALSE)
  df$dest <- paste0("vignettes/", trimws(df$path))
  df$width <- as.numeric(trimws(df$width))
  df$src <- trimws(df$url)
  print(df)
  res <- df %>% group_by(dest) %>% do(cache_img(.$src, .$dest, .$width))
  return (res)
}

# dl_images()

 
  
 
# repackage xls data and put it into the package
 
base <- "http://www.fageltaxering.lu.se/sites/default/files/"
url <- paste0(base, "files/Data/populationsindex.xls")
logo <- paste0(base, "fageltaxering-logo2x.png")

birds <- "data-raw/populationsindex.xls"
logo_dest <- "www/logo.png"

if (!file.exists(birds))
  download.file(url, destfile = birds)

if (!file.exists(logo_dest))
  download.file(logo, destfile = logo_dest)


read_birds <- function(xls) {
  
  series <- function(x) 
    read_excel(xls, sheet = x)
  
  drop_duplicated_cols <- function(df) 
    df[!duplicated(names(df))]
  
  res <- purrr::map(1:4, function(x) 
    drop_duplicated_cols(series(x)))
  
  return (res)
}

fix_colnames <- function(df) {
  names(df) <- gsub("(\\d{4}).*", "\\1", names(df))
  return (df)
}

sheets <- map(read_birds(birds), fix_colnames)

twist <- function(df) {
  res <- 
    tbl_df(df) %>%
    select(Art, Arthela, matches("\\d{4}")) %>%
    gather(Year, Measure, matches("\\d{4}")) %>%
    mutate(ts = parse_date_time(Year, orders = "%y"))
  return (res)
}

twists <- map(sheets, twist)  

winter <- twists[[1]] %>% mutate(Series = "Vinter")
summer <- twists[[2]] %>% mutate(Series = "Sommar")
standard <- twists[[3]] %>% mutate(Series = "Standard") 
night <- twists[[4]] %>% mutate(Series = "Natt")

birdtrends <- bind_rows(winter, summer, standard, night)

tallyho <- function(df) {
  res <- 
    tbl_df(df) %>%
    select(-matches("\\d{4}"))
  names(res) <- gsub("%Y", "%/Y", names(res))
  if (!("%/Y" %in% names(res))) res$`%/Y` <- NA
  res <- res %>% dplyr::rename(YPctChg = `%/Y`, Significance = S)
  return (res)
}

totals <- map(sheets, tallyho)  

winter <- totals[[1]] %>% mutate(Series = "Vinter")
summer <- totals[[2]] %>% mutate(Series = "Sommar")
standard <- totals[[3]] %>% mutate(Series = "Standard") 
night <- totals[[4]] %>% mutate(Series = "Natt")

re <- "^.*?\\s+(ob.*|kullar|T|P+K+T+|\\(S\\)|\\(N\\))"

birdtotals <- 
  bind_rows(winter, summer, standard, night) %>%
  mutate(Suffix = stringi::stri_match_last_regex(Arthela, re, omit_no_match = FALSE)[,2])

unique(birdtotals$Suffix)

use_data(birdtotals, overwrite = TRUE)

varname <- "birdtrends"
assign(varname, birdtrends)
rdafile <- file.path(getwd(), "data", paste0(varname, ".rda"))
save(list = as.vector(varname), file = rdafile)  

gen_dox_dataset_rows <- function(cols) {
  template <- "#'   \\item{__COL__}{__COL__}"
  res <- sapply(cols, function(x) gsub("__COL__", x, template))
  out <- paste0(collapse = "\n", res)
  message("Paste this into your dataset dox")
  message("in R/refdata.r")
  message(out)
}

gen_dox_dataset_rows(names(birdtotals))

# Generete dox for dataset cols to paste into R/refdata.r
gen_dox_dataset_rows(names(birdtrends))
# Save dataset into R package distro
use_data(internal = FALSE, birdtrends, overwrite = TRUE)
birds_csv <- gsub("xls", "csv", birds)
readr::write_csv(birdtrends %>% filter(Arthela == "Koltrast"), birds_csv)
#df <- readr::read_csv(birds_csv)
#unique(df$Arthela)




# Lookup scientific name based on common name

# get_sci_name_df <- function(x) {
#   res <- unlist(taxize::comm2sci(x))
#   return (data_frame(Arthela = x, SciName = res))
# }
# 
# library(purrr)
# lookup_taxize <- map_df(unique(birdtotals$Arthela), get_sci_name_df) 

db <- src_mysql("taxonpages_v2", "dina-db", 
  user = "dina", password = "*")

lookup_nf <- db %>%  tbl("commonname")

lookup_nf <- 
  collect(lookup_nf) %>%
  tbl_df %>%
  filter(language == "sv_SE") %>% 
  filter(preferred == 1) %>%
  select(taxon_uuid, vernacular = `name`) %>%
  mutate(vernacular = stringi::stri_encode(vernacular, 
    from = "ISO-8859-1", to = "UTF-8"))

library(stringi)
  
sandr <- function(x, y) {
  res <- stri_replace_first_fixed(x, y, replacement = "")
  if (is.na(res)) return (trimws(x))
  return (trimws(res))
}

vernacular <- 
  map2_chr(birdtotals$Arthela, birdtotals$Suffix, 
    function(x, y) sandr(x, y))

birdtotals$Vernacular <- vernacular
library(devtools)
use_data(birdtotals, overwrite = TRUE)
#
species_list <- 
  birdtotals %>% 
  select(Vernacular) %>%
  distinct %>%
  mutate(vernacular = tolower(Vernacular)) %>%
  left_join(lookup_nf)

# species with no matches in the naturalist
species_list %>%
  filter(is.na(taxon_uuid)) %>%
  select(Vernacular)

birdtotals %>%
  mutate(vernacular = tolower(Vernacular)) %>%
  left_join(species_list, by = "vernacular") %>%
  select(-c(Vernacular.y, vernacular)) %>%
  dplyr::rename(Vernacular = Vernacular.x, species_uuid = taxon_uuid)

use_data(birdtotals, overwrite = TRUE)



data(birdtrends)
birdtrends

re <- "^.*?\\s+(ob.*|kullar|T|P+K+T+|\\(S\\)|\\(N\\))"
birdtrends <- 
  birdtrends %>%
  mutate(Suffix = stringi::stri_match_last_regex(Arthela, re, omit_no_match = FALSE)[,2])

vernacular <- 
  map2_chr(birdtrends$Arthela, birdtrends$Suffix, 
           function(x, y) sandr(x, y))

birdtrends$Vernacular <- vernacular

species_list <- 
  birdtrends %>% 
  select(Vernacular) %>%
  distinct %>%
  mutate(vernacular = tolower(Vernacular)) %>%
  left_join(lookup_nf) %>% 
  select(vernacular, species_uuid = taxon_uuid)

birdtrends <- 
  birdtrends %>%
  mutate(vernacular = tolower(Vernacular)) %>%
  select(-Vernacular) %>%
  inner_join(unique(species_list), by = c("vernacular"))

birdtrends %>% filter(is.na(species_uuid))

use_data(birdtrends, overwrite = TRUE)


# resolving identifiers

birduuids <- 
  lookup_nf %>%
  dplyr::rename(species_uuid = taxon_uuid)

use_data(birduuids, overwrite = TRUE)

birdtotals
birdtrends

gen_dox_dataset_rows <- function(cols) {
  template <- "#'   \\item{__COL__}{__COL__}"
  res <- sapply(cols, function(x) gsub("__COL__", x, template))
  out <- paste0(collapse = "\n", res)
  message("Paste this into your dataset dox")
  message("in R/refdata.r")
  message(out)
}

gen_dox_dataset_rows(names(birdtotals))
gen_dox_dataset_rows(names(birdtrends))
gen_dox_dataset_rows(names(birduuids))

# test

library(dplyr)
library(swedishbirdtrends)

blacklist <- c(
  "Korsnäbb","Vaktel","Igelkott", "Fälthare", "Rödräv", 
  "Grävling", "Älg", "Rådjur", "Kronhjort", "Dovhjort",
  "Vildkanin", "Vildsvin"
)

birdtrends <- 
  birdtrends %>%
  filter(!Vernacular %in% blacklist)

birdtotals <- 
  birdtotals %>%
  filter(!Vernacular %in% blacklist)

birduuids <- 
  birduuids %>%
  filter(!vernacular %in% tolower(blacklist)) %>%
  filter(!is.na(species_uuid))

library(devtools)
use_data(birduuids, overwrite = TRUE)
use_data(birdtotals, overwrite = TRUE)
use_data(birdtrends, overwrite = TRUE)
tools::resaveRdaFiles("data")
tools::checkRdaFiles("data")
