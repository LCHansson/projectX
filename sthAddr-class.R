sthAddr <- setRefClass(
  "sthAddr",
  fields = list(
    address = "list",
    coords = "list"
  ),
  methods = list(
    initialize = function(street, number) {
      address <<- getAddress(street, number)
      
      coords <<- getCoords(street, number)
    },
    getAddress = function(street, number) {
      addresses <<- LvWS::GetAddresses(streetName=street, streetNumPattern=number)
    },
    getCoords = function(street, number) {
      coords <<- GetCoords(addresses$WKT)
    }
  )
)