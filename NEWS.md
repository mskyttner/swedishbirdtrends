# swedishbirdtrends


For more fine-grained list of changes or to report a bug, consult 

* [The issues log](https://github.com/mskyttner/swedishbirdtrends/issues)
* [The commit log](https://github.com/mskyttner/swedishbirdtrends/master)

## v0.0.0.9005

* Add loess smoother to static trend line displays, documented in vignette
* Add scientific names to datasets and recompress to save space
* Removed non-birds from datasets
* Add birduuids mapping bird species to identifiers used on The Naturalist (naturforskaren.se)
* Add vignette sbt-species-vignette showing generation of a Tufte styled bird population trend report, the report template is parameterized on the vernacular name
* Add script to generate species reports for all bird species in the package. This can be used to distribute bird population trend reports in the form of a static Jekyll (Tufte-Jekyll) website

## v0.0.0.9004

* Updated README.md with installation instructions
* Config changes - trying to get Travis CI with GitHub Releases to work. 

## v0.0.0.9002

* Various configuration fixes related to Travis CI

## v0.0.0.9000

* First version with data bundled from Swedish Bird Survey and a Shiny app for exploring the data.
* Added a `NEWS.md` file to track changes to the package.