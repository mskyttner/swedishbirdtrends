
# add 4 missings to birdsuuids
v_id <- 
  birdtotals %>% 
  mutate(vernacular = tolower(Vernacular)) %>%
  select(vernacular) %>%
  distinct %>%
  left_join(birduuids) %>%
  group_by(vernacular) %>% 
  mutate(c = n_distinct(species_uuid)) %>%
  select(vernacular, c, species_uuid) 

# missing matches visavi naturalist
mism <- 
  data_frame(vernacular = 
  c("häger", "glada", "tretåspett", "korsnäbb"),
  species_uuid = c(
    "cfbdf0ed-f1f1-43c6-861a-c7af76974575", 
    "32a75e1a-2883-4085-b5fb-0a94a05babc3", 
    "f2320045-0a13-48da-ad94-d5b0e03e08ae", 
    "29ea65e8-b51f-4ad1-a043-526a1fda8cf7"))

# trädkrypare och kronhjort har dubletter
mism2 <- data_frame(vernacular = 
  c("trädkrypare", "kronhjort"),
  species_uuid = c(
    "ca705247-321a-46fd-a645-4887435bcf1d",
    "ab79af60-217d-48a7-a094-ac08a9ea8522"))


naturalist_lookup <- bind_rows(mism, mism2,
    v_id %>% filter(c == 1 && !is.na(species_uuid)))

library(rvest)

nf_sciname <- function(vernacular) {

  term <- trimws(vernacular)

  lu <- naturalist_lookup %>%
    filter(vernacular == tolower(term)) %>%
    select(species_uuid)

  if (!nrow(lu) >= 1) return (NA)
  
  uuid <- rev(lu$species_uuid)[1]
  base <- "https://dina-web.net/naturalist/species/"
  url <- paste0(base, uuid)
  htm <- read_html(url) 
  
  scrape <- htm %>% html_nodes(xpath = 
    "//div//h4[text()='Klassificering']//..//ul/li")

  res <- grep("Art: ", scrape, value = TRUE)
  re <- ".*?Art:\\s+<em>(.*?)</em>.*"
  out <- gsub(re, "\\1", res)
  return (out)
}

library(purrr)
v <- unique(lu$vernacular)
s <- map_chr(v, nf_sciname)

lus <- data_frame(vernacular = v, sciname = s)

birduuids <- 
  lus %>%
  inner_join(naturalist_lookup) %>% 
  select(-c)

btr <- 
  birdtrends %>% 
  mutate(vernacular = tolower(Vernacular)) %>%
  left_join(birduuids) %>%
  select(-c(vernacular,species_uuid)) %>%
  rename(Scientific = sciname)

bto <- 
  birdtotals %>% 
  mutate(vernacular = tolower(Vernacular)) %>%
  left_join(birduuids) %>%
  select(-c(vernacular,species_uuid)) %>%
  rename(Scientific = sciname)

  
library(devtools)
use_data(birduuids, overwrite = TRUE)
birdtrends <- btr
use_data(birdtrends, overwrite = TRUE)
birdtotals <- bto
use_data(birdtotals, overwrite = TRUE)
tools::resaveRdaFiles("data")
tools::checkRdaFiles("data")

birdtotals
birdtrends
birduuids
