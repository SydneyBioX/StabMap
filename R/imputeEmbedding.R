#' Impute values using StabMap joint embedding
#'
#' Performs naive imputation of values from the list of mosaic data
#' and joint embedding from StabMap.
#'
#' @param assay_list List of mosaic data from which to perform imputation.
#' @param embedding Joint embedding from which to extract nearest neighbour
#' relationships.
#' @param reference Character vector of cell names to treat as reference cells.
#' @param query Character vector of cell names to treat as query cells.
#' @param neighbours Number of nearest neighbours to consider (default 5).
#' @param fun function (default `mean`) to aggregate nearest neighbours'
#' imputed values.
#'
#' @return List containing imputed values from each assay_list
#' data matrix which contains reference cells.
#'
#' @examples
#' set.seed(2021)
#' assay_list <- mockMosaicData()
#' lapply(assay_list, dim)
#'
#' # stabMap
#' out <- stabMap(assay_list,
#'   ncomponentsReference = 20,
#'   ncomponentsSubset = 20
#' )
#'
#' # impute values
#' imp <- imputeEmbedding(assay_list, out)
#'
#' # inspect the imputed values
#' lapply(imp, dim)
#' imp[[1]][1:5, 1:5]
#'
#' @export
imputeEmbedding <- function(assay_list,
                            embedding,
                            reference = Reduce(union, lapply(assay_list, colnames)),
                            query = Reduce(union, lapply(assay_list, colnames)),
                            neighbours = 5,
                            fun = mean) {

  has_reference <- lapply(
    assay_list, function(x) any(reference %in% colnames(x))
  )

  imputed_list <- list()

  for (assayName in names(assay_list)) {
    if (!has_reference[[assayName]]) next

    assayMat <- assay_list[[assayName]]

    referenceCells <- intersect(reference, colnames(assayMat))

    knn_out <- queryNamedKNN(
      embedding[referenceCells, ], embedding[query, ], neighbours
    )

    imputedList <- apply(knn_out, 2, function(knnval) {
      assayMat[, knnval]
    }, simplify = FALSE)

    if (!methods::is(imputedList[[1]], "matrix")) {
      imputedArray <- slam::as.simple_sparse_array(do.call(cbind, imputedList))
      dim(imputedArray) <- c(dim(imputedList[[1]]), length(imputedList))

      imputedMeans <- slam::drop_simple_sparse_array(
        slam::rollup(imputedArray, 3, NULL, fun)
      )
      imputedMeans <- methods::as(
        methods::as(methods::as(
          methods::as(
            imputedMeans, "array"
          ), "dMatrix"
        ), "generalMatrix"),
        "CsparseMatrix"
      )
    } else {
      imputedArray <- abind::abind(imputedList, along = 3)

      imputedMeans <- apply(imputedArray, seq_len(2), fun)
    }

    colnames(imputedMeans) <- rownames(knn_out)
    rownames(imputedMeans) <- rownames(assayMat)

    imputed_list[[assayName]] <- imputedMeans
  }

  return(imputed_list)
}
