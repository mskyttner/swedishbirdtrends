#' Turn "thin" bird index data into series spread across columns
#' @param df a dataset formatted like the bundled birdtrends dataset
#' @param species a character vector of species names
#' @return a data frame dplyr style
#' @import dplyr 
#' @importFrom lubridate parse_date_time
#' 
turn <- function(df, species) {
  
  res <- 
    df %>% 
    filter(Arthela %in% species) %>%
    spread(Arthela, Measure) %>%
    select(Year, Series, Vernacular, Measure = one_of(species)) %>%
    spread(Series, Measure) %>%
    mutate(Arthela = species, vernacular = tolower(Vernacular)) %>%
    left_join(birduuids, by = c("vernacular")) %>%
    select(-c(Vernacular, vernacular))
  
  if (!"Vinter" %in% names(res))
    res$Vinter <- NA
  if (!"Sommar "%in% names(res))
    res$Sommar <- NA
  if (!"Standard" %in% names(res))
    res$Standard <- NA
  if (!"Natt" %in% names(res))
    res$Natt <- NA
  rownames(res) <- parse_date_time(paste0(res$Year, "-01-01 00:00:00"), 
    orders = "Y!-m!*-d! H!:M!:S!")
  return (res)  
}

#' Create a dynamic line graph (dygraph) for a specific bird species 
#' @param df a data frame structured like the bundled birdtrends dataset
#' @param caption a character vector of species names
#' @param showgrid boolean flag to indicate whether the graph should use gridlines
#' @import RColorBrewer
#' @importFrom dygraphs dygraph
#' @importFrom dygraphs dySeries
#' @importFrom dygraphs dyOptions
#' @importFrom dygraphs dyHighlight
#' @importFrom dygraphs dyLegend
#' @importFrom dygraphs %>%
#' 
dy <- function(df, caption, showgrid = FALSE) {
  rgb <- brewer.pal(3, "Set1")
  red <- rgb[1]
  blue <- rgb[2]
  green <- rgb[3]
  grays <- brewer.pal(7, "Greys")
  light <- grays[2]
  dark <- grays[6]
  # stringi::stri_escape_unicode("för")
  # stringi::stri_escape_unicode("år")
  res <- 
    dygraph(df, main = caption) %>%
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

#' Plot a trend for a specific Swedish bird species using an dynamic graph 
#' @param species a character vector with the vernacular name of the species
#' @param df optional data frame with bird trend data, defaults to the bundled birdtrends
#' @return a dygraph - dynamic graph
#' @export
#' @examples 
#' plot_sbt_dy("Häger")
plot_sbt_dy <- function(species, df = birdtrends) {
  t <- turn(df, species) %>% select(-c(Year))
  caption <- paste0("Populationstrend för ", 
    trimws(unique(t$Arthela)), ", ", trimws(unique(t$sciname)))
  dy(t %>% select(-c(Arthela, sciname, species_uuid)), caption, FALSE)
}

#' Plot a trend for a specific Swedish bird species using an static graph 
#' @param species a character vector with the vernacular name of the species
#' @param df optional data frame with bird trend data, defaults to the bundled birdtrends
#' @param loess boolean indicating whether to use loess smoothing for the trend
#' @param series a character vector with the routes to include, by 
#' default Winter, Summer, Standard and Night routes
#' @param showlegend boolean to show the color legend, by default TRUE
#' @param theme a ggplot theme from the ggtheme package, by default theme_few()
#' @return a ggplot - static graph
#' @export
#' @importFrom RColorBrewer brewer.pal
#' @import ggthemes
#' @import ggplot2
#' @examples 
#' plot_sbt_static("Häger")
#' plot_sbt_static("Havsörn", loess = TRUE)
#' plot_sbt_static("Duvhök", loess = TRUE, series = "Vinter")

plot_sbt_static <- function(species, df = birdtrends, 
  loess = FALSE, series = c("Vinter", "Sommar", "Standard", "Natt"),
  showlegend = TRUE, theme = theme_few()) {
  
  df <- 
    birdtrends %>% 
    filter(Series %in% series) %>% 
    filter(Arthela == species) %>% 
    select(Year, Measure, Series)
  
  binomen <- 
    birdtrends %>% 
    filter(Arthela == species) %>%
    select(Scientific) %>%
    distinct
  
  rgb <- brewer.pal(3, "Set1")
  red <- rgb[1]
  blue <- rgb[2]
  green <- rgb[3]
  grays <- brewer.pal(7, "Greys")
  light <- grays[2]
  dark <- grays[6]
  
  caption <- paste0("Populationstrend för ", species, ", ",
    trimws(binomen$Scientific[1]))

  red <- RColorBrewer::brewer.pal(3, "PuRd")[3]
  
  p <- 
    ggplot(df) + 
    aes(x = Year, y = Measure, group = Series, colour = Series) + 
    scale_x_discrete(breaks = c(1975, 1985, 1998, 2005, 2015, 2020)) +
    ylab("Index") + xlab("") + ggtitle(caption) +
    geom_point(size = 1.2)
  
  if (loess) p <- p + geom_smooth(method = "loess")
  if (!loess) p <- p + geom_line()
  if (!showlegend) p <- p + guides(colour = FALSE)
  
  p + scale_color_manual(name = "Rutt", values = 
      c("Sommar" = red, "Vinter" = blue, "Standard" = green, "Natt" = dark)) +
    guides(size = FALSE) + theme
  
}
