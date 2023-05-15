library(data.table)
library(dplyr)
getwd()
setwd("9. Final capstone/")

# 1. Load text corpi
eng_twitter <- readLines("./data/en_US/en_US.twitter.txt")
eng_blogs <- readLines("./data/en_US/en_US.blogs.txt")
eng_news <- readLines("./data/en_US/en_US.news.txt")
eng_all <- c(eng_twitter,eng_blogs,eng_news)
rm(eng_twitter,eng_blogs,eng_news)

# 2. Clean the shit
text <- tolower(eng_all)
text <- gsub("[[:punct:]]", "", text) # remove punctuation
text <- strsplit(text, "\\s+") # remove spaces and isolate single words

# 3. Calculate n-grams
## subset if computationally too intense
subset <- text[sample.int(length(text),200000)] # pick 200k (5%) random sentences
k <- 0.1 # Set k value for smoothing (handle unseen n-grams)

esagrams <- lapply(subset, function(x) tau::textcnt(x, method = "string", n = 6))
septagrams <- lapply(subset, function(x) tau::textcnt(x, method = "string", n = 7))
octagrams <- lapply(subset, function(x) tau::textcnt(x, method = "string", n = 8))

esa_freqs <- data.frame(ngram = names(unlist(esagrams)), n = unname(unlist(esagrams))) %>%
  group_by(ngram) %>% 
  summarise(n=sum(n), .groups = 'drop') %>% 
  mutate(prob = (n + k) / (sum(n) + k * n_distinct(ngram)), type = "esa")
septa_freqs <- data.frame(ngram = names(unlist(septagrams)), n = unname(unlist(septagrams))) %>%
  group_by(ngram) %>% 
  summarise(n=sum(n), .groups = 'drop') %>% 
  mutate(prob = (n + k) / (sum(n) + k * n_distinct(ngram)), type = "septa")
octa_freqs <- data.frame(ngram = names(unlist(octagrams)), n = unname(unlist(octagrams))) %>%
  group_by(ngram) %>% 
  summarise(n=sum(n), .groups = 'drop') %>% 
  mutate(prob = (n + k) / (sum(n) + k * n_distinct(ngram)), type = "octa")

ngrams <- rbind(esa_freqs,septa_freqs,octa_freqs)
rm(subset,esagrams,septagrams,octagrams,esa_freqs,septa_freqs,octa_freqs)


# 4. Prepare prediction function
ngrams <- ngrams %>% mutate(predictor = sapply(ngram,function(x) {words <- strsplit(x, " ")[[1]]
                                                                  paste(words[1:(length(words)-1)], collapse = " ")
                                                                  }), 
                            predicted = sapply(ngram,function(x) {words <- strsplit(x, " ")[[1]]; words[length(words)]}))

predict <- function(text_input){
  
  # 1. Remove upper case and punctuations
  text_input <- tolower(text_input)
  text_input <- gsub("[[:punct:]]", "", text_input)
  
  # 2. Split by white space and remove additional white spaces (empty strings)
  split <- strsplit(text_input," ")[[1]]
  split <- split[split!=""]
  
  # 3. Check length and separate by last words
  split_length <- length(split)
  if(split_length > 7){
    last_7_words <- paste(split[(split_length-6):split_length], collapse=" ")
  } else {last_7_words <- paste(split, collapse=" ")}
  
  if(split_length > 6){
    last_6_words <- paste(split[(split_length-5):split_length], collapse=" ")
  } else {last_6_words <- paste(split, collapse=" ")}
  
  if(split_length > 5){
    last_5_words <- paste(split[(split_length-4):split_length], collapse=" ")
  } else {last_5_words <- paste(split, collapse=" ")}
  
  # 8. Search the ngram by longest to smallest
  df_input <- data.table(predictor=last_7_words)
  output <- ngrams[ngrams$predictor == last_7_words,] 
  
  if(nrow(output)<6){
    df_input <- data.table(predictor=last_6_words)
    output <- rbind(output, ngrams[ngrams$predictor == last_6_words,])
  }
  
  if(nrow(output)<6){
    df_input <- data.table(predictor=last_5_words)
    output <- rbind(output, ngrams[ngrams$predictor == last_5_words,])
  }
  
  ## Standard output when everything fails and we cry
  if(nrow(output)<6){
    output <- rbind(output, data.table(ngram = NA,
                                       n = NA, 
                                       type = NA,
                                       predictor = NA,
                                       predicted=c("the","to","a"), 
                                       prob=c(1,1,1)))
  }
  
  output %>% 
    unique() %>%
    arrange(desc(prob)) %>% 
    group_by(type) %>%
    slice(1:2)
}

# 5. Predict
text_input <- "Every inch of you is perfect from the bottom to the"
predict(text_input)



