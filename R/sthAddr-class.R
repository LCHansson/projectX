sthAddr <- setRefClass(
  "sthAddr",
  fields = list(
    name = "character",
    address = "data.frame",
    RT90 = "numeric",
    WGS84 = "numeric"
  ),
  methods = list(
    initialize = function(street, number) {
      .self$name <- "Unnamed STH Address object"
      
      .self$address <- getAddress(street, number)
      
      .coords <- getCoords(.self$address$WKT)
      
      .self$RT90 <- round(.coords$RT90)
      .self$WGS84 <- .coords$WGS84
      
    },
    getAddress = function(street, number) {
      #browser()
      addresses <- OpenSth::GetAddresses(streetName=street, streetNumPattern=number)
      if (nrow(addresses) == 0){
      	addresses <- OpenSth::GetAddresses(streetName=street, 
      									streetNumPattern=ifelse(class(number) %in% c("integer","double", "numeric"), 
      															number-1, 
      															"*"))
      }
      
      if (nrow(addresses) == 0){
      	addresses <- OpenSth::GetAddresses(streetName=street, streetNumPattern="*")
      }
      return(addresses[1,])
    },
    getCoords = function(WKT) {
      .coords <- GetCoords(WKT)
      return(.coords)
    },
    getParkingPlaces = function() {
      lvws_get_parking_places(streetName = .self$address$StreetName)
    }
  )
)