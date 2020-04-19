# backoff model with no discounting
library(magrittr)
library(data.table)
library(tokenizers)
library(stringi)

path <- "./data/sample/twitter_sample.txt"

DT <- path %>%
    readLines() %>%
    stri_split_boundaries(type = "sentence") %>%
    unlist(use.names = FALSE) %>%
    # tokens seem to have a problem with urls
    tokenize_ngrams(
        lowercase = TRUE,
        n = 5,
        n_min = 2,
    ) %>%
    unlist() %>%
    data.table()

# still want to bundle these next few commands together
DT <- DT[, .N, by = "."]

names(DT) <- c("ngram", "freq")

# keep frequency in there, get rid of it later
DT <- DT[, .(
    start = stri_replace_last_regex(ngram, " [a-z|'|0-9]+", ""),
    end = stri_extract_last_words(ngram),
    freq = freq
)]

# well that was easy
DT <- DT[, group_freq := .N, by = start]
DT <- DT[, dumb_prob := freq /group_freq]

# here is how you return a DT with the max prob end word for a string:
# key(DT, start)
# DT["search string", .(end, max(dumb_prob))]
