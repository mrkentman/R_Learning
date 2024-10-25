library(readr)
library(dplyr)
library(ggplot2)
library(tidytuesdayR)

#Loading the data
tuesdata <- tidytuesdayR::tt_load(2024, week=43)
cia_factbook <- tuesdata$cia_factbook

#Wrangling the data
head(cia_factbook)

plot_data <- cia_factbook %>%
  select(country,population, internet_users, life_exp_at_birth) %>%
  na.exclude() %>%
  mutate(internet_perc = (internet_users / population) * 100) %>%
  arrange(desc(life_exp_at_birth))


top_economies <- plot_data %>%
  filter(grepl('United States|China|Japan|Germany|France|United Kingdom|Brazil|Italy|Russia|India', country))

#Define texts
title <- "Relationship between percentage of interent users and life expectancy \nfor given countries"
st <- "The World Factbook provides basic intelligence on the history, people, government, economy, energy, 
geography, environment, communications, transportation, military, terrorism, and transnational issues 
for 265 world entities. \n\n Data: CIA World Factbook "

plot_data %>%
  ggplot(aes(y=life_exp_at_birth, x=internet_perc)) +
  geom_point() +
  geom_smooth(se=FALSE, color = "Blue") +
  geom_point(data=top_economies, aes(x=internet_perc, y=life_exp_at_birth),colour="red")+
  theme(panel.background = element_rect(fill = "#ccd6e6"),
        panel.grid.minor = element_blank(),
        panel.border = element_rect(color = "Black", fill = NA, size = 1)) +
  labs(y="Life Expectancy at Birth", x="% Population Connected to Internet",
       title=title, subtitle = st)

#to do: add variable to plot_data to distinguish top 10 economies and add geomlabel by filtering
#the new variable. See if you can use the new variable to change the color has well to lose
#the top_economies variable