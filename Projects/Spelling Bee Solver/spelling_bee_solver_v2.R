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
#5: Words containing all letters (panagrams) are worth an extra 7 points

#Filtering the dictionary to only have valid words (i.e, no hyphented and 4 or more characters)
sb_dictionary <- dictionary %>%
  select(word) %>%
  mutate(word_length = nchar(word)) %>%
  filter(word_length > 3) %>%
  filter(!grepl("-", word) & !grepl(" ", word)) %>%
  distinct() %>%
  mutate(word=tolower(word))

#Making a function that takes the puzzles letters and returns word list with number of points each word is worth
#And also checking for panagrams
sb_solver <- function(central_letter, outside_letters){
  #FIltering down dictionary to only have words that have the central letter
  sb_dictionary_with_central_letter <- sb_dictionary %>%
    filter(grepl(central_letter, word))
  
  #Combining permited letters
  permitted_letters <- paste0(central_letter, outside_letters, sep="")
  
  #Split permited letters into individual characters
  letters_to_check <- strsplit(permitted_letters, NULL)[[1]]
  
  #Create regular epxression pattern to find disallowed letters
  pattern <- paste0("[^", paste(letters_to_check, collapse=""), "]")
  
  #Filters words that only use permitted letters
  filter_condition <- sapply(sb_dictionary_with_central_letter[["word"]], function(x) {
    !grepl(pattern, x) && all(strsplit(x, NULL)[[1]] %in% letters_to_check)
  })
  
  #Returns valid words
  word_list <- sb_dictionary_with_central_letter[filter_condition, ]
  
  #Check if a word is a panagram by creating a new function
  panagram_checker <- function(words, letters) {
    letters_to_check <- strsplit(letters, NULL)[[1]]
    
    all(sapply(letters_to_check, function(char) grepl(char, words)))
  }
  
  word_list$panagrams <- sapply(word_list$word, panagram_checker, permitted_letters)
  
  #Calculating the number of points each word is worth
  final_word_list <- word_list %>%
    mutate(points = ifelse(word_length == 4, word_length-3, word_length)) %>%
    mutate(points = ifelse(panagrams == TRUE, points + 7, points)) %>%
    select(word, points) %>%
    arrange(desc(points))
  
  print(final_word_list)
  return(final_word_list)
}

sb_solver("l", "chopry")
