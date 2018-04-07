# get the base image, the rocker/verse has R, RStudio and pandoc
FROM rocker/verse:3.4.4

# required
MAINTAINER Your Name <bocinsky@gmail.com>

COPY . /swtp

# go into the repo directory
RUN . /etc/environment \

  # build this compendium package
  && R -e "devtools::install('/swtp', dep=TRUE)" \

 # render the manuscript
  && R -e "rmarkdown::render('/swtp/vignettes/paper/paper.Rmd')"
