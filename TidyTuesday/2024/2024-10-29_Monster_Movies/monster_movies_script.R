library(dplyr)
library(tidyr)
library(ggplot2)
#library(tidyverse)
library(tidytuesdayR)
library(data.table)

#Loading the data
tuesdata <- tidytuesdayR::tt_load(2024, week=44)

monster_movie_genres <- tuesdata$monster_movie_genres
monster_movies <- tuesdata$monster_movies

#Wrangling the data
sorted_data <- monster_movies %>%
  #Merging data bases to contain number of times a genre has appeared per year
  select(tconst,year) %>%
  merge(monster_movie_genres, by="tconst") %>%
  select(-tconst) %>%
  table() %>%
  as.data.frame() %>%
  pivot_wider(names_from = genres, values_from = Freq)
  
rownames(sorted_data) <- 

plot_data <- transpose(sorted_data)
names(plot_data) <- plot_data[1,]
plot_data <- plot_data[-1,]
rownames(plot_data) <- colnames(sorted_data[-1])

#Working out culmative frequency for each genre
#plot_data$cumulative_freq <- cumsum(plot_data)
