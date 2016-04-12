#' Retrieve image url from The Naturalist given latin binomen for a bird
#' @param sciname the scientific name for a bird species
#' @return a character vector with image urls for the species
#' @importFrom xml2 read_xml
#' @importFrom rvest xml_nodes
#' @importFrom xml2 xml_text
#' @export
#' @examples 
#' get_nf_media_urls("Turdus merula")
get_nf_media_urls <- function(sciname) {
  url <- paste0("https://dina-web.net/naturalist/api/v1/spm/get/taxon/latin/",
    URLencode(sciname), ".xml?locale=sv_SE")
  read_xml(url) %>% 
    xml_nodes(xpath = "//media/mime[contains(., 'image')]/../url") %>% 
    xml_text
}

#' Plot image from url
#' @param url the image url
#' @param width the default width
#' @return a plot with the image
#' @importFrom imager load.image
#' @importFrom imager resize
#' @importFrom imager height
#' @importFrom imager width
#' @importFrom grid grid.raster
#' @export
#' @examples 
#' plot_image_url(get_nf_media_urls("Turdus merula")[1])
plot_image_url <- function(url, width = 120L) {
  # sudo apt-get install graphicsmagick
  im <- load.image(url)  
  a <- height(im) / width(im)
  im <- resize(im, interpolation_type = 2, size_x = width, size_y = round(a * width))
  grid.raster(im)
}