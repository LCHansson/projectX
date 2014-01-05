#' Get travel time from current position
#' 
#' Get travel time from current position to central places in Stockholm
#' 
#' @param WGS WGS coordinates on [northing, easting] format
#' @export

GetTravelTime <- function(WGS) {
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
  
  sumtime <- double()
  for (i in 3:7) {
    dur <- xdata[[i]]$Summary$Duration
    
    # Get number of minutes
    time <- suppressMessages(as.integer(as.duration(hm(dur))))/60
    
    sumtime <- sumtime + time
  }
  
  # Return the average trip duration (in minutes)
  return(sumtime/5)
}
