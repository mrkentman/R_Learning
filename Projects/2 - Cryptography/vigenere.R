library(dplyr)
library(stringr)

filter_text <- function(text){
  filtered_text <- tolower(text) %>%
  str_replace_all("[^[:alnum:]]","")
  return(filtered_text)
}

get_char_positions <- function(char){
  as.numeric(charToRaw(char)) - as.numeric(charToRaw("a"))
}

vigenere_encode <- function(input_msg,keyword){
  
  msg_filtered <- filter_text(input_msg)
  
  keyword_filtered <- filter_text(keyword)
  
  char_positions <- sapply(strsplit(msg_filtered,NULL)[[1]], get_char_positions)
  
  df <- data.frame(org_character = strsplit(msg_filtered,NULL)[[1]],org_position = char_positions)
  df$keyword_chr <- rep(strsplit(keyword_filtered, NULL)[[1]], length.out = nrow(df))
  df$keyword_chr_pos <- apply(df["keyword_chr"], 1, get_char_positions)
  df$coded_chr_pos <- (df$org_position + df$keyword_chr_pos) %% 26
  df$coded_chr_pos <- ifelse(df$org_position<0 | df$org_position>25, df$org_position, df$coded_chr_pos)
  df$coded_chr_decimal <- df$coded_chr_pos + 97
  df$coded_chr <- sapply(df$coded_chr_decimal, function(x) rawToChar(as.raw(x)))
  
  coded_message <- paste0(df$coded_chr, collapse="")
  
 return(coded_message) 
}

vigenere_decode <- function(input_msg,keyword){
  
  msg_filtered <- filter_text(input_msg)
  
  keyword_filtered <- filter_text(keyword)
  
  char_positions <- sapply(strsplit(msg_filtered,NULL)[[1]], get_char_positions)
  
  df <- data.frame(coded_char = strsplit(msg_filtered,NULL)[[1]],coded_char_pos = char_positions
}
#
#
#
input_msg <- "elqhepeeiepmezbnefsqfrpseelqhepinmezyfs66"
keyword <- "Lemon"

msg_filtered <- filter_text(input_msg)

keyword_filtered <- filter_text(keyword)

char_positions <- sapply(strsplit(msg_filtered,NULL)[[1]], get_char_positions)

df <- data.frame(coded_char = strsplit(msg_filtered,NULL)[[1]],coded_char_pos = char_positions)
df$keyword_chr <- rep(strsplit(keyword_filtered, NULL)[[1]], length.out = nrow(df))
df$keyword_chr_pos <- apply(df["keyword_chr"], 1, get_char_positions)
df$org_char_pos <- (df$coded_char_pos - df$keyword_chr_pos) %% 26
df$org_char_pos <- ifelse(df$coded_chr_pos < 0 | df$coded_chr_pos > 25, df$coded_char_pos, df$org_char_pos)
