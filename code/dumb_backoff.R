# backoff model with no discounting
library(magrittr)
library(data.table)
library(tokenizers)
library(stringi)

# path <- "./data/sample/twitter_sample.txt"
# 
# DT <- samples %>%
#     lapply(readLines) %>%
#     stri_split_boundaries(type = "sentence") %>%
#     unlist(use.names = FALSE) %>%
#     # tokens seem to have a problem with urls
#     tokenize_ngrams(
#         lowercase = TRUE,
#         n = 5,
#         n_min = 2,
#     ) %>%
#     unlist() %>%
#     data.table()
# 
# # still want to bundle these next few commands together
# DT <- DT[, .N, by = "."]
# 
# names(DT) <- c("ngram", "freq")
# 
# # keep frequency in there, get rid of it later
# DT <- DT[, .(
#     start = stri_replace_last_regex(ngram, " [a-z|'|0-9]+", ""),
#     end = stri_extract_last_words(ngram),
#     freq = freq
# )]
# 
# # well that was easy
# DT <- DT[, group_freq := .N, by = start]
# DT <- DT[, dumb_prob := freq / group_freq]

# here is how you return a DT with the max prob end word for a string:
# key(DT, start)
# DT["search string", .(end, max(dumb_prob))]

# try something fancy
files <- c(
    "./data/final/en_US/en_US.twitter.txt",
    "./data/final/en_US/en_US.blogs.txt",
    "./data/final/en_US/en_US.news.txt"
)

DT <- files %>%
    lapply(readLines, skipNul = TRUE)
    # unlist() %>%
    # tokenize_sentences() %>%
    # unlist() %>%
    # tokenize_ngrams(n = 5L, n_min = 2L) %>%
    # unlist() %>%
    # as.data.table() %>%
    # na.omit

DT[, freq := .N, by = .]

DT[, c("base", "pred") := .(stri_replace_last_regex(., stri_c(" ", stri_extract_last_words(.), "$"), ""), stri_extract_last_words(.))]

setkey(DT, base)[, group_freq := .N, by = base][, dumb_prob := freq / group_freq][, c(".", "freq", "group_freq") := NULL]

get_dumb_pred <- function(string) {
    # pre-process the string to match DT format
    last_five_words <- string %>%
        unlist() %>%
        tokenize_sentences() %>%
        unlist() %>%
        tail(n = 1L) %>%
        tokenize_words(simplify = TRUE) %>%
        tail(n = 4L) %>%
        stri_flatten(collapse = " ")

    # now have a character vector containing the individual words from the last
    print(DT[base == last_five_words, .(dumb_prob, pred)][order(-dumb_prob), head(pred, 1L)])
}
