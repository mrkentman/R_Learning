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

#Merging data bases to contain number of times a genre has appeared per year in the last 40 years
sorted_data <- monster_movies %>%
  select(tconst,year) %>%
  merge(monster_movie_genres, by="tconst") %>%
  select(-tconst) %>%
  table() %>%
  as.data.frame() %>%
  pivot_wider(names_from = genres, values_from = Freq) %>%
  tail(n = 40) %>%
  select(-year)
  
sorted_data$year <- 1985:2024
  

#Finding the 10 most used genres in the last 40 years
popular_genres <- monster_movies %>%
  filter(year >= 1985) %>%
  select(tconst) %>%
  merge(monster_movie_genres, by = "tconst") %>%
  group_by(genres) %>%
  summarise(count=n()) %>%
  arrange(desc(count)) %>%
  head(10)

#Making new df's for  each of the most used genres so we can calculate the culmative count
horror_data <- sorted_data %>%
  select(year,Horror) %>%
  mutate(Horror = cumsum(Horror))

comedy_data <- sorted_data %>%
  select(year,Comedy) %>%
  mutate(Comedy = cumsum(Comedy))

doc_data <- sorted_data %>%
  select(year,Documentary) %>%
  mutate(Documentary = cumsum(Documentary))

drama_data <- sorted_data %>%
  select(year,Drama) %>%
  mutate(Drama = cumsum(Drama))

adv_data <- sorted_data %>%
  select(year,Adventure) %>%
  mutate(Adventure = cumsum(Adventure))

ani_data <- sorted_data %>%
  select(year,Animation) %>%
  mutate(Animation = cumsum(Animation))

act_data <- sorted_data %>%
  select(year,Action) %>%
  mutate(Action = cumsum(Action))

scifi_data <- sorted_data %>%
  select(year,'Sci-Fi') %>%
  rename(scifi='Sci-Fi') %>%
  mutate(SciFi = cumsum(scifi))

fant_data <- sorted_data %>%
  select(year,Fantasy) %>%
  mutate(Fantasy = cumsum(Fantasy))

fam_data <- sorted_data %>%
  select(year,Family) %>%
  mutate(Family = cumsum(Family))

plot_data <- cbind(act_data, adv_data, ani_data, comedy_data, doc_data, drama_data, fam_data, fant_data, horror_data, scifi_data) %>%
  select("year",Action, Adventure, Animation, Comedy, Documentary, Drama, Family, Fantasy, Horror, SciFi) %>%
  pivot_longer(cols = c("Action","Adventure","Animation","Comedy","Documentary","Drama","Family","Fantasy","Horror","SciFi"),names_to ="genre", values_to="culmfreq")

#Defining texts
st <- ""
#Plotting the data
ggplot(plot_data, aes(x=year,y=culmfreq,group=genre,color=genre)) +
  geom_line(linewidth=2) +
  theme(plot.background = element_rect(fill="#3d3a39"),
        panel.background = element_rect(fill="#3d3a39"),
        panel.grid.major = element_line(color="black",size=1.5),
        panel.grid.minor = element_blank(),
        panel.border = element_rect(color = "white", fill = NA, linewidth = 1.5),
        plot.title = element_text(size= 30, face="bold",color="orange"),
        plot.subtitle = element_text(size=13, face="italic"),
        axis.title = element_text(size=13, face="bold", color="orange"),
        axis.text = element_text(size=11, color="orange", face="italic"),
        legend.title = element_text(size=15, face="bold", color="orange"),
        legend.background = element_rect(fill="#3d3a39"),
        legend.text = element_text(size=13, face="bold", color="orange")
        ) +
  labs(x="Year", y="Culmative Frequency",
       title = "Culmative frequencies of the top 10 most popular\ngenres for 'Monster' movies",
       color="Genre")
