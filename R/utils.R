#' Get variable attribute labels
#' 
#' Helper function
atr <- function(x, ...) {
	paste(sprintf(x, ...), c("Name", "Value"), sep = ".")
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