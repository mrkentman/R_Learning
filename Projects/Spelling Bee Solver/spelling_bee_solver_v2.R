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

sb_solver <- function(central_letter, outside_letters){
  sb_dictionary_with_central_letter <- sb_dictionary %>%
    filter(grepl(central_letter, word))
  
  permited_letters <- paste0(central_letter, outside_letters, sep="")
  
  letters_to_check <- strsplit(permited_letters, NULL)[[1]]
  
  pattern <- paste0("[^", paste(letters_to_check, collapse=""), "]")
  
  filter_condition <- sapply(sb_dictionary_with_central_letter[[word]], function(x) {
    !grepl(pattern, x) && all(strsplit(x, NULL)[[1]] %in% letters_to_check)
  })
  
  word_list <- sb_dictionary_with_central_letter[filter_condition, ]
  return(word_list)
}

results <- sb_solver("r", "doilgh")
