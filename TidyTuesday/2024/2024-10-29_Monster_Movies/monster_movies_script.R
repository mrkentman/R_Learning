library(dplyr)
library(tidyr)
library(ggplot2)
#library(tidyverse)
library(tidytuesdayR)

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
  
sorted_data[sorted_data==0] <- NA

plot_data <- data.frame(t(sorted_data[-1]))
colnames(plot_data) <- sorted_data[,1]

#Ranking each genre per year
