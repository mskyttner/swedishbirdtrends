## ---- message=FALSE, warning=FALSE---------------------------------------
suppressPackageStartupMessages(library(swedishbirdtrends))
data(birdtotals)
data(birdtrends)


## ---- message=FALSE, warning=FALSE---------------------------------------
library(dplyr)

# filter columns on one or multiple values
birds <- 
  birdtotals %>% 
  filter(Series == "Standard") %>%
  filter(Significance %in% c("*", "**", "***")) 

# renaming columns
trends <-
  birdtrends %>%
  select(Art = Arthela, Year, Index = Measure, Rutt = Series)


## ---- echo=FALSE, results='asis'-----------------------------------------
knitr::kable(birds %>% head(5))

## ---- echo=FALSE, results='asis'-----------------------------------------
knitr::kable(trends %>% head(5))

## ------------------------------------------------------------------------
# find the top 20 "winners" and "losers"
winners <- 
  birds %>%
  filter(YPctChg > 0) %>%
  arrange(desc(YPctChg)) %>%
  select(Art = Arthela, YPctChg, Ind, Significance) %>%
  head(10)

losers <- 
  birds %>%
  filter(YPctChg <= 0) %>%
  arrange(-desc(YPctChg)) %>%
  select(Art = Arthela, YPctChg, Ind, Significance) %>%
  head(10)


## ---- echo=FALSE, results='asis'-----------------------------------------
knitr::kable(winners %>% head(5))

## ---- echo=FALSE, results='asis'-----------------------------------------
knitr::kable(losers %>% head(5))

## ---- fig.show='hold', `fig.cap = "Swedish bird population trends"`------

library(ggplot2)
library(ggthemes)

plot_w <- 
  ggplot(winners) +
  aes(x = reorder(Art, YPctChg), y = YPctChg) +
  geom_bar(stat = "identity") +
  labs(x = "") + labs(y = "% förändr per år") +
  theme_economist_white() +
  coord_flip()

plot_l <- 
  ggplot(losers) +
  aes(x = reorder(Art, YPctChg), y = YPctChg) +
  geom_bar(stat = "identity") +
  labs(x = "") + labs(y = "% förändr per år") +
  theme_wsj() +
  coord_flip()


## ---- fig.show='hold', warning=FALSE-------------------------------------
plot_w
plot_l

## ---- fig.show='hold', fig.width=7, warning=FALSE------------------------

glada <- 
  birdtrends %>% 
  filter(Series == "Vinter") %>% 
  filter(Arthela == "Glada") %>% 
  select(Year, Measure, Series)

koltrast <- 
  birdtrends %>% 
  filter(Series == "Vinter") %>% 
  filter(Arthela == "Koltrast") %>% 
  select(Year, Measure, Series)

red <- RColorBrewer::brewer.pal(3, "PuRd")[3]

plot_trend <- function(df, title) {
  ggplot(df) + 
    aes(x = Year, y = Measure, group = Series) + 
    scale_x_discrete(breaks = c(1975, 1985, 1998, 2005, 2015)) +
    ylab("Index") + xlab("År") + ggtitle(title) +
    geom_point(size = 1.2) +
    #geom_line() +
    geom_smooth(method = "loess", aes(group = Series, color = red)) +
    guides(colour = FALSE, size = FALSE) +
    #scale_color_few() +
    theme_solarized()
}

plot_trend(glada, "Glada, Vinterrutt") 
plot_trend(koltrast, "Koltrast, Vinterrutt")


## ---- fig.width=7, warning=FALSE-----------------------------------------

plot_sbt_static("Svarthätta")
plot_sbt_static("Svarthätta", loess = TRUE)

plot_sbt_static("Brushane", loess = TRUE)
plot_sbt_static("Brushane", showlegend = FALSE)

## ---- fig.width=7--------------------------------------------------------
plot_sbt_dy("Brushane")
plot_sbt_dy("Svarthätta")

## ---- fig.width=7,  eval=FALSE-------------------------------------------
#  # use this to launch the shiny web app examples
#  runShinyApp("birdtrends")
#  runShinyApp("birdtotals")

