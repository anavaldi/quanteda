% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/corpus-methods-quanteda.R
\name{metacorpus}
\alias{metacorpus}
\alias{metacorpus<-}
\title{get or set corpus metadata}
\usage{
metacorpus(x, field = NULL)

metacorpus(x, field) <- value
}
\arguments{
\item{x}{A quanteda corpus object}

\item{field}{Metadata field name(s).  If \code{NULL} (default), return all
metadata names.}

\item{value}{new value of the corpus metadata field}
}
\value{
For \code{metacorpus}, a list of the metadata fields in the corpus. 
  If a list is not what you wanted, you can wrap the results in \link{unlist}, 
  but this will remove any metadata field that is set to \code{NULL}.
  
  For \code{metacorpus <-}, the corpus with the updated metadata.
}
\description{
Get or set the corpus-level metadata in a quanteda corpus object.
}
\examples{
metacorpus(data_corpus_inaugural)
metacorpus(data_corpus_inaugural, "source")
metacorpus(data_corpus_inaugural, "citation") <- "Presidential Speeches Online Project (2014)."
metacorpus(data_corpus_inaugural, "citation")
}
\keyword{corpus}

