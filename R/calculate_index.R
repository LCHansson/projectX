#' Calculate BLKI
#' 
#' Calculat BoendeLivsKvalitetsIndex (BLKI) for a given address
#' 
#' @export
 
blki <- function(street, number) {
	address <- sthAddr(street, number)
  
  # 1. Miljöindex: ENV_IX
  envdata <- 50 # We leave this constant for now...
  
  env_ix <- normalizeEnvironmentalData(envdata)
  
  # 2. Restidsindex: RT_IX
  traveltime <- travelTimeFromPos(address$WGS84)
  
  rt_ix <- normalizeTravelTime(traveltime)
  
  # 3. Fritidsindex: FT_IX
  leisuredata <- getLeisureData(address)
  
  ft_ix <- normalizeLeisureData(leisuredata)
  
  # 4. Vardagsindex: VD_IX
  vardagdata <- getVardagData(address)
  
  vd_ix <- normalizeVardagData(vardagdata)
  
  # Calculate composite index
  blki_weights <- c(0,0.33,0.33,0.34) # The sum of the weights must add upp to 1.0.
  blki_partialindexes <- c(env_ix, rt_ix, ft_ix, vd_ix)
  
  blki <- sum(blki_weights * blki_partialindexes)
  
  return(blki)
}