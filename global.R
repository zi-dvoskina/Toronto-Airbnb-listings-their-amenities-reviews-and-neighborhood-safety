# package dependencies
library(data.table)
library(ggplot2)
library(dplyr)
library(magrittr)
library(wordcloud)
library(wordcloud2) # compared to the wordcloud package, allows to save the wordcloud to a variable
library(hrbrthemes)
library(reshape2)
# library(viridis)
library(lubridate)
library(stats)
library(shiny)
library(shinymanager)
library(RColorBrewer)
require(glue)
library(readr)
library(plotly)
library(tidytext)
library(tidyverse)
library(stopwords)
library(quanteda)
library(stringr)

# global parameter (directory of the data files)
dir_data = '~/Documents/NORTHEASTERN UNIVERSITY/MSBA/MISM 6210/Final Project/data'

#.........................................................

scatter_bubble_plot = function(dat_all, home_rating = '') {

  cols_scatter = c('home_rating', 'safety_level', 'price', 'Assault_Rate_2019')
  subset_scatter = dat_all[, ..cols_scatter]

  if (home_rating != '') {
    idx = which(dat_all$home_rating == home_rating)
    subset_scatter = subset_scatter[idx, ]
  }

  subset_scatter$price = gsub('[$]', '', subset_scatter$price)
  subset_scatter$price = gsub('[,]', '', subset_scatter$price)
  subset_scatter$price = as.numeric(subset_scatter$price)

  sctplt = ggplot(data = subset_scatter, aes(x = price,
                                             y = home_rating,
                                             size = Assault_Rate_2019,
                                             color = safety_level)) +
    geom_point(alpha=0.5) +
    scale_size(range = c(.1, 20)) +
    labs(title="Scatterplot",
         subtitle="Relation between home_rating, safety_level, price and Assault_Rate_2019")

  return(sctplt)
}

#.....................................................

wordcloud_plot = function(dat_all, max_words = NULL) {

  if (!is.null(max_words)) {
    # idx_int = as.integer(max_words)
    dat_all = dat_all[1:max_words, ]
  }

  plt_wordcl = wordcloud2(data = dat_all,
                          size = 1,
                          shape = 'circle',
                          color = 'random-dark')
  return(plt_wordcl)
}