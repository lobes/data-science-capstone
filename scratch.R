library(quanteda)
library(data.table)
library(readtext)

test_corpus <- corpus(readtext("./data/sample/twitter_sample.txt"))
test_dfm <- dfm(test_corpus, ngrams = 2, remove_punct = TRUE)
