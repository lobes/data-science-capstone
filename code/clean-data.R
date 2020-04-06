# Clean up the data, remove punctuation, split into n-grams
library(dplyr)
library(tm)

sample_corpus <- "./data/sample" %>%
    DirSource() %>%
    VCorpus(readerControl = list(reader = readPlain,
                                 language = "en"))

sample_corpus <- tm_map(sample_corpus, removeNumbers)
sample_corpus <- tm_map(sample_corpus, removePunctuation)
sample_corpus <- tm_map(sample_corpus, stripWhitespace)
sample_corpus <- tm_map(sample_corpus, content_transformer(tolower))

tdm <- TermDocumentMatrix(sample_corpus)

sample_unified <- paste(sample_corpus[["blogs_sample.txt"]][["content"]],
                        sample_corpus[["news_sample.txt"]][["content"]],
                        sample_corpus[["twitter_sample.txt"]][["content"]],
                        collapse = "")

sample_unified <- sample_unified %>%
    VectorSource() %>%
    VCorpus(readerControl = list(reader = readPlain,
                                 language = "en"))

