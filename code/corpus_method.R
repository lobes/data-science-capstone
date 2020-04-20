library(quanteda)
library(readtext)
library(data.table)
library(stringi)
library(magrittr)
library(tokenizers)

files <- c(
    "./data/final/en_US/en_US.twitter.txt",
    "./data/final/en_US/en_US.blogs.txt",
    "./data/final/en_US/en_US.news.txt"
)

text <- readtext(files)

corp <- corpus(text)
rm(text)

corp <- corpus_reshape(corp,
                       to = "sentence",
                       use_docvars = FALSE)

word_toks <- tokenizers::tokenize_words(corp, lowercase = TRUE, strip_punct = TRUE) %>%
    tokens(remove_symbols = TRUE)
rm(corp)

tok_ngram_2 <- tokens_ngrams(word_toks, n = 2)

DFM <- dfm(tok_ngram_2)
rm(tok_ngram_2)

tok_ngram_3 <- tokens_ngrams(word_toks, n = 3)

DFM <- unlist(DFM, dfm(tok_ngram_3))
rm(tok_ngram_3)

tok_ngram_4 <- tokens_ngrams(word_toks, n = 4)

DFM <- unlist(DFM, dfm(tok_ngram_4))
rm(tok_ngram_4)

tok_ngram_5 <- tokens_ngrams(word_toks, n = 5)

DFM <- unlist(DFM, dfm(tok_ngram_5))
rm(tok_ngram_5)
rm(word_toks)

DT <- setDT(list(textstat_frequency(DFM)$feature, textstat_frequency(DFM)$frequency))

DT[, c("base", "pred") := .(stri_replace_last_regex(V1, stri_c("_", stri_extract_last_regex(V1, pattern = "[^_]+$"), "$"), ""), stri_extract_last_regex(V1, pattern = "[^_]+$"))]

DT[, V1 := NULL]
dumb_pred <- DT[order(base), head(pred, 1L), by = base]
dumb_pred <- dumb_pred[, .(base = base, pred = V1)]
setkey(dumb_pred, base)

get_dumb_pred <- function(string) {
    # pre-process the string to match DT format
    last_four_words <- string %>%
        tokenize_sentences(simplify = TRUE) %>%
        tail(1L) %>%
        tokenize_words(strip_punct = TRUE) %>%
        tokens(remove_symbols = TRUE)

    last_four_words <- as.character(last_four_words[["text1"]])
    flat_four <- stri_flatten(last_four_words, collapse = "_")

    last_three_words <- tail(last_four_words, 3L)
    flat_three <- stri_flatten(last_three_words, collapse = "_")

    last_two_words <- tail(last_four_words, 2L)
    flat_two <- stri_flatten(last_two_words, collapse = "_")

    last_one_word <- tail(last_four_words, 1L)
    flat_one <- stri_flatten(last_one_word, collapse = "_")

    if (flat_four %in% dumb_pred[, base]) {
        print(dumb_pred[base == flat_four, pred])
    } else if (flat_three %in% dumb_pred[, base]) {
        print(dumb_pred[base == flat_three, pred])
    } else if (flat_two %in% dumb_pred[, base]) {
        print(dumb_pred[base == flat_two, pred])
    } else if (flat_one %in% dumb_pred[, base]) {
        print(dumb_pred[base == flat_one, pred])
    } else {
        print("404 word not found")
    }
}
