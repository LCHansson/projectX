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
      NULL
    },
    getCoords = function(street, number) {
      NULL
    }
  )
)