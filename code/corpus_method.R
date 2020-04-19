library(quanteda)
library(readtext)
library(data.table)
library(stringi)
library(magrittr)

files <- c(
    "./data/final/en_US/en_US.twitter.txt",
    "./data/final/en_US/en_US.blogs.txt",
    "./data/final/en_US/en_US.news.txt"
)

text <- readtext(files)

text <- stringi::stri_trans_general(text, "latin-ascii")

gc()
# DT <- setDT(text)

corp <- corpus(text)
corp <- corpus_reshape(corp, 
                       to = "sentence",
                       use_docvars = FALSE)

gc()
