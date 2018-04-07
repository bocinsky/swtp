# get the base image, the rocker/verse has R, RStudio and pandoc
FROM rocker/verse:3.4.4

# required
MAINTAINER Kyle Bocinsky <bocinsky@gmail.com>

COPY . /swtp

# go into the repo directory
RUN . /etc/environment \

  # build the dev version of devtools
  && R -e "devtools::install_github('r-lib/devtools')" \

  # build the dev version of ggplot2
  && R -e "devtools::install_github('hadley/ggplot2')" \

  # build this compendium package
  && R -e "devtools::install('/swtp', dependencies = TRUE)" \

 # render the manuscript
  && R -e "rmarkdown::render('/swtp/vignettes/paper/paper.Rmd')"
