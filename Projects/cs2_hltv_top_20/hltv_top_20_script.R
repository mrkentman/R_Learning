#Loading libraries
library(readr)
library(dplyr)
library(tidyverse)
library(ggplot2)
library(maps)

#Importing and cleaning up data
hltv_top20 <- read.csv("https://raw.githubusercontent.com/mrkentman/R_Learning/refs/heads/cs2_top20/Projects/cs2_hltv_top_20/hltv_top20.csv")
player_info <- read.csv("https://raw.githubusercontent.com/mrkentman/R_Learning/refs/heads/cs2_top20/Projects/cs2_hltv_top_20/player_info.csv")
continent_data <- read.csv("https://raw.githubusercontent.com/dbouquin/IS_608/refs/heads/master/NanosatDB_munging/Countries-Continents.csv")

#Clearning up the names
names(hltv_top20) <- c('player_name','rank_2013', 'rank_2014', 'rank_2015', 'rank_2016', 'rank_2017','rank_2018',
                       'rank_2019', 'rank_2020', 'rank_2021', 'rank_2022', 'rank_2023', 'total_rank1',
                       'total_rank2', 'total_rank3', 'total_top3','total_4_5', 'total_6_10', 'total_11_20', 'total_top20')

continent_data <- rename(continent_data, region = Country)
continent_data$Continent[continent_data$region == "Russian Federation"] <- "Europe"
continent_data$region[continent_data$region == "Russian Federation"] <- "Russia"
continent_data$region[continent_data$region == "US"] <- "United States"
continent_data$region[continent_data$region == "CZ"] <- "Czech Republic"

#Combining both hltv data sets
combined_data <- hltv_top20 %>%
  merge(player_info, by="player_name")


#Section 1: Making graphics to show the frequency of countries represented in the top 20
#Wrangling the data
unique_player_countries <- combined_data %>% #Finding the number of unique players that have appeared in the top 20
  group_by(country) %>%
  summarise("unique_players" = n())

total_player_countries <- combined_data %>% #Finding total appearances in the top 20 by country
  group_by(country) %>%
  summarise("total_appearances" = sum(total_top20))

hltv_countries1 <- unique_player_countries %>% #Combining both and calculating average number of appearances per player from each country
  merge(total_player_countries, by = "country") %>%
  mutate(average_per_player = total_appearances / unique_players) %>%
  rename("region" = "country")

hltv_countries2 <- hltv_countries1 %>%
  merge(continent_data, by = "region") #adding continent data to countries in top 20

#Plot texts + themes
total_appearances_title <- "Total appearances in HLTV's Top 20 player rankings\nper country for CSGO & CS2 between 2013 and 2023"
unique_appearances_title <- "Number of unique players in HLTV's Top 20 Player rankings\nper country for CSGO & CS2 between 2013 and 2023"

caption <- "Data: HLTV.org (2013-2023)"

custom_theme <- theme(
  plot.background = element_rect(fill="#d3dde0"),
  panel.background = element_rect(fill="#d3dde0"),
  legend.background = element_rect(fill="#d3dde0"),
  plot.title = element_text(face="bold", size=20),
  plot.caption = element_text(face="italic", size=8),
  legend.title = element_text(face="bold")
)

continent_colours <- scale_fill_manual(values = c("orange", "red", "#3e93b5", "yellow", "#008100"))

bar_theme <- theme(
  panel.grid = element_blank(),
  axis.title = element_text(size = 15),
  axis.title.y = element_blank(),
  axis.text = element_text(face="bold",size=10),
  axis.ticks = element_blank(),
  panel.background = element_rect(fill="white", color="black")
)

#Making the map
#Getting the map data and using that to make a blank world map
world <- map_data("world") %>%
  filter(region != "Antarctica")

world$region[world$region == "USA"] <- "United States"

