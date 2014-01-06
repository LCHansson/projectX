INDEX
=====

Beskrivning
===========
Ett index över livskvalitet i boendet för en given adress. Arbetsnamn: "BoendeLivsKvalitetsIndex" (BLKI)

BLKI sätts samman av flera delindex som beskriver följande aspekter av en given adress:
1. Närmiljöindex
2. Restidsindex
3. Fritidsindex
4. Familjeindex
5. Andra index

Indexet beräknas som summan av [delindex * delindexvikt] där summan av delindexvikterna är lika med 1.

BLKI bör vara normaliserat för att gå från 0 till 100. Enklast är om alla delindex är normaliserade så att vi slipper ytterligare normalisering av totalindex.

Nedan följer en kort beskrivning av de olika delindex.


### 1 - Närmiljöindex
Beskrivning: Miljöfaktorer som t.ex. luftkvalitet, trafikbelastning, närhet till natur, tillgång till cykelbanor?

Vi har just nu: ???

### 2 - Restidsindex
Beskrivning: Restider till centrala platser i Stockholm med SL, bil och ev. andra transportmedel.

Vi har just nu: Restider med SL:s reseplanerare, antal byten för en resa, gångtid till hållplats från adress

**Beräkning och normalisering**

| Faktor | Normalisering | Vikt |
| ------ | ------------- | ---- |
| Beräknad restid till T-Centralen | 0-10: 100 <br> 10-15: 75 <br> 15-20: 50 <br> 20-40: 25 <br> 40+: 0 | 1 |


### 3 - Fritidsindex
Beskrivning: Närhet till kultur, shopping, mat och annat.

Vi har just nu: Närhet till museer och andra kulturinrättningar

**Beräkning och normalisering**



### 4 - Vardagsindex
Beskrivning: Faktorer som är viktiga för vardagslivet. Detta kan vara närhet till olika barn- och ungdomsfaciliteter (dagis, skolor, fritids) eller sjukvård (vårdcentraler/sjukhus), 

Vi har just nu: Närhet till skolor och dagis; kvalitetsnyckeltal för skolor; 

### 5 - Andra index
Övriga index som kan vara av intresse.

