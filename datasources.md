ÖPPNA STOCKHOLM
===============

 Datakälla | Adress | R-Paket / exempel | Kommentar 
--------|------|-----|-------|
Geodataportalen | http://geodataportalen.stockholm.se/Geodataportalen/ | - | Metadata för ett stort antal API:er och andra källor från Open Stockholm
Generell API-dokumentation | http://api.stockholm.se/dokumentation/ | - | Länkar och dokumentation för flera API-tjänster
Befolkningsdata | http://open.stockholm.se/befolkningsdata | - | -
Enhetsdatabasen | http://api.stockholm.se/ServiceGuideService | - | -
Geodata | http://open.stockholm.se/geodata | LvWS | -
Miljödata | http://open.stockholm.se/miljodata | - | - 
Platsdatabasen | http://api.stockholm.se/PlaceService | - | -
Trafik och parkering | http://open.stockholm.se/trafik-och-parkering | - | -
Verksamheter och nöjdundersökningar | http://open.stockholm.se/verksamheter-och-nojdhetsundersokningar | - | -
Kolada | http://www.kolada.se/portal.php?page=index/api | - | Kommun, landsting
SCB Statistikdatabasen API | http://www.scb.se/api/ | [rSCB](https://github.com/LCHansson/rSCB) | -
Open Street Map | http://www.openstreetmap.org/ | [OpenStreetMap](http://cran.r-project.org/web/packages/OpenStreetMap/index.html), [ggmap](http://cran.r-project.org/web/packages/ggmap/index.html) | -
Google Maps API | - | [RgoogleMaps](http://cran.r-project.org/web/packages/RgoogleMaps/index.html), [ggmap](http://cran.r-project.org/web/packages/ggmap/index.html) | -
Valstatistik | http://www.val.se/val/val2010/statistik/ | - | Ledamöter, valresultat, kommun, landsting etc. 
Riksdagens API | http://data.riksdagen.se/ | [Lite kod](https://github.com/SwedishPensionsAgency/r-for-nyborjare/blob/master/code/swedish-parliament.R) | Dokument, ledamöter, voteringar, anföranden, etc.
Booli API | http://www.booli.se/api/ | [Request (sålda)](http://www.booli.se/api/explorer#/sold?q=göteborg) | Orimliga villkor - blir svårt att använda. Innehåller bostäder: gata, bild, slutpris, etc.
SVD API | http://www.mashup.se/api/svenska-dagbladet-api-nyhetssokning | - | Sök artiklar, json
K-samsök | http://www.ksamsok.se/api/ | - | Fornminnen, historisk/k-märkt bebyggelse, etc.
Systembolaget | http://www.systembolaget.se/Tjanster/Oppna-APIer/ | - | Butiker: adress, coordinat
VISS Vatteninformationssystem | http://www.viss.lansstyrelsen.se/API | - | -
SCB Församlingar | [Statistik](http://www.scb.se/sv_/Hitta-statistik/Statistik-efter-amne/Befolkning/Befolkningens-sammansattning/Befolkningsstatistik/25788/25795/), [Koder](http://www.scb.se/sv_/Hitta-statistik/Regional-statistik-och-kartor/Regionala-indelningar/Forsamlingar/) | - | -
Bistånd i Sverige | http://openaid.se/ | - | -

## Data på gatunivå

Variabler som kan vara av intresse för konstruktion av index.

- Restider: SL, SJ http://www.trafiklab.se/api
- Närhet till
    - Restaurang (yelp)
    - Idrottsanläggning
    - Park
    - Bad
    - Skola
    - Dagis
    - Grönområde
    - Systembolaget, http://www.systembolaget.se/Tjanster/Oppna-APIer/
    - Återvinningscentral/-station
    - Minnesmärkning, http://www.ksamsok.se/api/
    - Parkering, http://openstreetgs.stockholm.se/Home/Parking
    - Äldrevård
    - Sjukvård
    - Apotek
    - Bibliotek
    - Mataffär
    - Butiker
    - Bio http://www.bioprogrammet.nu/biograflista.asp?stadnr=13
    - Bankomat
- Invånare (räkna antal per gata): http://birthday.se, http://eniro.se, http://hitta.se
- Bygglov http://insynsbk.stockholm.se/Byggochplantjansten/Pagaende-planarbete/PagaendePlanarbete/
- Trafikplanering 
- Trafik http://trafiken.nu/Stockholm/
- Miljövariabler http://open.stockholm.se/miljodata http://www.stralsakerhetsmyndigheten.se/Yrkesverksam/Miljoovervakning/Sokbara-miljodata/
- Idrottsföreningar http://booking.stockholm.se/ http://booking.stockholm.se/SearchAss/SearchAss.aspx
- Företag och föreningar http://www.bolagsverket.se/om/oss/etjanster/statistik/statistik-1.3538
- Brottslighet http://polisen.se/Stockholms_lan/Aktuellt/Handelser/ http://statistik.bra.se/solwebb/action/start
- Polisen Twitter: https://twitter.com/polisen_sthlm http://polisen.se/Stockholms_lan/Aktuellt/Sociala-medier/Sa-arbetar-Polisen-med-sociala-medier/Komplettering/Stockholm/Sociala-medier-i-Stockholm/ 
- Sammansättning av bostäder (villa, bostadsrätt, hyresrätt)
- Demografisk sammansättning http://open.stockholm.se/befolkningsdata getAllStockholmXML() http://statistikomstockholm.se/index.php/detaljerad-statistik/arsbokstabeller-befolkning/arsbokstabeller-befolkning-2
- Etnicitet SCB eller kanske http://open.stockholm.se/befolkningsdata getAllStockholmXML()
- Valstatistik http://www.val.se/val/val2010/statistik/index.html
- Inkomst http://open.stockholm.se/befolkningsdata getAllStockholmXML() (Medelinkomst per stadsdelsnämnd)
- Stockholm e-arkiv https://service.stockholm.se/Open/ArchiveSearch/Pages/SearchPage.aspx
- Elleverantörer
- Internetleverantörer http://e-tjanster.pts.se/internet/api
- Diarier http://diarium.lansstyrelsen.se/default.aspx http://www.diarium.sll.se/WebDiary/index.htm

### Kommentarer
Data för närmaste skolor, dagis, bibliotek, park, bad etc. finns i enhets-API:t på api.stockholm.se. För att vi ska kunna hitta de närmaste av varje behöver vi göra följande:
1. Hämta geografiska koordinater i WGS84 för en adress från LvWS-API:t
2. Konvertera dessa till RT90 2.5 gon V via LvWS-API:t (OBS! X-koordinaten från LvWS blir här Y-koordinaten och vice versa)
3. Använd koordinaterna i RT90 för att hämta data om närmaste [x] från Enhets-API:t
