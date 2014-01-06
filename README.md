projectX
========

Nektar.io project X
    
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