#' Calculate BLKI
#' 
#' Calculate BoendeLivsKvalitetsIndex (BLKI) for a given address
#' 
#' @export
 
blki <- function(addrObj) {
	## Miljöindex
  env_idx <- 0
  env_wt <- 0
  
  ## Restidsindex
  # Index components (normalised)
  rt_data <- data.frame(
    # Name the components to the partial index
    component = c("ttime","plots_distance","plots_number"),
    # Long names of the components
    longame = c("Restid, Centralen", "Avstånd, parkeringsplats (X)","Antal parkeringsplatser inom X m"),
    # Name the partial index which is composed of these components
    partial_idx = "rt_idx",
    # Find the values of the components
    value = c(
      addrObj$getIndex_Traveltime(),
      0,
      0
    ),
    # Define the weights of the components
    partial_weight = c(1,0,0),
    is_partialindex = FALSE,
    
    stringsAsFactors = FALSE
  )
  
  indexdata <- rbind(rt_data, c(
    "rt_idx", "Restidsindex", "rt_idx", sum(rt_data$value*rt_data$partial_weight, na.rm=TRUE), 0.33, TRUE
  ))
  
  
  ## Fritidsindex
  ft_data <- data.frame(
    # Name the components to the partial index
    component = c("lib","mus","rest","bath","sports"),
    # Long names of the components
    longame = c("Avstånd, bibliotek (1)", "Avstånd, museer (3)","Avstånd, restauranger (5)","Avstånd, badplats (1)","Avstånd, idrottsanläggning (3)"),
    # Name the partial index which is composed of these components
    partial_idx = "ft_idx",
    # Find the values of the components
    value = c(
      addrObj$getIndex_Library(),
      addrObj$getIndex_Museums(),
      0,
      addrObj$getIndex_Badplats(),
      addrObj$getIndex_Sports()
    ),
    # Define the weights of the components
    partial_weight = c(0.3,0.3,0,0.1,0.2),
    is_partialindex = FALSE,
    
    stringsAsFactors = FALSE
  )
  
  indexdata <- rbind(indexdata, rbind(ft_data, c(
    "ft_idx", "Fritidsindex","ft_idx", sum(ft_data$value*ft_data$partial_weight, na.rm=TRUE), 0.33, TRUE
  )))

  ## Vardagsindex
  vd_data <- data.frame(
    # Name the components to the partial index
    component = c("pre","prim","high","frit","fest","sjukh","vc"),
    # Long names of the components
    longame = c("Avstånd, dagis (3)", "Avstånd, grundskola (3)","Avstånd, gymnasier (3)","Avstånd, fritids (1)","Avstånd, fest- och möteslokal (1)", "Avstånd, sjukhus (1)","Avstånd, vårdcentral (1)"),
    # Name the partial index which is composed of these components
    partial_idx = "vd_idx",
    # Find the values of the components
    value = c(
      100, # Dagis
      0, # Grundskola
      0, # Gymnasium
      addrObj$getIndex_Fritids(),
      addrObj$getIndex_Festlokal(),
      addrObj$getIndex_Sjukhus(),
      addrObj$getIndex_Vardcentral()
    ),
    # Define the weights of the components
    partial_weight = c(0,0,0,0.5,0.5,0,0),
    is_partialindex = FALSE,
    
    stringsAsFactors = FALSE
  )
  
  indexdata <- rbind(indexdata,rbind(vd_data, c(
    "vd_idx", "Vardagsindex", "vd_idx", sum(vd_data$value*vd_data$partial_weight, na.rm=TRUE), 0.34, TRUE
  )))
  
  ## Calculate composite index
  blki <- sum(
    as.numeric(indexdata$partial_weight) * as.numeric(indexdata$value) * as.logical(indexdata$is_partialindex)
  )
  
  return(list(blki=blki, indexdata=indexdata))
}