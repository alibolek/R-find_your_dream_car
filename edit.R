
#set your own working directory
setwd("/home/eray/Desktop/webMining")
cars.all <- read.csv("cars.csv")
names(cars.all)[1:9]<-c("No","İlan Başlığı","Yıl","Kilometre","Renk","Fiyat","Tarih","İl / İlçe","links")
cars.all[,5] <- as.numeric(cars.all[,5])
cars.all[,2] <- as.character(cars.all[,2])
cars.all[,9] <- as.character(cars.all[,9])
cars.all[,10] <- as.character(cars.all[,10])
