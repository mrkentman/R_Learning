library(tidytuesdayR)
library(readr)
library(dplyr)
library(ggplot2)
library(tidyverse)

#Loading the orginal data
chess <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-10-01/chess.csv')
head(chess)

#Clearing up the data (removing games where either player is at 1500 due to this being the default starting rating for a new account
#on Lichess; removing games where the number of moves is less 4 as this is the least amount of moves to win via checkmate)
chess_cleaned <- chess %>%
  filter(white_rating != 1500, black_rating != 1500, turns >= 4, rated == TRUE) %>%
  select(-game_id, -start_time, -end_time, -white_id, -black_id)

#--------------------------------------------------------------------------------------------
#Plot 1: Scatter plot showing the ratings of white vs black
#--------------------------------------------------------------------------------------------
white_rating_vs_black_rating <- ggplot(chess_cleaned, aes(x=white_rating, y=black_rating)) + 
  geom_point(aes(color=winner), alpha =0.25) +
  geom_smooth(method = lm, se=FALSE) +
  labs(title="Chess players ratings", caption="Data from gathered from 20'000 matches on Lichess.", x="White Rating", y="Black Rating", color="Winner")

white_rating_vs_black_rating

#--------------------------------------------------------------------------------------------
#Plot 2 + 3: Scatter plot and heat map showing relationship between difference in rating against length of games
#--------------------------------------------------------------------------------------------
rating_diff <- chess_cleaned %>%
  mutate(rating_dif = white_rating - black_rating) %>%
  filter(turns < 250)

#scatter plot
rating_diff_vs_turns_graph <- ggplot(rating_diff, aes(x=turns, y=rating_dif)) +
  geom_hline(yintercept = 0) +
  geom_point(aes(color=winner), alpha = .5) +
  labs(title="Total moves played vs difference in rating", caption="Data from 20'000 matches on Lichess.", x="Total moves played", y="Rating difference", color="Match outcome")

rating_diff_vs_turns_graph

#heat map
rating_diff_vs_turns_heat_map <- ggplot(rating_diff, aes(x=turns, y=rating_dif)) +
  geom_bin2d(bins = 100) + scale_fill_gradient(low="yellow",high="red") +
  geom_hline(yintercept = 0) +
  labs(title="Total moves played vs difference in rating", caption="Data from 20'000 matches on Lichess.", x="Total moves played", y="Rating difference")

rating_diff_vs_turns_heat_map

#--------------------------------------------------------------------------------------------
#Plot 4 + 5 + 6: Bar charts showing most popular openings when white or black won
#--------------------------------------------------------------------------------------------

#Selects games where black won, summaries each game on the overall opening and counts them
black_wins_openings <- chess_cleaned %>%
  filter(winner == "black") %>%
  separate(opening_name,c('opening','opening_variation'),':') %>%
  group_by(opening) %>%
  summarize(black_count=n())

#Selects games where white won, summaries each game on the overall opening and counts them
white_wins_openings <- chess_cleaned %>%
  filter(winner == "white") %>%
  separate(opening_name,c('opening','opening_variation'),':') %>%
  group_by(opening) %>%
  summarize(white_count=n())

#Collates both white and black opening counts when respective side won
all_openings_by_color <- merge(white_wins_openings, black_wins_openings, all=T) %>%
  replace_na(list(white_count = 0, black_count =0)) %>%
  mutate(total_count = white_count + black_count) %>%
  arrange(desc(total_count))

#Graph for top 10 openings when black wins
black_wins_openings_top_10 <- all_openings_by_color %>%
  arrange(desc(black_count)) %>%
  head(10)

blacks_wins_openings_top_10_graph <- ggplot(black_wins_openings_top_10, aes(x=black_count, y=reorder(opening, -black_count))) +
  geom_bar(stat="identity", color="grey",fill="black") +
  labs(title='Top 10 most popular openings played when Black won', caption="Data from 20'000 games played on Lichess", x='Number of times played', y='Opening') +
  theme(panel.background = element_blank(), axis.line = element_line(color="black"))

blacks_wins_openings_top_10_graph

#Graph for top 10 openings when white wins
white_wins_openings_top_10 <- all_openings_by_color %>%
  arrange(desc(white_count)) %>%
  head(10)

white_wins_by_openings_top_10_graph <- ggplot(white_wins_openings_top_10, aes(x=white_count, y=reorder(opening, -white_count))) +
  geom_bar(stat="identity", color="black",fill="white") +
  labs(title='Top 10 most popular openings played when White won', caption="Data from 20'000 games played on Lichess", x='Number of times played', y='Opening') +
  theme(panel.background = element_blank(), axis.line = element_line(color="black"))

white_wins_by_openings_top_10_graph

#Graph for top 10 overall openings for black and white
all_openings_by_color_top_10 <- head(all_openings_by_color,10) %>%
  tidyr::pivot_longer(cols=c('white_count','black_count'), names_to = 'side', values_to = 'count') %>%
  select(-total_count)


all_openings_by_color_top_10_graph <- ggplot(data = all_openings_by_color_top_10, aes(x=count, y=reorder(opening,-count), fill=side)) +
                                      geom_bar(stat='identity',position='dodge',color='black') +
                                      scale_fill_manual(values = c('black','white')) +
                                      labs(title='Top 10 most popular openings played in games won by\nBlack and White',x='Number of times played', y='Opening',fill='Winner') +
                                      theme(panel.background = element_blank(), axis.line = element_line(color="black"))
all_openings_by_color_top_10_graph

#--------------------------------------------------------------------------------------------
# TO DO: Section comparing the win rates for white and black based on the difference in ratings between the two sides
#--------------------------------------------------------------------------------------------
