## Create DB for projectX

# Libraries
require(dplyr)

options(dplyr.show_sql = FALSE)
options(dplyr.explain_sql = FALSE)

# Create sqlite DB
bDB <- src_sqlite("bDB.sqlite", create = TRUE)


# Create tables for templating in the sql DB
address <- data.frame(
  Id = 1L,
  Street_name = "Dummy",
  Street_number = 0L,
  Lat_rt90 = 0L,
  Long_rt90 = 0L,
  Lat_wgs84 = 0L,
  Long_wgs84 = 0L,
  Postal_code = 0L,
  Postal_address = "Dummy",
  Timestamp = Sys.time(),
  
  stringsAsFactors = FALSE
)


address_tbl <- copy_to(bDB, data.frame(a), temporary = FALSE, index = list("Id"))
a <- tbl(bDB, "addresses")


dbSendQuery(conn = bDB$con, 
            paste0("INSERT INTO address VALUES (", sqlString(row),")")
)