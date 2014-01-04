sthAddr <- setRefClass(
  "sthAddr",
  fields = list(
    address = "data.frame",
    RT90 = "numeric",
    WGS84 = "numeric"
  ),
  methods = list(
    initialize = function(street, number) {
      .self$address <- getAddress(street, number)
      
      .coords <- getCoords(.self$address$WKT)
      
      .self$RT90 <- round(.coords$RT90)
      .self$WGS84 <- .coords$WGS84
      
    },
    getAddress = function(street, number) {
      addresses <- LvWS::GetAddresses(streetName=street, streetNumPattern=number)
      return(addresses)
    },
    getCoords = function(WKT) {
      .coords <- GetCoords(WKT)
      return(.coords)
    }
  )
)