world_base <- ggplot(world, aes(x=long, y=lat, group=group)) +
  geom_polygon(fill="grey", color="black") +
  custom_theme + 
  theme(
    axis.title = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank()
  ) +
  coord_fixed(1.3)

#Joining the world data to the hltv countries data to use to fill in the blank map
hltv_map_data <- inner_join(world, hltv_countries2, by="region")

hltv_world_map <- world_base +
  geom_polygon(data = hltv_map_data, aes(fill=total_appearances), color="black") +
  scale_fill_continuous(low="#e3c5c5", high="#cf3434") +
  labs(
    title = total_appearances_title,
    fill = "Total Appearances",
    caption = caption
  )

hltv_world_map

#Creating an additional map focused on Europe
hltv_europe_map <- hltv_world_map + coord_fixed(xlim=c(-20, 50), ylim=c(32, 70), ratio=1.3)

hltv_europe_map


#Bar charts showing for countries for the highest frequencies of appearances and players in the top 20
hltv_top20_T_bar <- ggplot(hltv_countries2, aes(x=total_appearances, y=reorder(region, total_appearances))) +
  geom_bar(stat = "identity",aes(fill=Continent), color="black") +
  continent_colours +
  custom_theme +
  bar_theme +
  labs(
    title = total_appearances_title,
    caption = caption,
    x="Total appearances"
  )

hltv_top20_T_bar

hltv_top20_U_bar <- ggplot(hltv_countries2, aes(x=unique_players, y=reorder(region, unique_players))) +
  geom_bar(stat = "identity",aes(fill=Continent), color="black") +
  continent_colours +
  custom_theme +
  bar_theme +
  labs(
    title = unique_appearances_title,
    caption = caption,
    x="Unique appearances"
  )

hltv_top20_U_bar

#Line graph showing the amount of players from each country each year 
#Making a df for each year then combining them (must be a better way than doing this)
only_2013 <- combined_data %>%
  filter(rank_2013 > 0) %>%
  group_by(country) %>%
  summarise("2013"=n())
  
only_2014 <- combined_data %>%
  filter(rank_2014 > 0) %>%
  group_by(country) %>%
  summarise("2014"=n())

only_2015 <- combined_data %>%
  filter(rank_2015 > 0) %>%
  group_by(country) %>%
  summarise("2015"=n())

only_2016 <- combined_data %>%
  filter(rank_2016 > 0) %>%
  group_by(country) %>%
  summarise("2016"=n())

only_2017 <- combined_data %>%
  filter(rank_2017 > 0) %>%
  group_by(country) %>%
  summarise("2017"=n())

only_2018 <- combined_data %>%
  filter(rank_2018 > 0) %>%
  group_by(country) %>%
  summarise("2018"=n())

only_2019 <- combined_data %>%
  filter(rank_2019 > 0) %>%
  group_by(country) %>%
  summarise("2019"=n())

only_2020 <- combined_data %>%
  filter(rank_2020 > 0) %>%
  group_by(country) %>%
  summarise("2020"=n())

only_2021 <- combined_data %>%
  filter(rank_2021 > 0) %>%
  group_by(country) %>%
  summarise("2021"=n())

only_2022 <- combined_data %>%
  filter(rank_2022 > 0) %>%
  group_by(country) %>%
  summarise("2022"=n())

only_2023 <- combined_data %>%
  filter(rank_2023 > 0) %>%
  group_by(country) %>%
  summarise("2023"=n())

countries_timeline <- list(only_2013,only_2014,only_2015,only_2016,only_2017,only_2018,
                           only_2019,only_2020,only_2021,only_2022,only_2023) %>%
  reduce(full_join, by="country") #%>%
  #pivot_longer(!country, names_to = "year", values_to = "count")

countries_line_graph <- ggplot(countries_timeline, aes(x=year, y=count, group=country)) +
  geom_line(aes(colour=country),linewidth=1) +
  geom_point(aes(colour=country))

countries_line_graph

