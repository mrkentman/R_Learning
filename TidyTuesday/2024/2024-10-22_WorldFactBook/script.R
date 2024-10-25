library(dplyr)
library(ggplot2)
library(ggrepel)
library(tidytuesdayR)
library(tidyr)

#Loading the data
tuesdata <- tidytuesdayR::tt_load(2024, week=43)
cia_factbook <- tuesdata$cia_factbook

#Wrangling the data
head(cia_factbook)

top_economies <- cia_factbook %>%
  na.exclude() %>%
  filter(grepl('United States|China|Japan|Germany|France|United Kingdom|Brazil|Italy|Russia|India', country)) %>%
  mutate(top10_econ = 1)

plot_data <- cia_factbook %>%
  select(country,population, internet_users, life_exp_at_birth) %>%
  na.exclude() %>%
  mutate(internet_perc = (internet_users / population) * 100) %>%
  full_join(top_economies) %>%
  arrange(top10_econ)

plot_data[is.na(plot_data)] <- 0


#Define texts and getting fonts
st <- "The World Factbook provides basic intelligence on the history, people, government, economy, energy, 
geography, environment, communications, transportation, military, terrorism, and transnational issues 
for 265 world entities.
\nPercentage of a country's population using the internet was calculated using the provided data and compared
to life expectancy at birth to infer whether there was a correlation between the two. The highest performing 
economies of 2014 have also been highlighted."
caption="Data: CIA World Factbook (2014) "


#Making the plot
plot_data %>%
  ggplot(aes(y=life_exp_at_birth, x=internet_perc)) +
  geom_smooth(se=FALSE, color = "blue", linewidth = 2) +
  geom_point(shape = 21, size = 3, fill = ifelse(plot_data$top10_econ==1,"red","white"), colour = "black", stroke = 1.2) +
  geom_text_repel(aes(label=ifelse(top10_econ==1, country,"")),max.overlaps = Inf, box.padding = 0.6, color = "black",size = 5, bg.color = "grey30", fontface = "bold") +
  theme(panel.background = element_rect(fill = "#ccd6e6"),
        panel.grid.minor = element_blank(),
        panel.border = element_rect(color = "Black", fill = NA, linewidth = 1),
        plot.title = element_text(size = 25, face="bold"),
        plot.subtitle = element_text(size=13,face="italic"),
        axis.title = element_text(size=13, face="bold"),
        axis.text = element_text(size = 11,color="black",face="italic")) +
  labs(y="Life Expectancy at Birth (yrs)", x="% Population Connected to Internet",
       title="Relationship between percentage of internet users and life \nexpectancy for given countries",
       subtitle=st, caption=caption)

