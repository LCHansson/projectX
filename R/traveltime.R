#' Get travel time from current position
#' 
#' Get travel time from current position to central places in Stockholm
#' 
#' @param WGS WGS coordinates on [northing, easting] format
#' @param stations The destination station IDs we want to calculate travel times to. Default is 9001, which is T-Centralen.
#' @export

GetTravelTime <- function(WGS, stations=c(9001)) {
  SID <- paste0("@Y=",format(WGS*10^6, digits=8)[1],"@X=",format(WGS*10^6, digits=8)[2])
  
  url <- OpenSth:::build_url(
    url = .reseplanerareUrl,
    path = .reseplanerarePath,
    params = list(
      key = .reseplanerareKey,
      SID = SID,
      Z = 9001,
      Time = "12:00"
    ))
  
  x <- GET(url)
  xdata <- xmlToList(xmlParse(x), simplify = TRUE)
  
  sumtime <- double(1)
  for (i in 3:7) {
    dur <- xdata[[i]]$Summary$Duration
    
    # Get number of minutes
    time <- suppressMessages(as.integer(as.duration(hm(dur))))/60
    
    # If the trip starts with a walk, add those minutes
    if (xdata[[i]][2]$SubTrip$Transport$Type == "Walk") {
      time <- time + as.integer(xdata[[i]][2]$SubTrip$Duration)
    }
    
    sumtime <- sumtime + time
  }
  
  # Return the average trip duration (in minutes)
  return(sumtime/5)
}
