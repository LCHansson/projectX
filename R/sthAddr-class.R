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
      
      return(max(0,index))
    },
    getIndex_Fritids = function(...) {
      # Get data
      data <- GetNearestServiceUnit("081488a6-d541-4704-8d07-8d38ee435dd3", .self$RT90, n=1, groups=FALSE)
      
      # Get distance
      data$GeographicalDistance <- sapply(1:nrow(data), function(i) {
        GetRTDistance(.self$RT90, c(as.integer(data[i,"GeographicalPosition.X"]), as.integer(data[i,"GeographicalPosition.Y"])))
      })
      
      index <- 100 - (mean(data$GeographicalDistance) / 1000) * 100
      
      return(max(0,index))
    },
    getIndex_Festlokal = function(...) {
      # Get data
      data <- GetNearestServiceUnit("ef2defe3-e53f-4669-9b19-3d45b33129ed", .self$RT90, n=1, groups=FALSE)
      
      # Get distance
      data$GeographicalDistance <- sapply(1:nrow(data), function(i) {
        GetRTDistance(.self$RT90, c(as.integer(data[i,"GeographicalPosition.X"]), as.integer(data[i,"GeographicalPosition.Y"])))
      })
      
      index <- 100 - (mean(data$GeographicalDistance) / 1000) * 100
      
      return(max(0,index))
    },
    getIndex_Sjukhus = function(...) {
      # Get data
      index <- 0      
      return(max(0,index))
    },
    getIndex_Vardcentral = function(...) {
      # Get data
      index <- 0
      
      return(max(0,index))
    },
    
    getIndex_Traveltime = function(...) {
      # Get data
      traveltime <- travelTimeFromPos(.self$WGS84)
            
      index <- 100 - (min(traveltime,90) / 90) * 100
      
      return(max(0,index))
    },
    
    getIndex_Library = function(...) {
      # Get data
      data <- GetNearestServiceUnit("9ff1c3b5-f2e9-45b4-a478-caa09d923417", .self$RT90, n=1, groups=FALSE)
      
      # Get distance
      data$GeographicalDistance <- sapply(1:nrow(data), function(i) {
        GetRTDistance(.self$RT90, c(as.integer(data[i,"GeographicalPosition.X"]), as.integer(data[i,"GeographicalPosition.Y"])))
      })
      
      index <- 100 - (mean(data$GeographicalDistance) / 1000) * 100
      
      return(max(0,index))
    },
    getIndex_Museums = function(...) {
      # Get data
      data <- GetNearestServiceUnit("ad53d167-dba4-4000-b9b0-89380b89e831", .self$RT90, n=3, groups=FALSE)
      
      # Get distance
      data$GeographicalDistance <- sapply(1:nrow(data), function(i) {
        GetRTDistance(.self$RT90, c(as.integer(data[i,"GeographicalPosition.X"]), as.integer(data[i,"GeographicalPosition.Y"])))
      })
      
      index <- 100 - (mean(data$GeographicalDistance) / 4000) * 100
      
      return(max(0,index))
    },
    getIndex_Restaurants = function(...) {
      ## Placeholder function!
      index <- 0
#       index <- 100 - (mean(data$GeographicalDistance) / 1000) * 100
      
      return(max(0,index))
    },
    getIndex_Badplats = function(...) {
      # Get data
      data <- GetNearestServiceUnit("c1aca600-af0c-43f9-bf6c-cd7b4ec4b2d1", .self$RT90, n=1, groups=FALSE)
      
      # Get distance
      data$GeographicalDistance <- sapply(1:nrow(data), function(i) {
        GetRTDistance(.self$RT90, c(as.integer(data[i,"GeographicalPosition.X"]), as.integer(data[i,"GeographicalPosition.Y"])))
      })
      
      index <- 100 - (mean(data$GeographicalDistance) / 2000) * 100
      
      return(max(0,index))
    },
    getIndex_Sports = function(...) {
      # Get data
      data <- GetNearestServiceUnit(3, .self$RT90, n=3)
      
      # Get distance
      data$GeographicalDistance <- sapply(1:nrow(data), function(i) {
        GetRTDistance(.self$RT90, c(as.integer(data[i,"GeographicalPosition.X"]), as.integer(data[i,"GeographicalPosition.Y"])))
      })
      
      index <- 100 - (mean(data$GeographicalDistance) / 2000) * 100
      
      return(max(0,index))
    }
  )
)
