#' readStockholmXML
#' 
#' Reads XML-files form Stockholms stad, returns data frame
#' 
#' 
require(XML)
readStockholmXML <- function(file){
  doc <- xmlParse(f)
  
  colspec <- unlist(xpathApply(doc, "//odsxml/body/proc/branch/leaf/output/output-object/colspecs/colgroup/colspec/@type"))
  colspec[colspec == "string"] <- "character"
  
  
  
  
  header <- xpathSApply(doc, "//odsxml/body/proc/branch/leaf/output/output-object/output-head/row/header/value/text()", xmlValue)
  
  data <- xmlToDataFrame(nodes = getNodeSet(doc, "//odsxml/body/proc/branch/leaf/output/output-object/output-body/row"), colClasses=colspec)
  
  names(data) <- header
  
  return(data)
}

