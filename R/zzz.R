
.onAttach <- function(libname, pkgname) {
  
  # http://www.asciiset.com/figletserver.html (chunky)
  
  banner <-     
"
                            __  __         __    
.-----..--.--.--..-----..--|  ||__|.-----.|  |--.
|__ --||  |  |  ||  -__||  _  ||  ||__ --||     |
|_____||________||_____||_____||__||_____||__|__|
                                                 
 __     __           __  __                           __        
|  |--.|__|.----..--|  ||  |_ .----..-----..-----..--|  |.-----.
|  _  ||  ||   _||  _  ||   _||   _||  -__||     ||  _  ||__ --|
|_____||__||__|  |_____||____||__|  |_____||__|__||_____||_____|
                                                                
"

  `%+%` <- crayon::`%+%`
  r <- stringr::str_dup

  g <- crayon::green $ bgWhite
  b <- crayon::blue $ bgWhite
  s <- crayon::silver $ bgWhite

  styled_banner <- 
    g("Welcome to ...") %+% s(r(" ", 14)) %+%
    s("https://") %+% b("mskyttner") %+% s(".github.io/swedishbirdtrends")  %+%
    b(banner) %+%
    g("New to 'swedishbirdtrends'? For a tutorial, use:")  %+%
    g("\nvignette('swedishbirdtrends-vignette')") %+%
    g(r(" ", 9)) %+%
    g("\n\nWant to silence this banner? Instead of 'library(swedishbirdtrends)', use:") %+%
    g("\nsuppressPackageStartupMessages(library(swedishbirdtrends))\n") %+%
    g(r(" ", 4))
    
  suppressWarnings(packageStartupMessage(styled_banner))
}