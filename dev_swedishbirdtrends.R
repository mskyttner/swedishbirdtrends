library("devtools")
as.package("~/repos/birdtrends")
add_test_infrastructure()
use_data_raw()
use_github()
use_data()
use_news_md()
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


#dev_help("birdtrends")
library(swedishbirdtrends)
data(package = "swedishbirdtrends")
data("birdtotals")
data("birdtrends")
birdtrends
birdtotals
birduuids

#http://127.0.0.1:5844/logo.png
runApp()
runShinyApp("birdtrends")
runShinyApp("birdtotals")
#shiny::runApp()

birdtotals
runShinyApp("birdtrends")
