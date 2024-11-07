library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)

#Importing and cleaning up data
hltv_top20 <- read.csv("https://raw.githubusercontent.com/mrkentman/R_Learning/refs/heads/cs2_top20/Projects/cs2_hltv_top_20/hltv_top20.csv")
player_info <- read.csv("https://raw.githubusercontent.com/mrkentman/R_Learning/refs/heads/cs2_top20/Projects/cs2_hltv_top_20/player_info.csv")


#Clearning up the names
(hltv_top20) <- c('player_name','rank_2013', 'rank_2014', 'rank_2015', 'rank_2016', 'rank_2017','rank_2018',
                       'rank_2019', 'rank_2020', 'rank_2021', 'rank_2022', 'rank_2023', 'total_rank1',
                       'total_rank2', 'total_rank3', 'total_top3','total_4_5', 'total_6_10', 'total_11_20', 'total_top20')

#Combining both datasets
combined_data <- hltv_top20 %>%
  merge(player_info, by="player_name")

#wrangling the data
unique_player_countries <- combined_data %>%
  group_by(country) %>%
  count(country) %>%
  rename("uniquie_players" = "n")

total_player_countries <- combined_data %>%
  group_by(country) %>%
  summarise("total_appearances" = sum(total_top20))

hltv_countries <- unique_player_countries %>%
  merge(total_player_countries, by = "country") %>%
  mutate(average_per_player = total_appearances / uniquie_players)
