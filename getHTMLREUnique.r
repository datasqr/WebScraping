getHTMLREUnique <- function(nrPages, typeRe, district, tranType){
  
  fileDate <- format(Sys.time(), "%Y-%m-%d")
  urlRE <- rep(0,nrPages)
  dataList <- vector("list", nrPages)
      
    for(i in 1:length(urlRE)){
      urlRE[i] <- reType(i, typeRe, district, tranType)
      dataList[[i]] <- readLines(urlRE[i])
      fileName <- paste(fileDate,"_",district,"_",i,".txt",sep="")
      write.table(dataList[[i]], file = fileName, 
                  quote = FALSE, 
                  sep = " ", 
                  row.names = FALSE)
    }
  
}
