#' Get variable attribute labels
#' 
#' Helper function
atr <- function(x, ...) {
	paste(sprintf(x, ...), c("Name", "Value"), sep = ".")
}