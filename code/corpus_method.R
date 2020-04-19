library(quanteda)
library(readtext)
library(data.table)

files <- c(
    "./data/final/en_US/en_US.twitter.txt",
    "./data/final/en_US/en_US.blogs.txt",
    "./data/final/en_US/en_US.news.txt"
)

text <- readtext(files)

# DT <- setDT(text)

corp <- corpus(text)
corp <- corpus_reshape(corp, to = "sentence")
