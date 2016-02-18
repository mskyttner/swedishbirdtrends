#' Turn "thin" bird index data into series spread across columns
#' @param df a dataset formatted like the bundled birdtrends dataset
#' @param species a character vector of species names
#' @return a data frame dplyr style
#' @export
#' @import dplyr lubridate
turn <- function(df, species) {
  
  res <- df %>% 
    filter(Arthela %in% species) %>%
    spread(Arthela, Measure) %>%
    select(Year, Series, Measure = matches(species)) %>%
    spread(Series, Measure) %>%
    mutate(Arthela = species)
  
  if (!"Vinter" %in% names(res))
    res$Vinter <- NA
  if (!"Sommar "%in% names(res))
    res$Sommar <- NA
  if (!"Standard" %in% names(res))
    res$Standard <- NA
  if (!"Natt" %in% names(res))
    res$Natt <- NA
  rownames(res) <- parse_date(paste0(res$Year, "-01-01"))
  return (res)  
}

#' Create a dynamic line graph (dygraph) for a specific bird species 
#' @param df a data frame structured like the bundled birdtrends dataset
#' @param species a character vector of species names
#' @param showgrid boolean flag to indicate whether the graph should use gridlines
#' @export
#' @import RColorBrewer dygraphs
dy <- function(df, species, showgrid = FALSE) {
  rgb <- brewer.pal(3, "Set1")
  red <- rgb[1]
  blue <- rgb[2]
  green <- rgb[3]
  grays <- brewer.pal(7, "Greys")
  light <- grays[2]
  dark <- grays[6]
  res <- 
    dygraph(df, main = paste0("Populationsindex för ", species)) %>%
    # , ylab = "Index"
    #dyRangeSelector() %>%
    dySeries("Sommar", strokeWidth = 2, color = red) %>%
    dySeries("Vinter", strokeWidth = 2, color = blue) %>%
    dySeries("Natt", strokeWidth = 2, color = dark) %>%
    dySeries("Standard", strokeWidth = 2, color = green) %>%
    dyOptions(gridLineColor = light) %>%
    dyHighlight(highlightCircleSize = 5, 
      highlightSeriesBackgroundAlpha = 0.4) %>%
    dyOptions(drawGrid = showgrid) %>%   
    dyOptions(drawPoints = TRUE, pointSize = 3) %>%
    #dyEvent("1998-01-01", "Basår för index", labelLoc = "bottom", color = grays[3]) %>%
    dyLegend(width = 400)
  return (res)  
}


