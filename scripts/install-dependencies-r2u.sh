#!/bin/bash
set -eu

# Install dependencies with APT/r2u

apt-get install --yes \
  libssl-dev \
  pandoc \
  pandoc-citeproc \
  r-cran-bookdown \
  r-cran-distill \
  r-cran-faviconplease \
  r-cran-fs \
  r-cran-ggplot2 \
  r-cran-ggraph \
  r-cran-git2r \
  r-cran-rmarkdown \
  r-cran-rstudioapi \
  r-cran-scales \
  r-cran-xml2

# List installed R packages
apt list --installed 'r-*'
