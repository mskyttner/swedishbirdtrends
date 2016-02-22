params <-
structure(list(species = "Koltrast"), .Names = "species")

## ---- message=FALSE, warning=FALSE, results='asis', echo=FALSE, fig.width=7----
library(swedishbirdtrends)
species <- params$species
uuid <- birduuids %>% filter(vernacular == tolower(species))
url <- paste0("http://naturforskaren.se/species/", uuid$species_uuid)
binomen <- uuid$sciname
sft <- "http://www.fageltaxering.lu.se"
totals <- 
  birdtotals %>% 
  filter(Vernacular == species) #%>% 
#  dplyr::select(`%/År` = YPctChg, Signifikansnivå =	Significance, Rutt =	Series)
chg <- paste0(sprintf("%+2.1f - %+2.1f", min(totals$YPctChg), max(totals$YPctChg)), "%")
images <- get_nf_media_urls(binomen)
map <- paste0("https://dina-web.net/naturalist/map/getsmall/", uuid$species_uuid, "/raster.png")

## ---- fig.margin = TRUE, echo=FALSE, fig.cap=binomen---------------------
if (length(images) >= 1) plot_image_url(images[1], 240)

## ---- echo=FALSE---------------------------------------------------------
if (length(images) >= 2) plot_image_url(images[2], 240)

## ---- message=FALSE, warning=FALSE, results='asis', echo=FALSE-----------
#knitr::kable(totals, caption = 'Trendförändring')

## ---- fig.margin=TRUE, message=FALSE, warning=FALSE, results='asis', echo=FALSE----
#plot_image_url(map, 240)

## ---- message=FALSE, warning=FALSE, results='asis', echo=FALSE-----------
plot_sbt_static(species, loess = TRUE, showlegend = TRUE, theme = theme_solarized())

## ---- message=FALSE, warning=FALSE, results='asis', echo=FALSE, fig.width=7----
plot_sbt_static(species, loess = TRUE, series = "Vinter", showlegend = FALSE, theme = theme_solarized())

## ---- message=FALSE, warning=FALSE, results='asis', echo=FALSE, fig.width=7----
plot_sbt_static(species, loess = TRUE, series = "Sommar", showlegend = FALSE, theme = theme_solarized_2())

## ---- message=FALSE, warning=FALSE, results='asis', echo=FALSE, fig.fullwidth=TRUE----
if ("Measure" %in% names(species)) plot_sbt_dy(species)

