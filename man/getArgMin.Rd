% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/classifyEmbedding_utils.R
\name{getArgMin}
\alias{getArgMin}
\title{getArgMin}
\usage{
getArgMin(M, return_colnames = TRUE, identicalNA = TRUE)
}
\arguments{
\item{M}{A matrix.}

\item{return_colnames}{Logical whether to return column names of matrix
(default TRUE). Otherwise return index.}

\item{identicalNA}{Logical whether to return NA if all values in a row are
identical (default TRUE).}
}
\value{
A vector containing the first index or column name of the
minimum values for each row of the matrix.
}
\description{
For each row in a matrix calculate the first index which gives the minimum
value
}
\keyword{internal}
