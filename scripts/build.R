#!/usr/bin/env Rscript

# Only build outdated R Markdown files. Always view in RStudio.

library(fs)
library(rmarkdown)
library(rstudioapi)

stopifnot(file_exists("blog.jdblischak.com.Rproj"))

rmd <- dir_ls(path = "_posts/", recurse = TRUE, glob = "*/*Rmd")
html <- vapply(rmd, path_ext_set, character(1), ext = "html")
outdated <- !file_exists(html) |
            file_info(rmd)$modification_time > file_info(html)$modification_time

for (r in rmd[outdated]) {
  cat("Rendering", r, "\n")
  render(r, quiet = TRUE)
}

cat("Rebuilding site\n")
render_site(input = ".", encoding = "UTF-8")

if (isAvailable()) {
  tmp <- fs::file_temp()
  dir_copy("public/", tmp)
  viewer(path(tmp, "index.html"))
} else {
  browseURL("public/index.html")
}
