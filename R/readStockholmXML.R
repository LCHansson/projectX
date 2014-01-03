#' readStockholmXML
#' 
#' Reads XML-files form Stockholms stad, returns data frame
#' 
#' @param file file path
#' 
#' @export
require(XML)
readStockholmXML <- function(file){
  doc <- xmlParse(file)
  
  colspec <- unlist(xpathApply(doc, "//odsxml/body/proc/branch/leaf/output/output-object/colspecs/colgroup/colspec/@type"))
  colspec[colspec == "string"] <- "character"
  
  
  
  
  header <- xpathSApply(doc, "//odsxml/body/proc/branch/leaf/output/output-object/output-head/row/header/value/text()", xmlValue)
  
  data <- xmlToDataFrame(nodes = getNodeSet(doc, "//odsxml/body/proc/branch/leaf/output/output-object/output-body/row"), colClasses=colspec)
  
  names(data) <- header
  for (i in 1:ncol(data)){
    if (class(data[[i]]) == "factor")
      data[[i]] <- as.character(data[[i]])
  }
  
  return(data)
}

