library(xml2)
library(rvest)
library(ggmap)
library(grid)
library(stringi)
library(dplyr)
library(XML)
library(httr)


cars.all <- data.frame()
for (i in 1:50) {
  url <- paste("https://www.arabam.com/ikinci-el/otomobil?page=",i, sep="")
 
  pg <- read_html(url)
  link.data <- html_attr(html_nodes(pg, "a.w100"), "href")
  links <- data.frame(link.data)

  links <- links %>% distinct
  
  links <- data.frame(links[grep("/ilan/", links$link.data,ignore.case = TRUE), ])
  
  tables <- GET(url)
  cars <- readHTMLTable(rawToChar(tables$content),which = 1)
  cars[,1] <- NULL
  cars<-na.omit(cars)
  cars <- cbind(cars,links)
  
  cars.all <- rbind(cars.all,cars)
  
  
}


names(cars.all)[1:8]<-c("İlan Başlığı","Yıl","Kilometre","Renk","Fiyat","Tarih","İl / İlçe","links")
cars.all[,c(7)]<-gsub("([A-Z])", " \\1", cars.all[,c(7)])
cars.all[,3]<-gsub("\\.", "", cars.all[,3])
cars.all[,3] <- as.numeric(cars.all[,3])

cars.all[,5]<-gsub("\\.", "", cars.all[,5])
cars.all[,5]<-gsub(" TL", "", cars.all[,5])
cars.all[,5] <- as.numeric(cars.all[,5])
cars.all[,1] <- as.character(cars.all[,1])


cars.all$shortname <- stri_sub(cars.all[,c(1)],1,20)

latlon <- data.frame()
for (i in (1:nrow(cars.all))){
  
  data2 <- geocode(as.character(cars.all[i,7]))
  latlon <- rbind(data2,latlon)
}

cars.all <- cbind(cars.all,latlon)

write.csv(file="cars.csv",cars.all)
	 	 		 	 	