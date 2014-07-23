## Create DB for projectX

# Libraries
require(dplyr)

options(dplyr.show_sql = TRUE)
options(dplyr.explain_sql = FALSE)

## DB initialization
bDB <- src_sqlite("Inst/DB/bDB.sqlite", create = TRUE)


## Table creation ----

## > address ----
address <- data.frame(
  Id = integer(0),
  Street_name = character(0),
  Street_number = integer(0),
  Lat_rt90 = integer(0),
  Long_rt90 = integer(0),
  Lat_wgs84 = integer(0),
  Long_wgs84 = integer(0),
  Postal_code = integer(0),
  Postal_area = character(0),
  Municipality = character(0),
  Timestamp = double(0),
  
  stringsAsFactors = FALSE
)

createDBTbl(bDB, address, key = "Id")

## > obejct ----
object <- data.frame(
  Id = integer(0),
  Object_type = character(0),
  API_method = character(0),
  API_id = character(0),
  API_params = character(0),
  Timestamp = double(0),
  
  stringsAsFactors = FALSE
)

createDBTbl(bDB, object, key = "Id")

## > schools ----
schools <- data.frame(
  Id = integer(0),
  Object_id = integer(0),
  Object_type_id = integer(0),
  Name = character(0),
  Lat_rt90 = integer(0),
  Long_rt90 = integer(0),
  Lat_wgs84 = integer(0),
  Long_wgs84 = integer(0),
  Timestamp = double(0),
  
  stringsAsFactors = FALSE
)

createDBTbl(bDB, schools, key = "Id")

## > traveltimes ----
traveltimes <- data.frame(
  Id = integer(0),
  Address_id = integer(0),
  Travel_time_Centralen = integer(0),
  Stop_name = character(0),
  Walking_time = integer(0),
  Timestamp = double(0),
  
  stringsAsFactors = FALSE
)

createDBTbl(bDB, traveltimes, key = "Id")

## > demographics ----
demographics <- data.frame(
  Id = integer(0),
  Area_name = character(0),
  XML_code = character(0),
  Timestamp = double(0),
  
  stringsAsFactors = FALSE
)

createDBTbl(bDB, demographics, key = "Id")
