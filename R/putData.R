#' Put address into DB
#' 
#' Put address into DB. This takes an output from GetAddresses and puts it into the DB.
#' 
#' @param addrList A data.frame containing the output from GetAddresses(). This is usually either a single row describing just one address, or several rows describing multiple addresses in the same street.
#' @param DB a dplyr src_sqlite() object
#' @param tblName The name of the tbl in the DB to write to
#' @export

putAddress <- function(
  addrList,
  DB,
  tblName = "address"
) {
  conn <- DB$con
  address <- tbl(DB, tblName)
  
  for (i in 1:nrow(addrList)) {
    if (exists("coords")) {
      coords <- rbind(
        coords,
        data.frame(t(unlist(GetCoords(addrList$WKT[[i]]))))
      )
    } else {
      coords <- data.frame(t(unlist(GetCoords(addrList$WKT[[i]]))))
    }
  }
  
  addrList <- cbind(addrList, coords)
  rm(coords)
  
  addrList <- addrList %>%
    rename(c(
    "PostalArea" = "Postal_area",
    "PostalCode" = "Postal_code",
    "StreetName" = "Street_name",
    "StreetNum" = "Street_number",
    "RT901" = "Long_rt90",
    "RT902" = "Lat_rt90",
    "WGS841" = "Long_wgs84",
    "WGS842" = "Lat_wgs84"
  )) %>%
    select(-WKT) %>%
    mutate(Timestamp = Sys.time())
  
  for (i in 1:nrow(addrList)) {
    insert(address, addrList[i,], conn, create_id = TRUE, idcol = "Id")
  }
}