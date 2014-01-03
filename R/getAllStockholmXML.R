#' getAllStockholmXML
#' 
#' returns a list containing all xml files from http://xml.stockholm.se as data frames
#' 
#' @export
getAllStockholmXML <- function(){
  uri <- "http://xml.stockholm.se"
  sthlmXML <- htmlParse(uri)
  file.names <- unlist(xpathApply(sthlmXML, "//html/body/table/tr/td/p/a/@href"))
  xml.data.list <- list()
  for (i in 1:length(file.names)){
    xml.data.list[[file.names[[i]]]] <- readStockholmXML(file.path(uri, file.names[i]))
  }
  return(xml.data.list)
}
