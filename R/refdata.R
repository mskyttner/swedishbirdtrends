#' Bird population trends in Sweden
#'
#' A dataset containing bird population trend indices from Sweden
#' This dataset is from 2016-02-16
#' 
#' @format A data frame [12,598 x 6]
#' \describe{
#'   \item{Art}{Species Number}
#'   \item{Arthela}{Species Name}
#'   \item{Year}{Year}
#'   \item{Measure}{Measure for index}
#'   \item{ts}{Timestamp for the year}
#'   \item{Series}{Series - route used - Winter, Summer, Standard or Night}
#'   \item{Suffix}{Suffix - qualifier - such as (S) for South, (N) for North, ob for not determined etc}
#'   \item{Vernacular}{Vernacular or Popular name - the common name for the species, cleaned from any qualifier or suffix}
#'   \item{Scientific}{Scientific name, the latin binomen}
#' }
#' @source \url{http://www.fageltaxering.lu.se/sites/default/files/files/Data/populationsindex.xls}
"birdtrends"

#' Bird population totals in Sweden
#'
#' A dataset containing bird population trend indices from Sweden
#' This dataset is from 2016-02-16
#' 
#' @format A data frame [477 x 7]
#' \describe{
#'   \item{Art}{Art numeric code identifier}
#'   \item{Arthela}{The whole Swedish species name}
#'   \item{Ind}{Indicator}
#'   \item{YPctChg}{Yearly change in percent}
#'   \item{Significance}{Statistical significance where * is lower and *** is higher}
#'   \item{Series}{Which route was used for the inventory - Vinter, Sommar, Standard or Natt}
#'   \item{Suffix}{The suffix contains some special abbreviations used in Arthela}
#'   \item{Vernacular}{Vernacular or Popular name - the common name for the species, cleaned from any qualifier or suffix}
#'   \item{Scientific}{Scientific name, the latin binomen}
#' }
#' @source \url{http://www.fageltaxering.lu.se/sites/default/files/files/Data/populationsindex.xls}
"birdtotals"


#' Bird identifiers mapped to unique identifiers used at The Naturalist / Naturforskaren (naturforskaren.se)
#'
#' A dataset containing bird population trend indices from Sweden
#' This dataset is from 2016-02-16
#' 
#' @format A data frame [22,840 x 2]
#' \describe{
#'   \item{species_uuid}{unique identifier for a species used in The Naturalist}
#'   \item{vernacular}{vernacular name in lower case}
#'   \item{sciname}{Scientific name}
#' }
#' @source \url{http://naturforskaren.se}
"birduuids"
