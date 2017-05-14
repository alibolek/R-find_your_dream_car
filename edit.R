
#set your own working directory
setwd("/home/ali/github/webMining-master")
cars.all <- read.csv("cars.csv")
names(cars.all)[2:8]<-c("İlan Başlığı","Yıl","Kilometre","Renk","Fiyat","Tarih","İl / İlçe")
cars.all[,5] <- as.numeric(cars.all[,5])
cars.all[,2] <- as.character(cars.all[,2])