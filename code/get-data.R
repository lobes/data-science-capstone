# Download data and unzip
zip_file <- "./data/Coursera-SwiftKey.zip"
unzipped <- "./data/final/"
url <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"

if (!file.exists(zip_file)) {
    download.file(url, zip_file)
}

if (!file.exists(unzipped)) {
    unzip(zip_file, exdir = "./data/")
}
