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

## ---- fig.show='hold', warning=FALSE-------------------------------------

storskarv <- 
  birdtrends %>% 
  filter(Series == "Vinter") %>% 
  filter(Arthela == "Storskarv") %>% 
  select(Year, Measure, Series)

koltrast <- 
  birdtrends %>% 
  filter(Series == "Vinter") %>% 
  filter(Arthela == "Koltrast") %>% 
  select(Year, Measure, Series)

plot_trend <- function(df, title) {
  ggplot(df) + 
    aes(x = Year, y = Measure, group = Series) + 
    scale_x_discrete(breaks = c(1975, 1985, 1998, 2005, 2015)) +
    ylab("Index") + ggtitle(title) +
    geom_line(size = 1.5) +
    theme_solarized()
  
}

plot_trend(storskarv, "Storskarv")
plot_trend(koltrast, "Koltrast")


## ---- fig.width=7,  eval=FALSE-------------------------------------------
#  runShinyApp("birdtrends")
#  runShinyApp("birdtotals")

