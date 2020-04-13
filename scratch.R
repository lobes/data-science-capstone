library(quanteda)
library(data.table)
library(readtext)
library(dplyr)
library(tokenizers)
library(stringi)

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
