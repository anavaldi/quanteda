
#' join tokens function
#' 
#' For a set of tokens, given a set of token sequences, join the tokens matching the sequences.
#' @param x tokens or tokenizedTexts object
#' @param ... additional arguments passed to other methods
#' @keywords internal deprecated
#' @export
joinTokens <- function(x, ...) {
    .Deprecated("tokens_compound")
    UseMethod("tokens_compound")
}

# #' @rdname joinTokens
# #' @export
# joinTokens.tokenizedTexts <- function(x, ...) {
#     as.tokenizedTexts(joinTokens(as.tokens(x), ...))
# }
# 
# 
# #' @rdname joinTokens
# #' @param sequences features to concatenate, a list of characters
# #' @param concatenator character used for joining tokens
# #' @inheritParams valuetype
# #' @param case_insensitive if \code{TRUE}, ignore case when matching
# #' @param verbose display progress
# #' @author Kohei Watanabe and Kenneth Benoit
# #' @examples
# #' 
# #' toks <- tokens(data_corpus_inaugural, removePunct = TRUE)
# #' seqs <- list(c('foreign', 'polic*'), c('United', 'States'))
# #' kwic(toks, 'fUnited_States', window = 1) # no exisit
# #' kwic(toks, 'foreign_policy', window = 1) # no exisit
# #' toks <- joinTokens(toks, seqs, "_", 'glob')
# #' kwic(toks, 'United_States', window = 1)
# #' kwic(toks, 'foreign_policy', window = 1)
# #' kwic(toks, c('foreign', 'policy'), window = 1) # no longer exisit
# #' kwic(toks, c('united', 'states'), window = 1) # no longer exisit
# #'                
# #' @export
# joinTokens.tokens <- function(x, sequences, concatenator = "_", 
#                               valuetype = c("glob", "fixed", "regex"), 
#                               verbose = FALSE, case_insensitive = TRUE, ...) {
#     
#     valuetype <- match.arg(valuetype)
#     
#     # Initialize
#     seqs <- as.list(sequences)
#     seqs <- seqs[lengths(seqs) > 1] # drop single words
#     types <- types(x)
#     
#     # Convert to regular expressions, then to fixed
#     if (valuetype %in% c("glob"))
#         seqs <- lapply(seqs, glob2rx)
#     if (valuetype %in% c("glob", "regex")) {
#         # Generates all possible patterns of keys
#         seqs_fixed <- regex2fixed4(seqs, index(types, valuetype, case_insensitive))
#     } else {
#         seqs_fixed <- seqs
#     }
#     if(verbose) message(sprintf('Join %d pairs of tokens', length(seqs_fixed)))
#     if(length(seqs_fixed) == 0) return(x) # do nothing
#     
#     seqs_id <- lapply(seqs_fixed, fmatch, table=types)
#     seqs_type <- sapply(seqs_fixed, paste0, collapse = concatenator)
#     ids <- fmatch(seqs_type, types)
#     res <- qatd_cpp_replace_int_list(x, seqs_id, ids, length(types) + 1)
# 
#     # Select and types to add
#     ids_new <- res$id_new
#     names(ids_new) <- seqs_type
#     ids_new <- sort(ids_new)
#     types <- c(types, names(ids_new[length(types) < ids_new]))
#     
#     tokens <- res$text
#     attributes(tokens) <- attributes(x)
#     types(tokens) <- types
#     
#     return(tokens)
#     
# }
# 
