#Author: Giang Nguyen
# Set the working directory
#setwd("~/GiangG/NuvestCapital") 
library(quantmod)
library(jsonlite)
#create a new environment
SP500 <- new.env()
#download data SPY, IEMG, DJX for 5 years
tickers = c("SPY", "IEMG", "DXJ")
for (value in tickers){
  print(value)
  getSymbols(value, src = 'yahoo', env = SP500, from = as.Date('2012-10-11'), to = as.Date('2017-10-11'), auto.assign = T)
}
#add date column data 
SPY_data <- as.data.frame(get("SPY", envir = SP500), check.rows = TRUE)
SPY_data[length(SPY_data)+1] <- rownames(SPY_data)
colnames(SPY_data)[length(SPY_data)] <- "Date"

IEMG_data <- as.data.frame(get("IEMG", envir = SP500),check.rows = TRUE)
IEMG_data[length(IEMG_data)+1] <- rownames(IEMG_data)
colnames(IEMG_data)[length(IEMG_data)] <- "Date"

DXJ_data <- as.data.frame(get("DXJ", envir = SP500),check.rows = TRUE)
DXJ_data[length(DXJ_data)+1] <- rownames(DXJ_data)
colnames(DXJ_data)[length(DXJ_data)] <- "Date"

# JPY data is only available for the last 180 days on OANDA and none available on yahoo and google so I only downloaded the last 180 days
getSymbols("USD/JPY", src = 'oanda', env = SP500, from = as.Date('2017-04-14'), to = as.Date('2017-10-11'), auto.assign = T)
JPY_data <- as.data.frame(get("USDJPY", envir = SP500),check.rows = TRUE)
JPY_data[length(JPY_data)+1] <- rownames(JPY_data)
colnames(JPY_data)[length(JPY_data)] <- "Date"

#merge SPY and IEMG
data_export <- merge(SPY_data, IEMG_data, by="Date", all.x = TRUE, all.y = TRUE)
data_export <- data_export[complete.cases(data_export),]
keeps <- c("SPY.Open", "SPY.High", "SPY.Low", "SPY.Close","IEMG.Open", "IEMG.High", "IEMG.Low", "IEMG.Close", "Date")
data_export <- data_export[keeps]
write.csv(data_export, "first.csv")

#merge SPY, DJX, and JPY
SPY_data_1 <- SPY_data[c("SPY.Close", "Date")]
DXJ_data <- DXJ_data[c("DXJ.Close", "Date")]
JPY_data <- JPY_data[c("USD.JPY", "Date")]
data_export_2 <-  merge(DXJ_data,JPY_data,by= "Date",all.x = TRUE, all.y= TRUE)
data_export_1 <- merge(SPY_data_1,data_export_2, by="Date",all.x = TRUE, all.y = TRUE)
data_export_1 <- data_export_1[complete.cases(data_export_1),]
keeps1 <- c("SPY.Close", "DXJ.Close", "USD.JPY", "Date" )
data_export_1 <- data_export_1[keeps1]
write.csv(data_export_1,"second.csv")



