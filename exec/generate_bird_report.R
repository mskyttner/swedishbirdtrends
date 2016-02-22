library(swedishbirdtrends)
library(rmarkdown)
library(knitr)
library(purrr)

message("This script generates markdown content for a Jekyll site")
report <- system.file("doc/sbt-species-vignette.Rmd", package = "swedishbirdtrends")

dest_dir <- "~/repos/sbt-jekyll/src/species"
message("Using target directory ", dest_dir)
message("Please amend if this is not correct....")

if (!dir.exists(dest_dir)) dir.create(dest_dir)


species_df <- 
  birdtotals %>% 
  left_join(birduuids, by = c("Scientific" = "sciname")) %>% 
  select(uuid = species_uuid, Vernacular, Scientific) %>%
  filter(!is.na(uuid) && !is.na(Vernacular) && !is.na(Scientific)) %>%
  distinct() %>%
  mutate(md = paste0("- [", Vernacular, " *", Scientific, "*](", uuid, ".html)"))

birds_html <- function(uuid, Vernacular) {
  
  dest_file <- paste0(dest_dir, "/", uuid, ".html")
  
  if (!file.exists(dest_file)) {
    message("Processing ", dest_file)
    res <- #failwith(quiet = TRUE, f = function(report, dest_file)
      render(report, params = list(species = Vernacular), output_file = dest_file)
    if (is.null(res)) {
      message("Failed to render ", dest_file, "(", Vernacular, ")")
      return (paste0("Error for ", Vernacular))
    }
    return (res)
  } else {
    message("Skipping ", dest_file, ", already exists...")
    return (paste0("Skipping ", dest_file))
  }
}



birds_thumb <- function(uuid, Vernacular) {
  p <- plot_sbt_static(Vernacular, loess = TRUE, theme = theme_solarized_2())
  dest_file <- paste0(dest_dir, "/", uuid, ".png")
  #ggsave(dest_file, p, width = 7, height = 5, dpi = 300)
  png(dest_file, units = "px", height = 240, width = 480, type = "cairo", res = 72, pointsize = 10)
  plot(p)
  dev.off()
}

library(purrr)

map2_chr(species_df$uuid, species_df$Vernacular, birds_html)
map2_chr(species_df$uuid, species_df$Vernacular, birds_thumb)

write_birds_toc_md <- function(df, 
  destfile = paste0(dest_dir, "/../page/species.md")) {
  
  yaml <- "---
layout: page
title: \"Trender\"
permalink: species/
group: navigation
---
"  
  
  out <- paste0(yaml, paste0(collapse = "\n", sort(species_df$md)))
  message("Writing TOC to ", destfile)
  writeLines(out, destfile)

}

write_birds_toc_md(species_df)
              
# in ~/repos/tufte-jekyll $ 
#bundle exec jekyll build
#bundle exec jekyll serve -w --baseurl ''
