# Sample each data set and save each as a text file for later use

library(dplyr)
set.seed(1337)

"./data/final/en_US/en_US.blogs.txt" %>%
    readLines() %>%
    sample(size = 5000) %>%
    writeLines("./data/sample/blogs_sample.txt")

"./data/final/en_US/en_US.news.txt" %>%
    readLines() %>%
    sample(size = 5000) %>%
    writeLines("./data/sample/news_sample.txt")

"./data/final/en_US/en_US.twitter.txt" %>%
    readLines(skipNul = TRUE) %>%
    sample(size = 5000) %>%
    writeLines("./data/sample/twitter_sample.txt")
