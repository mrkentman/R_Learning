library(dplyr)
library(tidyr)
library(ggplot2)
library(tidyverse)
library(tidytuesdayR)

#Loading the data
tuesdata <- tidytuesdayR::tt_load(2024, week=44)

monster_movie_genres <- tuesdata$monster_movie_genres
monster_movies <- tuesdata$monster_movies

#Wrangling the data
plot_data <- monster_movies %>%
  select(tconst,year) %>%
  merge(monster_movie_genres, by="tconst") %>%
  arrange(genres) %>%
  select(-tconst) %>%
  group_by(year) %>%
  summarise(n=n())
  #add_column(value = 1) #%>%
  #pivot_wider(names_from = genres, values_from=value) #%>%
  #arrange(year)
  

test_table <- table(plot_data)
