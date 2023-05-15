library(data.table)
library(dplyr)

# 1. Load text corpi
eng_twitter <- readLines("9. Final capstone/data/en_US/en_US.twitter.txt")
eng_blogs <- readLines("9. Final capstone/data/en_US/en_US.blogs.txt")
eng_news <- readLines("9. Final capstone/data/en_US/en_US.news.txt")
eng_all <- c(eng_twitter,eng_blogs,eng_news)


### WEEK 1 Quiz ###
# 2. The en_US.twitter.txt has how many lines of text?
length(eng_twitter)

# 3. What is the length of the longest line seen in any of the three en_US data sets? 
chars <- sapply(eng_all, nchar) 
max(chars) # 40k but where?
max(sapply(eng_blogs, nchar)) # here

# 4. en_US twitter data set. Divide the number of lines with "love" by those with "hate" (both lowercase). Result?
sum(grepl("love", eng_twitter, ignore.case = F)) / sum(grepl("hate", eng_twitter, ignore.case = F)) 

# 5. The one tweet in the en_US twitter data set that matches the word "biostats" says what?
eng_twitter[grepl("biostats", eng_twitter, ignore.case = F)]

# 6. How many tweets have the exact string "A computer once beat me at chess, but it was no match for me at kickboxing"?
eng_twitter[grepl("A computer once beat me at chess, but it was no match for me at kickboxing", eng_twitter, ignore.case = F)]



### WEEK 2 - EPLORATORY ANALYSIS ###

# Q1. What are the distributions of word frequencies? 
subset <- eng_all[sample.int(length(eng_all),400000)] # pick 400k (10%) random sentences
only_words <- gsub("[^[:alnum:]]", " ", subset)
words <- unlist(strsplit(only_words, " "))
words <- words[words != ""] #remove empty rows
freq_table <- sort(table(words), decreasing = T)
freq_table[1:10]

barplot(freq_table[1:20])

# Q2. What are the frequencies of 2-grams and 3-grams in the dataset? 
# library(tau)
subset <- eng_all[sample.int(length(eng_all),4000)] # pick 4k (0.1%) random sentences
collapse <- paste(subset, collapse = " ") # Convert the sentences to a single character vector
bigrams <- tau::textcnt(collapse, method = "string", n = 2) # Get the 2-grams
trigrams <- tau::textcnt(collapse, method = "string", n = 3) # Get the 3-grams
tetragrams <- tau::textcnt(collapse, method = "string", n = 4) # Get the 3-grams
print(trigrams)

sort(trigrams, decreasing = T)[1:50]
  
# Q3. How many unique words do you need in a frequency sorted dictionary to cover 50% of all word instances in the language? 90%? 
total_words <- length(words)
frequencies <- data.frame(freq_table)
cumulative_freq <- cumsum(frequencies$Freq)
half_index <- min(which(cumulative_freq >= total_words/2)) # index of the first entry that covers at least 50% of the words
cat(sprintf("%g %% entries needed to cover 50%% of the words.\n", round(half_index/nrow(frequencies)*100,2)))

ninty_index <- min(which(cumulative_freq >= total_words*0.9)) # index of the first entry that covers at least 90% of the words
cat(sprintf("%g %% entries needed to cover 90%% of the words.\n", round(ninty_index/nrow(frequencies)*100,2)))

# Q4. How do you evaluate how many of the words come from foreign languages? 
library(cld2) # both cld3 and cld2 work like shite tbf
foreign_words <- detect_language(words)
foreign_count <- sum(foreign_words != "en", na.rm = T)
cat(sprintf("%.2f%% of the words come from foreign languages.\n", foreign_count/length(words)*100))

# Q5. Can you think of a way to increase the coverage? Identifying words that may not be in the corpora 
##    or using a smaller number of words in the dictionary to cover the same number of phrases?
# NAH


### WEEK 2 -MODELLING ###
# 1. Load text corpus and preprocess
eng_twitter <- readLines("9. Final capstone/data/en_US/en_US.twitter.txt")
eng_blogs <- readLines("9. Final capstone/data/en_US/en_US.blogs.txt")
eng_news <- readLines("9. Final capstone/data/en_US/en_US.news.txt")
eng_all <- c(eng_twitter,eng_blogs,eng_news)

text <- tolower(eng_all)
text <- gsub("[[:punct:]]", "", text) # remove punctuation

words <- strsplit(text, "\\s+") # remove spaces
# or subset if computationally too intense
subset <- words[sample.int(length(words),200000)] # pick 4k (5%) random sentences


# 2. Calculate n-grams
bigrams <- lapply(subset, function(x) stringr::str_c(x[-length(x)], x[-1], sep = " ")) # "manual" way (probably faster)
trigrams <- lapply(subset, function(x) tau::textcnt(x, method = "string", n = 3)) # using pre-made fun
tetragrams <- lapply(subset, function(x) tau::textcnt(x, method = "string", n = 4))

bi_freqs <- data.frame(bigram = unlist(bigrams)) %>% count(bigram)
tri_freqs <- data.frame(trigram = names(unlist(trigrams)), n = unname(unlist(trigrams))) %>% 
  group_by(trigram) %>% summarise(n=sum(n), .groups = 'drop')
tetra_freqs <- data.frame(tetragram = names(unlist(tetragrams)), n = unname(unlist(tetragrams))) %>%
  group_by(tetragram) %>% summarise(n=sum(n), .groups = 'drop')

# 3. Handle unseen n-grams
## To handle unseen n-grams in a language model, you can use smoothing techniques like the "add-k smoothing": we add a small k constant
## to each n-gram count. This "smooths" the frequency distribution, so that rare n-grams are not assigned a probability of zero.
k <- 0.1 # Set k value for smoothing
bi_freqs <- bi_freqs %>% mutate(prob = (n + k) / (sum(n) + k * n_distinct(bigram)))
tri_freqs <- tri_freqs %>% mutate(prob = (n + k) / (sum(n) + k * n_distinct(trigram)))
tetra_freqs <- tetra_freqs %>% mutate(prob = (n + k) / (sum(n) + k * n_distinct(tetragram)))




