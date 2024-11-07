library(readr)
library(dplyr)
library(tidyr)
library(ggplot2

#importing and cleaning up data
hltv_top20 <- read.csv("https://raw.githubusercontent.com/mrkentman/R_Learning/refs/heads/cs2_top20/Projects/cs2_hltv_top_20/hltv_top20.csv")

names(hltv_top20) <- c('player','rank_2013', 'rank_2014', 'rank_2015', 'rank_2016', 'rank_2017','rank_2018',
                       'rank_2019', 'rank_2020', 'rank_2021', 'rank_2022', 'rank_2023', 'total_rank1',
                       'total_rank2', 'total_rank3', 'total_top3','total_4_5', 'total_6_10', 'total_11_20', 'total_top20')

#wrangling the data
ranks <- hltv_top20 %>%
  filter(total_top20 > 4) %>%
  select(player, grep("rank_", names(hltv_top20), value = TRUE)) %>%
  rename("2013"= "rank_2013",
         "2014"= "rank_2014",
         "2015"= "rank_2015",
         "2016"= "rank_2016",
         "2017"= "rank_2017",
         "2018"= "rank_2018",
         "2019"= "rank_2019",
         "2020"= "rank_2020",
         "2021"= "rank_2021",
         "2022"= "rank_2022",
         "2023"= "rank_2023") %>%
  pivot_longer(!player, names_to = "year", values_to = "rank")

ggplot(ranks, aes(x = year, y = rank, group = player, color=player)) +
  geom_line(data=ranks[!is.na(ranks$rank),], linewidth = 1.5) +
  geom_point(size=5) +
  scale_y_reverse() +
  labs(title="HLTV Top 20 rankings for players with 5+ appearances")
