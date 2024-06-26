#' Project and/or predict data using feature weights or a LDA model object
#'
#' This function takes a data matrix a and, depending on the class of b,
#' projects the data using feature weights, or predicts new values using
#' linear discriminant analysis (LDA) model object, or both.
#'
#' @usage a \%projpred\% b
#' @param a a matrix with colnames specified
#' @param b a matrix with rownames specified, or a lda model object, or a
#' list containing a matrix and/or a lda model object.
#'
#' @return matrix
#'
#' @keywords internal
"%projpred%" <- function(a, b) {

  if (methods::is(b, "lda")) {
    features <- rownames(b$scaling)
    am <- stats::predict(b, newdata = a[, features])$x
    return(am)
  }

  if (!is.list(b)) {
    return(a %*% b)
  }

  ab <- a %*% b[[1]]
  if (methods::is(b[[2]], "lda")) {
    am <- stats::predict(b[[2]], newdata = a)$x
  }
  if (methods::is(b[[2]], "svm")) {
    am <- attr(
      stats::predict(b[[2]], newdata = a, decision.values = TRUE),
      "decision.values"
    )
  }

  return(cbind(ab, am))
}
