#loading libaries
library(tidyverse)
library(dplyr)

#Getting data
dictionary = read.csv("https://raw.githubusercontent.com/benjihillard/English-Dictionary-Database/refs/heads/main/english%20Dictionary.csv")

#Game rules:
#1: Words must be at least 4 letters long
#2: The central letter MUST be used in the word
#3: Only the listed letters may be used in the word, but can be used more than once
#4: One point for each word, each letter more than the minimum grants an additional point.
#Words containing all letters are worth an extra 7 points

#Filtering the dictionary to only have valid words
sb_dictionary <- dictionary %>%
  select(word) %>%
  mutate(word_length = nchar(word)) %>%
  filter(word_length > 3) %>%
  filter(!grepl("-", word) & !grepl(" ", word)) %>%
  distinct() %>%
  mutate(word=tolower(word))
         
#Inputting todays letters
central_letter <- "r"
outside_letters <- "doilgh"
permited_letters <-  paste0(central_letter, outside_letters,sep="")

#Filtering dictionary to only include words with the central letter
sb_dictionary_with_central_letter <- sb_dictionary %>%
  filter(grepl(central_letter, word))

#Further filtering to ensure words are only comprised of permitted letters
filter_words_by_outside_letters <- function(df, target_col, letters) {
  letters_to_check <- strsplit(letters, NULL)[[1]]
  
  pattern <- paste0("[^", paste(letters_to_check, collapse = ""), "]")
  
  filter_condition <- sapply(df[[target_col]], function(x) {
    !grepl(pattern, x) && all(strsplit(x, NULL)[[1]] %in% letters_to_check)
  })
  
  filtered_df <- df[filter_condition, ]
  return(filtered_df)
}

word_list <- filter_words_by_outside_letters(sb_dictionary_with_central_letter, "word", permited_letters)

#Checking to see if any of the words are panagrams (contain all letters) for extra points
panagram_checker <- function(words, letters) {
  letters_to_check <- strsplit(letters, NULL)[[1]]
  
  all(sapply(letters_to_check, function(char) grepl(char, words)))
}

word_list$panagrams <- sapply(word_list$word, panagram_checker, permited_letters)

#Calculating points for each word
final_answers <- word_list %>%
  mutate(points = ifelse(word_length <= 4, word_length-3, word_length)) %>%
  mutate(points = ifelse(panagrams == TRUE, points + 7, points)) %>%
  select(word, points) %>%
  arrange(desc(points))

print(final_answers)
