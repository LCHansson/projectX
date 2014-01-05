#' Extract data from list of service units
#' 
#' Extract data from list of units taken from the Stockholm Service Guide API
#' @param unitList A list of units fetched with \code{OpenSth::Get[X]ServiceUnits()}
#' @export

extractUnitData <- function(unitList) {
#   units <- data.frame(
#     name = character(),
#     street = character(),
#     number = integer(),
#     type = character(),
#     id = character(),
#     unitgroup = character(),
#     unitgroupid = integer(),
#     geographicalarea = character(),
#     email = character(),
#     tel = character(),
#     url = character(),
#     addrObj = ,
#     attribs = list()
#   )
  
  row <- list()
  
  for (i in 1:length(unitList)) {
    obj <- unitList[[i]]
    
    # Get arrtibute data
    attributes <- list_to_table(obj$Attributes)
    
    # Get address
    addr <- as.character(attributes[attributes$Id == "StreetAddress","Value"])

    # Generate data.frame row
    name <- obj$Name
    if (length(addr) == 0) { street <- ""; number <- "" } else {
      street <- str_split(addr, " \\d")[[1]][1]
      number <- as.integer(str_extract(addr, "\\d+"))
    }
    type <- obj$ServiceUnitTypes[[1]]$PluralName
    id <- obj$Id
    unitgroup <- obj$ServiceUnitTypes[[1]]$ServiceUnitTypeGroupInfo$Name
    unitgroupid <- obj$ServiceUnitTypes[[1]]$ServiceUnitTypeGroupInfo$Id
    geographicalarea <- obj$GeographicalAreas[[1]]$Name
    email <- as.character(attributes[attributes$Id == "EmailAddress","Value"])
    tel <- as.character(attributes[attributes$Id == "PhoneNumber","Value"])
    url <- as.character(attributes[attributes$Id == "Url","Value"])
    
    # Check for empty attributes
    if (length(email) == 0) { email  <- "" }
    if (length(tel) == 0) { tel  <- "" }
    if (length(url) == 0) { url  <- "" }
    
    # Attribute list: Those data that are specifik to a certain type of object
    attribs <- NULL
    
    ## Bind data to data.frame
    row[[i]] <- data.frame(
      name = name,
      street = street,
      number = number,
      type = type,
      id = id,
      unitgroup = unitgroup,
      unitgroupid = unitgroupid,
      geographicalarea = geographicalarea,
      email = email,
      tel = tel,
      url = url,
      RT90.northing = obj$GeographicalPosition[1],
      RT90.easting = obj$GeographicalPosition[2]
    )
    
  }
  
  units <- do.call("rbind", row)

  return(units)
  
}