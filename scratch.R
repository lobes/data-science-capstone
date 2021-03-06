library(data.table)
library(dplyr)
library(tokenizers)
library(stringr)
library(stringi)

sample <- "./data/sample/twitter_sample.txt"

twit_sample <- sample %>%
    readLines() %>%
    stri_split_boundaries(type = "sentence") %>%
    unlist(use.names = FALSE) %>%
    # tokens seem to have a problem with urls
    tokenize_ngrams(
        lowercase = TRUE,
        n = 5,
        n_min = 2
    ) %>%
    unlist() %>%
    data.table()

## incorrect, didn't take into account sentence boundaries
# ngram <- sample %>%
#     readLines %>%
#     tokenize_ngrams(lowercase = TRUE,
#                     n = 5,
#                     n_min = 2) %>%
#     unlist(use.names = FALSE) %>%
#     data.table

twit_sample <- twit_sample[, .N, by = "."]

# want to figure out how to chain this into everything, probably in DT tutorials
names(twit_sample) <- c("ngram", "freq")

# make a new DT with 4 columns: n-1 gram, last word of ngram, frequency and unaltered discount
twit_sample <- twit_sample[, .(
    start = stri_replace_last_regex(ngram, " [a-z|'|0-9]+", ""),
    end = stri_extract_last_words(ngram),
    freq = freq,
    disc = rep(1, nrow(twit_sample))
)]

# break up the DT by ngram size to work on the discount
# there seems to be a better (more elegant) way of doing this with DTs and efficient subsetting
two_gram <- twit_sample[stri_count_words(start) == 1]
three_gram <- twit_sample[stri_count_words(start) == 2]
four_gram <- twit_sample[stri_count_words(start) == 3]
five_gram <- twit_sample[stri_count_words(start) == 4]

# when the subsetting gets sorted this function should be able to do all the ngram lengths if it takes an argument for ngram length
discount_five_gram <- function() {

    # reset discount in case function is run twice
    five_gram[, c("disc", "prob") := 1]

    # apparently if the frequency is over 5 for the ngram then it's reliable enough
    for (i in 5:1) { # going backwards
        curr_freq <- i
        next_freq <- i + 1

        # do a count on rows that match the ith frequency and ith plus one
        curr_count <- five_gram[freq == curr_freq, .N]
        next_count <- five_gram[freq == next_freq, .N]

        # calculate the discount for the ith frequency
        curr_disc <- (next_freq / curr_freq) * (next_count / curr_count)

        # have to reset some discounts to 1 due to quirk of sample data having equal numbers of 3, 4, and 5 frequency 5-grams
        five_gram[freq == curr_freq, disc := curr_disc][disc > 1, disc := 1]
    }
    # calculate leftover for each 'start' and fix the quirk again
    five_gram[, leftover := (1 - freq * disc / sum(freq)), keyby = start][disc == 1, leftover := 0]
    
    # 'get it done' solution to 5-gram probability
    five_gram[, group_freq := sum(freq), by = start]
    five_gram[, prob := freq/group_freq]
}

# get ready for janky copies of the 5-gram function
discount_four_gram <- function() {

    # reset discount in case function is run twice
    four_gram[, disc := 1]

    # apparently if the frequency is over 5 for the ngram then it's reliable enough
    for (i in 5:1) { # going backwards
        curr_freq <- i
        next_freq <- i + 1

        # do a count on rows that match the ith frequency and ith plus one
        curr_count <- four_gram[freq == curr_freq, .N]
        next_count <- four_gram[freq == next_freq, .N]

        # calculate the discount for the ith frequency
        curr_disc <- (next_freq / curr_freq) * (next_count / curr_count)

        # kept the fix in just in case
        four_gram[freq == curr_freq, disc := curr_disc][disc > 1, disc := 1]
    }
    # calculate leftover for each 'start' and fix the quirk again
    four_gram[, leftover := (1 - freq * disc / sum(freq)), by = start][disc == 1, leftover := 0]
}

discount_three_gram <- function() {
    
    # reset discount in case function is run twice
    three_gram[, disc := 1]
    
    # apparently if the frequency is over 5 for the ngram then it's reliable enough
    for (i in 5:1) { # going backwards
        curr_freq <- i
        next_freq <- i + 1
        
        # do a count on rows that match the ith frequency and ith plus one
        curr_count <- three_gram[freq == curr_freq, .N]
        next_count <- three_gram[freq == next_freq, .N]
        
        # calculate the discount for the ith frequency
        curr_disc <- (next_freq / curr_freq) * (next_count / curr_count)
        
        # kept the fix in just in case
        three_gram[freq == curr_freq, disc := curr_disc][disc > 1, disc := 1]
    }
    # calculate leftover for each 'start' and fix the quirk again
    three_gram[, leftover := (1 - freq * disc / sum(freq)), by = start][disc == 1, leftover := 0]
}

discount_two_gram <- function() {
    
    # reset discount in case function is run twice
    two_gram[, disc := 1]
    
    # apparently if the frequency is over 5 for the ngram then it's reliable enough
    for (i in 5:1) { # going backwards
        curr_freq <- i
        next_freq <- i + 1
        
        # do a count on rows that match the ith frequency and ith plus one
        curr_count <- two_gram[freq == curr_freq, .N]
        next_count <- two_gram[freq == next_freq, .N]
        
        # calculate the discount for the ith frequency
        curr_disc <- (next_freq / curr_freq) * (next_count / curr_count)
        
        # kept the fix in just in case
        two_gram[freq == curr_freq, disc := curr_disc][disc > 1, disc := 1]
    }
    # calculate leftover for each 'start' and fix the quirk again
    two_gram[, leftover := (1 - freq * disc / sum(freq)), by = start][disc == 1, leftover := 0]
}

# run the discount functions
discount_five_gram()
discount_four_gram()
discount_three_gram()
discount_two_gram()

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
