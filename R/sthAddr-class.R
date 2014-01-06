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
    getIndex_Preschools = function(year = 2013, ...) {
    	
    	data <- GetNearestServiceUnit(1, .self$RT90, ...)
    	
    	# TODO: Later on we can skip the step below,
    	# 	when we know which variables to use
    	data <- data[, c(
    		# Info
    		"Id",
    		"Name",
    		"Attributes.ContactPersonEmailAddress.Value",
    		"Attributes.ContactPersonName.Value",
    		"Attributes.EmailAddress.Value",
    		"Attributes.Description.Value",
    		"Attributes.ShortDescription.Value",
    		"Attributes.OrganizationalForm.Value",
    		"Attributes.PostalCode.Value",
    		"Attributes.StreetAddress.Value",
    		"Attributes.Url.Value",
    		"GeographicalAreas.Name",
    		
    		# Measures
    		atr("Attributes.PreSchoolNumberOfChildrenPerYearWorker"),
    		atr("Attributes.PreSchoolNumberOfChildren"),
    		atr("Attributes.PreSchoolShareOfTeachersWithUniversityEducation"),
    		atr("Attributes.SvarsFrekvensForskola%s", year),
    		atr("Attributes.PreschoolForm%sCuriosity", year),
    		atr("Attributes.PreschoolForm%sSafety", year),
    		atr("Attributes.PreschoolForm%sSocial", year),
    		atr("Attributes.PreschoolForm%sResponsibility", year),
    		atr("Attributes.PreschoolForm%sAspects", year),
    		atr("Attributes.PreschoolForm%sHappiness", year),
    		atr("Attributes.PreschoolForm%sRecommendation", year),
    		atr("Attributes.PreschoolForm%santalSvarande", year)
    	)]
      
    	# Add distance
    	#       data$GeographicalDistance <- sapply(1:nrow(data), function(i) {
    	#     	  GetRTDistance(.self$RT90, c(data[i,"RT90.northing"], data[i,"RT90.easting"]))
    	#     	})
      
      # TODO: compute stuff
      
      index <- list(
        distance = 59,
        quality = 37,
        cost = NULL,
        quantity = NULL
      )
      
      return(index)
    }
  )
)
