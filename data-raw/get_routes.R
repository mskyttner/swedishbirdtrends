#getwd()

url <- paste0("http://www.fageltaxering.lu.se/sites/default/",
  "files/files/Data/standardrutterhistorik.pdf")

download.file(url, destfile = "data-raw/routes.pdf")
#system("sudo apt-get install xpdf")
system("pdftotext data-raw/routes.pdf")

txt <- readLines("data-raw/routes.txt")

cols <- unlist(strsplit(split = ", ", 
  "RUTT, NAMN, LANDSK, LÄN, SENAST, YRS"))

for (i in 1:length(txt)) {
  row <- trimws(txt[i])
  #if (row == "RUTT") 
  #  cat("RUTT at row", i, "\n")
  if (row == "") 
    cat("blank at row", i, "\n")
  if (row %in% cols)
    cat("at row", i, row, "\n")
}
