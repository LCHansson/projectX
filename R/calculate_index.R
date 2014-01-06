#' Calculate BLKI
#' 
#' Calculate BoendeLivsKvalitetsIndex (BLKI) for a given address
#' 
#' @export
 
blki <- function(addrObj) {
	## Miljöindex
  env_ix <- 0
  env_wt <- 0
  
  ## Restidsindex
  # Index components (normalised)
  ttime <- addrObj$getIndex_Traveltime()
  plots_distance <- 0
  plots_number <- 0
  
  rt_partial_weights <- c(1,0,0)
  
  # Calculate partial index from components
  rt_ix <- sum(c(ttime, plots_distance, plots_number) * rt_partial_weights)
  rt_wt <- 0.33
  
  ## Fritidsindex
  # Index components (normalised)
  lib <- addrObj$getIndex_Library()
  mus <- addrObj$getIndex_Museums()
  rest <- 0
  bath <- addrObj$getIndex_Badplats()
  sports <- addrObj$getIndex_Sports()
  
  ft_partial_weights <- c(0.3,0.3,0,0.1,0.2)
  
  # Calculate partial index from components
  ft_ix <- sum(c(lib,mus,rest,bath,sports) * ft_partial_weights)
  ft_wt <- 0.33
  
  ## Vardagsindex
  # Index components (normalised)
  pre <- addrObj$getIndex_Preschools()
  prim <- addrObj$getIndex_Primaryschools()
  high <- addrObj$getIndex_Highschools()
  frit <- addrObj$getIndex_Fritids()
  fest <- addrObj$getIndex_Festlokal()
  sjukh <- addrObj$getIndex_Sjukhus()
  vc <- addrObj$getIndex_Highschools()
  
  vd_partial_weights <- c(0.3,0.3,0.3,0.05,0.05,0,0)
  
  # Calculate partial index from components
  vd_ix <- sum(c(pre,prim,high,frit,fest,sjukh,vc) * vd_partial_weights)
  vd_wt <- 0.34
  
  ## Calculate composite index
  blki_weights <- c(0,0.33,0.33,0.34) # The sum of the weights must add upp to 1.0.
  blki_partialindexes <- c(env_ix, rt_ix, ft_ix, vd_ix)
  
  blki <- sum(blki_weights * blki_partialindexes)
  
  return(blki)
}