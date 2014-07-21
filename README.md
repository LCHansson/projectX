projectX
========

Nektar.io project X

```
    
    library(projectX)
    x <- sthAddr("Birkagatan", "24")
    
    # Address
    x$address
    
    # Coordinates
    x$RT90
    # [1] 6582125 1626898
    x$WGS84
    # 59.34079 18.03536
    
    # Parking places (at the street)
    x$getParkingPlaces()
    
    x$getClosestSchools(n = 10)
    
    x$getPreschoolsData(n = 10)
    
```

### DB
The database should store information about the following entities:
- Adresses
- Objects [metadata]
- Schools, preschools, high schools, fritids
- Recreational areas such as parks, public baths, etc.
- Travel times by public transportation (including walking times)
- Environmental factors such as polllution and water quality
- Restaurants and their quality
- Health care institutions (hospitals, elderly homes, "vårdcentraler")
- Demographics (area level)


Table | Columns | Comment
------|---------|--------
Addresses | Id, Street, Number, lat_RT90, long_RT90, lat_WGS84, long_WGS84, Postal_code, Postal_address, Timestamp | The main table
ObjectTypes | Id, Object_type, API_method, API_id, API_params, Timestamp | Object metadata containing a description of methods, call IDs and other important information
Schools | Id, Object_id, Object_type_id, Name, lat_RT90, long_RT90, lat_WGS84, long_WGS84, Timestamp | Schools, preschools, high schools and "fritidsgårdar"
TravelTimes | Id, AddressId, Travel_time_Centralen, Stop_name, Walking_time, Timestamp | Travel times from a specific address to T-Centralen in minutes including the name of the stop and the walking time
Demographics | Id, Area_name, XML_code | Links to XML files containing demographic data

### Get


```r


```


### Set



### Get


