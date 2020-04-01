#!/usr/bin/env Rscript

# Only build R Markdown files that have been committed more recently than their
# corresponding HTML files.

library(git2r)
library(fs)
library(rmarkdown)
library(rstudioapi)

stopifnot(file_exists("blog.jdblischak.com.Rproj"))
is_ci_build <- identical(Sys.getenv("CIRCLECI"), "true")
if (!is_ci_build) warning("This isn't a CI build", call. = FALSE, immediate. = TRUE)

rmd <- dir_ls(path = "_posts/", recurse = TRUE, glob = "*/*Rmd")
# https://github.com/r-lib/fs/pull/208
html <- vapply(rmd, path_ext_set, character(1), ext = "html")
r <- repository()

outdated <- logical(length = length(rmd))
for (i in seq_along(rmd)) {
  rmd_commits <- commits(r, path = rmd[i])
  if (length(rmd_commits) == 0) {
    message("Skipped because not tracked: ", rmd[i])
    next
  }

  if (!file_exists(html[i])) {
    outdated[i] <- TRUE
    next
  }

  html_commits <- commits(r, path = html[i])
  if (length(html_commits) == 0) {
    outdated[i] <- TRUE
    next
  }

  rmd_last_commit_time <- as.POSIXct(rmd_commits[[1]]$author$when)
  html_last_commit_time <- as.POSIXct(html_commits[[1]]$author$when)
  if (rmd_last_commit_time > html_last_commit_time) {
    outdated[i] <- TRUE
  }

  image_dir <- path(path_dir(rmd[i]), "img")
  if (dir_exists(image_dir)) {
    images <- dir_ls(path = image_dir)
  } else {
    images <- character()
  }
  for (image in images) {
    image_commits <- commits(r, path = image)
    if (length(image_commits) == 0) {
      outdated[i] <- TRUE
      next
    }
    image_last_commit_time <- as.POSIXct(image_commits[[1]]$author$when)
    if (image_last_commit_time > rmd_last_commit_time) {
      outdated[i] <- TRUE
    }
  }
}

for (r in rmd[outdated]) {
  cat("Rendering", r, "\n")
  render(r, quiet = TRUE)
}

if (sum(outdated) > 0) {
  cat("Rebuilding site\n")
  render_site(input = "index.Rmd", encoding = "UTF-8")
}
