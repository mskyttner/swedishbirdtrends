[![Build
Status](https://api.travis-ci.org/mskyttner/swedishbirdtrends.png)](https://travis-ci.org/mskyttner/swedishbirdtrends)

`swedishbirdtrends` is a package that distributes Swedish bird
population trend data (from 2016-02-16) from the Swedish Bird Inventory
Facility <http://www.fageltaxering.lu.se> along with some interactive
web user interfaces presenting this data. 

The package does not provide real-time, online bird monitoring data and 
therefore it can be used offline.

Install
-------

The development version from Github

    install.packages("devtools")
    devtools::install_github("mskyttner/swedishbirdtrends")

Then load the package

    suppressWarnings(suppressPackageStartupMessages(library(swedishbirdtrends)))

Use Swedish bird population trend data
--------------------------------------

Inspect the bundled data:

    data("birdtotals")
    data("birdtrends")

    birdtotals

    ## Source: local data frame [477 x 8]
    ## 
    ##      Art   Arthela        Ind YPctChg Significance Series Suffix
    ##    (chr)     (chr)      (dbl)   (dbl)        (chr)  (chr)  (chr)
    ## 1    008 Storskarv   923.0513    3.29          *** Vinter     NA
    ## 2    009     Häger   133.7179    3.63          *** Vinter     NA
    ## 3    012   Gräsand 10231.1538    2.60          *** Vinter     NA
    ## 4    016   Bläsand   414.0000   27.19              Vinter     NA
    ## 5    020      Vigg  9798.0256    2.93          *** Vinter     NA
    ## 6    021   Brunand   224.8974    3.81            * Vinter     NA
    ## 7    022     Knipa  2001.8462    1.06          *** Vinter     NA
    ## 8    023   Alfågel  1657.7692   -1.66              Vinter     NA
    ## 9    026     Ejder   749.4615    0.96              Vinter     NA
    ## 10   027 Småskrake   191.1026    0.73              Vinter     NA
    ## ..   ...       ...        ...     ...          ...    ...    ...
    ## Variables not shown: Vernacular (chr)

    birdtrends

    ## Source: local data frame [12,598 x 8]
    ## 
    ##      Art   Arthela  Year Measure         ts Series Suffix Vernacular
    ##    (chr)     (chr) (chr)   (dbl)     (time)  (chr)  (chr)      (chr)
    ## 1    008 Storskarv  1975  0.3378 1975-01-01 Vinter     NA  Storskarv
    ## 2    009     Häger  1975  0.9471 1975-01-01 Vinter     NA      Häger
    ## 3    012   Gräsand  1975  0.4342 1975-01-01 Vinter     NA    Gräsand
    ## 4    016   Bläsand  1975      NA 1975-01-01 Vinter     NA    Bläsand
    ## 5    020      Vigg  1975  0.5928 1975-01-01 Vinter     NA       Vigg
    ## 6    021   Brunand  1975  0.1161 1975-01-01 Vinter     NA    Brunand
    ## 7    022     Knipa  1975  0.3211 1975-01-01 Vinter     NA      Knipa
    ## 8    023   Alfågel  1975  0.3505 1975-01-01 Vinter     NA    Alfågel
    ## 9    026     Ejder  1975  1.8316 1975-01-01 Vinter     NA      Ejder
    ## 10   027 Småskrake  1975  0.5940 1975-01-01 Vinter     NA  Småskrake
    ## ..   ...       ...   ...     ...        ...    ...    ...        ...

Explore Swedish Bird Population trends interactively
----------------------------------------------------

    runShinyApp("birdtrends")

Compare Swedish Bird species longterm trends
--------------------------------------------

    runShinyApp("birdtotals")

Meta
----

-   Please [report any issues or
    bugs](https://github.com/mskyttner/swedishbirdtrends/issues).
-   License: AGPL
