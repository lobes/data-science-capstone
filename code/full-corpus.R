# Construct full corpus
library(dplyr)
library(tm)

full_corpus <- "./data/final/en_US/" %>%
    DirSource() %>%
    VCorpus(readerControl = list(reader = plainText,
                                 language = "en"))

full_corpus <- tm_map(full_corpus, removeNumbers)
full_corpus <- tm_map(full_corpus, removePunctuation)
full_corpus <- tm_map(full_corpus, tolower)
