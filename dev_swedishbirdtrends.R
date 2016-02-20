library("devtools")
as.package("~/repos/swedishbirdtrends")
add_test_infrastructure()
use_data_raw()
use_github()
use_data()
use_news_md()
use_readme_rmd()
use_travis()
use_vignette("birdy-vignette")


require("devtools")
load_all()
document()
clean_vignettes()
build_vignettes()

test()
build()
install()
check()


#dev_help("swedishbirdtrends")
library(swedishbirdtrends)
data(package = "swedishbirdtrends")
data("birdtotals")
data("birdtrends")
birdtrends
birdtotals
birduuids

runApp()
runShinyApp("birdtrends")
runShinyApp("birdtotals")
#shiny::runApp()

birdtotals
runShinyApp("birdtrends")

# resave data to compress even more
library(tools)
tools::checkRdaFiles(paths = "data")
tools::resaveRdaFiles(paths = "data")
