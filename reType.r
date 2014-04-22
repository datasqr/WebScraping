reType <- function(nrPages, typeRe, district, tranType){
  
  url <- paste("http://otodom.pl/index.php?mod=listing&resultsPerPage=100&objSearchQuery.Orderby=&objSearchQuery.ObjectName=",typeRe,"&objSearchQuery.OfferType=",tranType,"&objSearchQuery.Country.ID=1&objSearchQuery.Province.ID=7&objSearchQuery.ProvinceName=Mazowieckie&objSearchQuery.District.ID=197&objSearchQuery.CityName=Warszawa&objSearchQuery.QuarterName=",district,"&Location=mazowieckie%2C%20Warszawa%2C%20",district,"&currentPage=",nrPages,"&Location=mazowieckie%2C%20Warszawa%2C%20",district,"", sep="")
  
  # Function to open web page from R
  # shell.exec(urlU)
  
  return(url)
}
