% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/classifyEmbedding_utils.R
\name{getBinaryErrorFromPredictions}
\alias{getBinaryErrorFromPredictions}
\title{getBinaryErrorFromPredictions}
\usage{
getBinaryErrorFromPredictions(pred, labels)
}
\arguments{
\item{pred}{Is a matrix of class label predictions.}

\item{labels}{Is a named vector of true labels.}
}
\value{
A sparse binary error matrix.
}
\description{
Compute binary error between predicted labels and true labels
}
\keyword{internal}
