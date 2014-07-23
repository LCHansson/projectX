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

#' Create an empty SQL table
#' 
#' @export

createDBTbl <- function(conn, tbl, key = NULL) {
  if ("src_sqlite" %in% class(conn))
    conn <- conn$con
  
  cols <- sapply(tbl, function(x) {
    cls <- switch(
      class(x),
      "integer" = "INTEGER",
      "numeric" = "REAL",
      "character" = "TEXT",
      "BLOB")
    
    return(c(cls))
  })
  
  colString <- paste(sapply(names(cols), function(name) {
    type <- cols[[name]]
    if (name %in% key)
      type <- paste(type, "PRIMARY KEY ASC")
    
    return(paste(name, type, sep = " "))
  }), collapse = ", ")
  
  string <- paste0('CREATE TABLE IF NOT EXISTS "', substitute(tbl), '"  (', colString, ')')
  
  dbSendQuery(
    conn = conn,
    statement = string
  )
  invisible(collapse(tbl))
}

#' @export
dropDBTbl <- function(conn, name) {
  if ("src_sqlite" %in% class(conn))
    conn <- conn$con
  
  name <- as.character(substitute(name))
  string <- paste0('DROP TABLE IF EXISTS ', name)
  
  invisible(dbSendQuery(
    conn = conn,
    statement = string
  ))
}

#' Insert rows at the bottom of a dplyr (local) tbl
#' 
#' Insert one or several rows at the bottom of a dplyr tbl. The function can also automatically create a new ID for the item in question.
#' @export

insert <- function(tbl, row, conn, create_id = FALSE, idcol = NULL, return_tbl = TRUE) {
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
  
  # If the data is a local tbl: Bind the row(s) to the data and return it
  if (!"tbl_sql" %in% class(tbl)) {
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
  } else {
    
    # If the data is in a remote sql DB: pass an INSERT statement to
    # the database
    
    dbSendQuery(
      conn = conn,
      statement = paste0("INSERT INTO ", as.character(tbl$from),
                         " VALUES (", sqlString(row),")")
    )
    collapse(tbl)
  }
  
  return(tbl)
}


#' NULL handler operator
#' 
#' Return the RHS statement if the LHS statement is identical to NULL. Otherwise, return LHS.
#' 
#' @export

`%||%` <- function(a, b) {
  if (is.null(a)) return(b)
  a
}

#' "falsy" statement handler operator (similar to '||' in javaScript)
#' 
#' Return the RHS statement if the LHS statement is 'falsy', i.e. identical to NULL, NA, NaN, 0, "" or FALSE. This operator is more permissive than %||%, which only returns RHS if LHS is identical to, exactly, NULL. Use with caution.
#' 
#' @export

`%|%` <- function(a, b) {
  if (is.null(a)) return(b)
  if (is.na(a)) return(b)
  if (a == FALSE) return(b)
  if (a == 0) return(b)
  if (a == "") return(b)
  b
}

#' Build URL
#'
#' Build API query URL
#'
#' @param url
#' @param path
#' @param params list of named parameters
#' @export

build_url <- function(url, path, params) {
  # Remove leadning and trailing slashes from all URL components
  url <- str_replace_all(url, "^[/]+|[/]+$", "")
  path <- str_replace_all(path, "^[/]+|[/]+$", "")
  
  # Create the URL and param parts
  full_url <- paste(url, paste(path, collapse="/"), sep="/")
  full_params <- paste(names(params),params, sep="=", collapse="&")
  
  # Create and return the full query
  full_query <- paste(full_url, full_params, sep="?")
  return(full_query)
}


#' Calculate distance in RT90 2.5
#'
#' Calculate distance in RT90 2.5
#'
#' @param c1 C1
#' @param c2 C2
#' @export

GetRTDistance <- function(c1, c2) {
  sqrt(
    (c1[1] - c2[1])^2 + (c1[2] - c2[2])^2
  )
}


#' Convert list to table
#'
#' Flattens out a nested list
#'
#' @param x list
#' @param ... arguments passed to `data.frame()
#' @export
list_to_table <- function(x, ...) {
  do.call(
    "rbind.fill",
    lapply(x, function(y) {
      data.frame(t(unlist(y)), ...)
    })
  )
}

#' Remove list fields
#'
#' Remove named fields (attributes) from a list.
#' Helpful to use when tidying converted JSON-objects.
#'
#' @param lst list
#' @param names field names
remove_list_fields <- function(lst, names) {
  lapply(lst, function(x) {
    for(name in names) {
      x[[name]] <- NULL
    }
    return(x)
  })
}