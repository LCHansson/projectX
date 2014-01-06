#' Normalize Travel time
#' 
#' Normalize Travel time
#' @export

normalizeTravelTime <- function(traveltime) {
  100 - (min(traveltime, 90)/90)*100
}


#' Normalize Leisure data
#' 
#' Normalize Leisure data
#' @export

normalizeLeisureData <- function(leisuredata) {
  NULL
}


#' Normalize Vardag data
#' 
#' Normalize Vardag data
#' @export

normalizeVardagData <- function(vardagdata) {
  NULL
}


#' Normalize Environmental data
#' 
#' Normalize Environmental data
#' @export

normalizeEnvironmentalData <- function(env_data) {
  env_data
}