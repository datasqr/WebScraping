
# First we have to go to the webpage otoDom.pl
# www.otodom.pl
# Enter what you are looking for: Warszawa, Ursynow, lokal uzytkowy etc
# Change number of viewing pages to 100

# Specify number of pages example: nrPages = 4
nrPages = 3

## Set "working directory" which contains source files
mainDir <- "C:/Users/Dell/Desktop/Projects/WebScrapping/Warszawa"

# Przywolujemy funkcje zrodlowe
source("getHTMLREUnique.r")
source("webScrREUnique.r")
source("reType.r")

# Choose transaction type (sell, rent):
# np. tranType = "sell"

tranType = "sell"

# Specify Property (Flat, CommercialProperty, Terrain) :
# np. typeRe = "CommercialProperty"

typeRe = "CommercialProperty"

# Select district in Warsaw (no Polish signes)
# Ursynow
# Ochota
# Mokotow
# Wilanow
# Bemowo
# Bialoleka
# Bielany
# Praga-Poludnie
# Praga-Polnoc
# Rembertow
# srodmiescie
# Targowek
# Ursus
# Wawer
# Wesola
# Wlochy
# Wola
# zoliborz

district = "zoliborz"

# Specify
folderDate <- format(Sys.time(), "%Y%m%d")

# Crates nmes of the folders where you planning to store data
subDir <- paste("",folderDate,"-",tranType,"-",typeRe,"-",district,"", sep="")

# Create storage folder
wDir <- file.path(mainDir, subDir)
dir.create(file.path(wDir, subDir))

# Set "Working Directory" in created folder
setwd(wDir)

# Call getHTMLREUnique. This function gets HTML code from the 
# webpage and write it in txt file 

getHTMLREUnique(nrPages, typeRe, district, tranType)

# List of created txt files with html code
dataList <- list.files()

# Initialice empty vector of lists where we store the results
webpageData <- vector("list", length(dataList))

# Call webScrREUnique function to scrape information fromt the html code.
  for(i in 1:length(dataList)){
    webpageLine <- readLines(dataList[i])
    webpageData[[i]] <- webScrREUnique(webpageLine)
  }

# Results are written in MSdata
MSdata <- do.call(rbind.data.frame, webpageData)
            
# Add extra column "PLN/m2" 
PLNm2 <- MSdata[,2]/MSdata[,1]
MSdata <- cbind(MSdata,PLNm2)

# Add extra column with present date
dateAdded <- rep(folderDate, nrow(MSdata))
MSdata <- cbind(MSdata,dateAdded)

# Add extra column with transaction Type
tranTypeAdded <- rep(tranType, nrow(MSdata))
MSdata <- cbind(MSdata,tranTypeAdded)

# Add extra column with Property Type
typeReAdded <- rep(typeRe, nrow(MSdata))
MSdata <- cbind(MSdata,typeReAdded)

# Add extra column with district
districtAdded <- rep(district, nrow(MSdata))
MSdata <- cbind(MSdata,districtAdded)

#############################################################
# Remove NA
MSdataDef <- MSdata
sapply(MSdataDef, function(x)all(is.na(x)))

MSdataClean <- MSdata[apply(!is.na(MSdata), 1, any), ]

# Change columns name according to selected Property type

  if(typeRe == "CommercialProperty" | typeRe == "Terrain"){
    colnames(MSdataClean) <- c("m2", "PLN", "idOtoDom", "date", "Place", "PLN/m2", "dateAdded", "tranType", "typeRe", "district")
  } else if(typeRe == "Flat"){
    colnames(MSdataClean) <- c("m2", "PLN", "idOtoDom", "date", "Place", "pokoje", "PLN/m2", "dateAdded", "tranType", "typeRe", "district")
  }

# Check if data can be displayed
plot(MSdataClean$m2, MSdataClean$PLN)

# Write file in CSV format
fileName <- paste(subDir,".csv",sep="")
write.csv(MSdataClean, fileName, row.names=FALSE)



