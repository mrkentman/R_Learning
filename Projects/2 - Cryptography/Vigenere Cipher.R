#----------------------------------
#Load libaries
library(dplyr)
library(stringr)
#----------------------------------
#Functions used in both encoding and decoding

#Function that lowers the message to lowercase and remove all punctuation
filter_message <- function(text){
  filtered_text <- tolower(text) %>%
    str_replace_all("[^[:alnum:]]","")
  return(filtered_text)
}

#Function that lowers the keyword to lower case and remove all punctuation and numbers
filter_keyword <- function(keyword){
  filtered_keyword <- tolower(keyword)
  filtered_keyword <- gsub("[^a-zA-Z]", "", filtered_keyword)
  return(filtered_keyword)
}

#Function that takes a character and coverts it the position of it in the alphabet starting with a=0, then b=1 etc
get_char_positions <- function(char){
  as.numeric(charToRaw(char)) - as.numeric(charToRaw("a"))
}

vigenere_encode <- function(input_msg, keyword){
  
  #Filter both the message and keyword to make them usable
  msg_filtered <- filter_message(input_msg)
  
  keyword_filtered <- filter_keyword(keyword)
  
  #Get the positions of the characters in the alphabet
  char_positions <- sapply(strsplit(msg_filtered,NULL)[[1]], get_char_positions)
  
  #Make dataframe
  df <- data.frame(org_character = strsplit(msg_filtered,NULL)[[1]],org_position = char_positions)
  
  #Create a vector of valid rows to use in future calculations
  valid_rows <- df$org_position >=0 & df$org_position <= 25
  
  #Asign each letter in the message a letter from the keyword, repeating until no more message characters are left
  df$keyword_char[valid_rows] <- rep(strsplit(keyword_filtered, NULL)[[1]], length.out = sum(valid_rows))
  
  #Get the position of the alphabet for each keyword character
  df$keyword_char_pos[valid_rows] <- sapply(df$keyword_char[valid_rows], get_char_positions)
  
  #Add the positions together and returns the position of where the coded character is in the alphabet
  #(We use modulo 26 because our alphabet is 26 characters long)
  df$coded_char_pos[valid_rows] <- (df$org_position[valid_rows] + df$keyword_char_pos[valid_rows]) %% 26
  
  #Sets the coded_char_pos for any number rows back to the original position so it goes back to the original number in the input message
  df$coded_char_pos <- ifelse(df$org_position<0 | df$org_position>25, df$org_position, df$coded_char_pos)
  
  #Convert the positions into the ASCII decimal equivalent and then converetd into the character
  df$coded_char_decimal <- df$coded_char_pos + 97
  df$coded_char <- sapply(df$coded_char_decimal, function(x) rawToChar(as.raw(x)))
  
  #Pastes all the coded characters together to form the complete coded message
  coded_message <- paste0(df$coded_char, collapse="")
  
  return(coded_message)}

vigenere_decode <- function(input_msg, keyword){
  
  #Filter both the message and keyword to make them usable
  msg_filtered <- filter_message(input_msg)
  
  keyword_filtered <- filter_keyword(keyword)
  
  #Get the positions of the coded characters in the alphabet
  char_positions <- sapply(strsplit(msg_filtered,NULL)[[1]], get_char_positions)
  
  #Make dataframe
  df <- data.frame(coded_char = strsplit(msg_filtered,NULL)[[1]],coded_char_pos = char_positions)
  
  #Create a vector of valid rows to use in future calculations
  valid_rows <- df$coded_char_pos >=0 & df$coded_char_pos <= 25
  
  #Asign each letter in the message a letter from the keyword, repeating until no more message characters are left
  df$keyword_char[valid_rows] <- rep(strsplit(keyword_filtered, NULL)[[1]], length.out = sum(valid_rows))
  
  #Get the position of the alphabet for each keyword character
  df$keyword_char_pos[valid_rows] <- sapply(df$keyword_char[valid_rows], get_char_positions)
  
  #Subtract the positions from each other and returns the position of where the original character is in the alphabet
  #(We use modulo 26 because our alphabet is 26 characters long)
  df$org_char_pos[valid_rows] <- (df$coded_char_pos[valid_rows] - df$keyword_char_pos[valid_rows]) %% 26
  
  #Sets the org_char_pos for any number rows back to the coded position so it goes back to the correct number in the message
  df$org_char_pos <- ifelse(df$coded_char_pos < 0 | df$coded_char_pos > 25, df$coded_char_pos, df$org_char_pos)
  
  #Converts the decimal into the character for the decoded message
  df$org_char_decimal <- df$org_char_pos + 97
  df$org_char <- sapply(df$org_char_decimal, function(x) rawToChar(as.raw(x)))
  
  #Pastes all the decoded characters into a string
  decoded_message <- paste0(df$org_char, collapse="")
  
  return(decoded_message)}
