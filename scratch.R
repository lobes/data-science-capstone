library(quanteda)
library(data.table)
library(readtext)
library(dplyr)
library(tokenizers)
library(stringr)

sample <- "./data/sample/twitter_sample.txt"

ngram <- sample %>%
    readLines %>%
    tokenize_ngrams(lowercase = TRUE,
                    n = 5,
                    n_min = 2) %>%
    unlist(use.names = FALSE) %>%
    data.table

names(ngram) <- c("ngram")

freq <- ngram[, .N, by = "ngram"]

# makes a new DT with a single column called 'end' that has the last word from the ngrams
split <- freq[, .(start = stri_replace_last_regex(ngram, " [a-z|'|0-9]+", ""),
                  end = stri_extract_last_words(ngram))]

# test_dt <- sample %>%
#     readLines %>%
#     data.table
# 
# text <- sample %>%
#     readLines
# 
# 
# ngrams <- test_dt %>%
#     tokenize_ngrams(lowercase = TRUE,
#                     n = 5,
#                     n_min = 2)
#     
# 
# test_text_obj <- sample %>%
#     readLines() %>%
#     paste0() %>%
#     tolower()
# 
# 

# test_corpus <- corpus(test_text_obj)
# 
# test_tokens <- test_text_obj %>%
#     tokens(what = "word",
#            remove_punct = TRUE,
#            remove_symbols = TRUE,
#            remove_numbers = FALSE,
#            remove_url = FALSE,
#            remove_separators = TRUE)
# 
# test_dfm <- dfm(test_corpus)
