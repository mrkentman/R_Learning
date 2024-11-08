#Loading libaries
library(readr)
library(dplyr)
library(ggplot2)
library(maps)

#Importing and cleaning up data
hltv_top20 <- read.csv("https://raw.githubusercontent.com/mrkentman/R_Learning/refs/heads/cs2_top20/Projects/cs2_hltv_top_20/hltv_top20.csv")
player_info <- read.csv("https://raw.githubusercontent.com/mrkentman/R_Learning/refs/heads/cs2_top20/Projects/cs2_hltv_top_20/player_info.csv")


#Clearning up the names
names(hltv_top20) <- c('player_name','rank_2013', 'rank_2014', 'rank_2015', 'rank_2016', 'rank_2017','rank_2018',
                       'rank_2019', 'rank_2020', 'rank_2021', 'rank_2022', 'rank_2023', 'total_rank1',
                       'total_rank2', 'total_rank3', 'total_top3','total_4_5', 'total_6_10', 'total_11_20', 'total_top20')

#Combining both datasets
combined_data <- hltv_top20 %>%
  merge(player_info, by="player_name")



#Section 1: Making a map graphic to show the frequency of countries represnted in the top 20
#Wrangling the data
unique_player_countries <- combined_data %>% #Finding the number of unique players that have appeared in the top 20
  group_by(country) %>%
  summarise("unique_players" = n())

total_player_countries <- combined_data %>% #Finding total appearances in the top 20 by country
  group_by(country) %>%
  summarise("total_appearances" = sum(total_top20))

hltv_countries <- unique_player_countries %>% #Combining both and calculating average number of appearances per player from each country
  merge(total_player_countries, by = "country") %>%
  mutate(average_per_player = total_appearances / unique_players) %>%
  rename("region" = "country")

#Making the map
#Getting the data and using that to make a blank world map
world <- map_data("world") %>%
  filter(region != "Antarctica")

world_base <- ggplot(world, aes(x=long, y=lat, group=group)) +
  geom_polygon(fill="grey", color="black") +
  theme(
    axis.title = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank()
    ) +
  coord_fixed(1.3)

#Plot texts
title <- "Total appearances in HLTV's Top 20 player rankings per country\nbetween 2013 and 2023"

#Joining the world data to the hltv countries data to use to fill in the blank map
hltv_map_data <- inner_join(world, hltv_countries, by="region")

hltv_world_map <- world_base +
  geom_polygon(data = hltv_map_data, aes(fill=total_appearances)) +
  scale_fill_continuous(low="#e3c5c5", high="#cf3434") +
  theme(
    plot.title = element_text(face="bold", size=15),
    plot.caption = element_text(face="italic", size=8)
  ) +
  labs(
    title = title,
    fill = "Total Appearances",
    caption = "Data: HLTV.org (2013-2023)"
  )

hltv_europe_map <- hltv_world_map + coord_fixed(xlim=c(-20, 50), ylim=c(29, 70), ratio=1.3) +
  labs()

hltv_europe_map
hltv_world_map
