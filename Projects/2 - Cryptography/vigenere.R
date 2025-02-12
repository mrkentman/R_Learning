library(dplyr)
library(stringr)

filter_text <- function(text){
  return(tolower(str_replace_all("[^[:alnum:]]","")))
}

get_char_positions <- function(char){
  as.numeric(charToRaw(char)) - as.numeric(charToRaw("a"))
}

vigenere_cipher_encode <- function(input_msg,keyword){
  
  msg_filtered <- tolower(input_msg) %>%
    str_replace_all("[^[:alnum:]]","")
  
  keyword_filtered <- tolower(keyword) %>%
    str_replace_all("[^[:alnum:]]","")
  
  char_positions <- sapply(strsplit(msg_filtered,NULL)[[1]], get_char_positions)
  
  df <- data.frame(org_character = strsplit(msg_filtered,NULL)[[1]],org_position = char_positions)
  df$keyword_chr <- rep(strsplit(keyword, NULL)[[1]], length.out = nrow(df))
  df$keyword_chr_pos <- apply(df["keyword_chr"], 1, get_char_positions)
  df$coded_chr_pos <- (df$org_position + df$keyword_chr_pos) %% 26
  df$coded_chr_decimal <- df$coded_chr_pos + 97
  df$coded_chr <- sapply(df$coded_chr_decimal, function(x) rawToChar(as.raw(x)))
  
  coded_message <- paste0(df$coded_chr, collapse="")
  
 return(coded_message) 
}
