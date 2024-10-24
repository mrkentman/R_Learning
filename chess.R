library(dplyr)
library(readr)
library(ggplot2)

chess <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-10-01/chess.csv')
chess_cleaned <- chess %>%
  filter(black_rating != 1500, white_rating != 1500, rated == TRUE, turns >= 5, turns < 175) %>%
  select(game_id, turns, victory_status, winner, white_rating, black_rating)

chess_rating_dif <- chess_cleaned %>%
  mutate(rating_diff = white_rating - black_rating)

vis <- ggplot(chess_rating_dif, aes(x=turns, y=rating_diff)) +
  geom_point(aes(color=winner))

colnames(chess_rating_dif)
head(chess_rating_dif)

chess_turns <- chess_cleaned %>%
  select(game_id, turns)
