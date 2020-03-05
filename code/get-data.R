library(readr)

url <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"

if(!file.exists("./data/Coursera-SwiftKey.zip")) {
    download.file(url, destfile = "./data/Coursera-SwiftKey.zip")
}

data <- read_csv("./data/Coursera-SwiftKey.zip")
