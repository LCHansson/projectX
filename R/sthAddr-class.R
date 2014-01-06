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
    },
    getClosestSchools = function(n = 10) {
      x <- GetNearestServiceUnit(7, .self$RT90, n = n)
      x <- extractUnitData(x)
      x$distance <- sapply(1:nrow(x), function(i) {
        GetRTDistance(.self$RT90, c(x[i,"RT90.northing"], x[i,"RT90.easting"]))
      })
      rownames(x) <- NULL
      return(x)
    },
    getIndex_Preschools = function() {
      
      # Förskola: 1c21b680-5136-4b43-98e3-cca969d20760
      # Familjedaghem: 3a8dadd5-e10c-415c-8b37-1a25729afffa
      
      # Get the 3 nearest preschools
    	data <- GetNearestServiceUnit(1, .self$RT90, n = 3)
      
    	# TODO: Later on we can skip the step below,
    	# 	when we know which variables to use
    	d <- data.frame(
        x = as.integer(data$GeographicalPosition.X),
        y = as.integer(data$GeographicalPosition.Y),
    		quality = as.integer(data$Attributes.PreschoolForm2013Recommendation.Value)
    	)
      
    	# Add distance
      d$distance <- sapply(1:nrow(d), function(i) {
    	  GetRTDistance(.self$RT90, c(
          as.integer(d[i, "x"]),
          as.integer(d[i, "y"])
        ))
    	})
      
      # Calculate index
    	d[is.na(d$quality), ]$quality <- 75
    	d[d$distance > 500, ]$distance <- 500
      index <- mean(((500 - d$distance) / 500) * d$quality / 100)
      
      return(index)
    }
  )
)