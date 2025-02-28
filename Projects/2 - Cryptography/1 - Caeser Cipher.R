library(dplyr)

#Function that gets the position of the character in the normal alphabet (i.e a=1, b=2 etc)
get_char_position <- function(char){
  as.numeric(charToRaw(char)) - as.numeric(charToRaw("a")) + 1
}

caeser_cipher_encode <- function(input_str, shift_value){
  #Converts input message to lower case to make text wrapping easier
  input_lower <- tolower(input_str)

  #Apply the get character position to all characters in the input string
  chr_positions <- sapply(strsplit(input_lower,NULL)[[1]], get_char_position)

  #Makes a df with the position of all the characters
  df <- data.frame(org_character = strsplit(input_lower, NULL)[[1]], org_position = chr_positions) %>%
    #Changes the position as defined by the shift value
    mutate(shifted_position = chr_positions + shift_value) %>%
    #If a value exceeds the last position (26), wraps it around to the start
    mutate(shifted_position = ifelse(shifted_position >26, shifted_position - 26, shifted_position)) %>%
    #converts the shifted position into the decimal code for that letter and then into the correctly shifted character
    mutate(shifted_char = shifted_position + 96) %>%
    #If the decimal code is not for a character (i.e is below 97) then it means the character is a piece of puncuation
    #(as we have already shifted the message to lowercase) so we reverse the shift to get the 
    mutate(shifted_char = ifelse(shifted_char<97, shifted_char - shift_value, shifted_char)) %>%
    mutate(coded_char = sapply(shifted_char, function(x) rawToChar(as.raw(x))))
  
  
  coded_str <- paste0(df$coded_char, collapse ="")
  return(coded_str)
}

#To do:
# Add function to decode messages
