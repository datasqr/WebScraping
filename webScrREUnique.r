webScrREUnique <- function(web_page){
  
  # Lets grep all adv
  adv <- '<h1 class="od-listing_item-title">(.*?)</h1>'
  advLines <- regexpr(adv,web_page)
  advLines1 <- regmatches(web_page,advLines)
  advLines2 <- strsplit(advLines1, "-")
   
  # Lets grep date
  date <- '<time datetime="(.*?)">'
  dateLines <- regexpr(date,web_page)
  dateLines1 <- regmatches(web_page,dateLines)
  dateLines2 <- strsplit(dateLines1, '""')
  
  # dateLines3 <- gsub('<time datetime=', "", dateLines1)
  # dateLines4 <- gsub('\"|>', "", dateLines3)
  # dateLines5 <- as.Date(dateLines4)
  
  # Lets grep location
  location <- '<h2 class="od-show-map">(.*?)<'
  locationLines <- regexpr(location,web_page)
  locationLines1 <- regmatches(web_page,locationLines)
  
  # locationLines2 <- gsub('<h2 class=\"od-show-map\">', "", locationLines1)
  # locationLines3 <- gsub('    <', "", locationLines2)
  
  if(typeRe == "Flat"){
    REdataNcol = 6
  }else{
    REdataNcol = 5
  }
  
  REData <- data.frame(matrix(0, nrow <- length(advLines1), ncol = REdataNcol))
  for(i in 1:length(advLines1)){
    
    space <- ', [0-9]* m'
    space1 <- regexpr(space,advLines1[i])
    space2 <- regmatches(advLines1[i],space1)
    space2 <- gsub('.* ([0-9]+).*','\\1',space2)
    space2 <- as.numeric(space2)
    
    price <- '-[0-9]*-pln'
    price1 <- regexpr(price,advLines1[i])
    price2 <- regmatches(advLines1[i],price1)
    price2 <- gsub('.*-([0-9]+).*','\\1',price2)
    price2 <- as.numeric(price2)
    
    id <- '-id[0-9]*.'
    id1 <- regexpr(id,advLines1[i])
    id2 <- regmatches(advLines1[i],id1)
    id2 <- gsub('.*-id([0-9]+)..*','\\1',id2)
    id2 <- as.numeric(id2)
    
    if(typeRe == "Flat"){
      rooms <- '-[0-9]*-pokoje'
      rooms1 <- regexpr(rooms,advLines1[i])
      rooms2 <- regmatches(advLines1[i],rooms1)
      rooms2 <- gsub('.*-([0-9]+).*','\\1',rooms2)
      rooms2 <- as.numeric(rooms2)
    }
    
    dateLines3 <- gsub('<time datetime=', "", dateLines1[i])
    dateLines4 <- gsub('\"|>', "", dateLines3)
    
    locationLines2 <- gsub('<h2 class=\"od-show-map\">', "", locationLines1[i])
    locationLines3 <- gsub('    <', "", locationLines2)
    
    if(length(price2) == 0 | length(space2) == 0 | length(id2) == 0 | length(dateLines4) == 0 | length(locationLines3) == 0){
      price2 <- 0
      space2 <- 0
      id2 <- 0 
      dateLines4 <- 0
      locationLines3 <- 0
    }
    
    if(typeRe == "Flat"){
      if(length(rooms2) == 0){
        rooms2 <- 0
      }
    }
    
    
    REData[i,1] <- space2
    REData[i,2] <- price2
    REData[i,3] <- id2
    REData[i,4] <- dateLines4
    REData[i,5] <- locationLines3
    if(typeRe == "Flat"){
      REData[i,6] <- rooms2
    }
    
  }

return(REData)
}
