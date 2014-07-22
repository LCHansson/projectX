#' Get variable attribute labels
#' 
#' Helper function
atr <- function(x, ...) {
	paste(sprintf(x, ...), c("Name", "Value"), sep = ".")
}

#' Create a string for SQL INSERTion
#' @export

sqlString <- function(vals) {
  paste(
    sapply(vals, function(val) {
      if (is.numeric(val) | any(c("POSIXct", "POSIXlt") %in% class(val)))
        return(val)
      else
        return(paste0("'", val, "'"))
    }),
    sep = "",
    collapse = ", "
  )
}

#' Insert rows at the bottom of a dplyr (local) tbl
#' 
#' Insert one or several rows at the bottom of a dplyr tbl. The function can also automatically create a new ID for the item in question.
#' @export

insert <- function(tbl, row, create_id = FALSE, idcol = NULL, return_tbl = TRUE) {
  idcol <- idcol %||% "Id"
  if (!"tbl_sql" %in% class(tbl)) {
    tblnms <- names(tbl)
  } else {
    tblnms <- names(collect(head(tbl)))
  }
  
  # Error handling
  if (!is.null(names(row))) {
    # If ROW is named, check to see that the names match
    rownms <- names(row)
    if (create_id)
      rownms <- append(rownms, idcol)
    
    if (!identical(sort(names(tbl)), sort(rownms)))
      stop("The names of the TBL and the ROW are not identical.
           Please change the names of the ROW argument or submit
           a ROW argument without names.")
  } else {
    # If ROW is _not_ named, check that the length of the args matches.
    rowlng <- length(row)
    if (create_id) rowlng <- rowlng + 1
    if (rowlng > ncol(tbl))
      stop("The length of ROW is larger than the number of columns in TBL.")
  }
  
  if (length(unique(sapply(row, length))) > 1)
    stop("The number of elements in each supplied column in the ROW argument is not identical.")
  
  
  # Convert vectors to lists to simplify data handling
  if (is.vector(row))
    row <- as.list(row)
  
  # Name handling: Name unnamed data
  if (is.null(names(row))) {
    nms <- names(tbl)
    if (create_id) {
      nms <- nms[!nms %in% idcol]
    }
    names(row) <- nms
  }
  
  # Create an index if none is supplied
  if (create_id) {
    # Error handling
    if (!idcol %in% tblnms) {
      stop("The submitted IDCOL is not in the names of the TBL argument.")
    }
    
    # Handle empty tables
    if (nrow(tbl) == 0) {
      max_id <- 0
    } else {
      max_id <- max(collect(select(tbl, matches(idcol))))
    }
    row[[idcol]] <- max_id + 1:unique(sapply(row, length))
  }
  
  # Bind the row(s) to 
  if (is.data.frame(row)) {
    tbl <- rbind_all(list(tbl, row))
  } else {
    tbl <- rbind(tbl, row)
    if (ncol(tbl) > length(row))
      warning("Elements in ROW outside the range of the TBL were dropped.")
  }
  
  # Convert to a dplyr tbl_df
  if (return_tbl) {
    tbl <- tbl_df(tbl)
  }
  
  return(tbl)
}


#' NULL handler operator
#' 
#' @export

`%||%` <- function(a, b) {
  if (is.null(a)) return(b)
  a
}