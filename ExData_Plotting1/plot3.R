# load reqd. library 
library(tidyverse)
library(lubridate)

# download file from remote and unzip 
if(!file.exists("household_power_consumption.txt")) {
  message("Downloading data")
  fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  file="household_power_consumption.zip"
  download.file(fileURL, destfile=file)
  unzip(file)
}

# read file 
data <- read_delim("household_power_consumption.txt", ";")

# convert type to date and add Datetime variable.
data1 <- data %>% mutate(Date = dmy(Date))
data2 <- data1 %>% mutate(Datetime = ymd_hms(paste(as.character(Date), as.character(Time))))

# filter to the reqd. dates.
data_filt <- data2 %>% filter(Date %in% dmy(c("1/2/2007", "2/2/2007")))

# open png file to export the plot.
png(file="plot3.png", height=480, width=480, units="px")

# plot Sub_meterings against Datetime
with(data_filt, plot(Datetime, Sub_metering_1, type="n", xlab="", ylab="Energy sub metering"))
with(data_filt, lines(Datetime, Sub_metering_1, type="l", col="black"))
with(data_filt, lines(Datetime, Sub_metering_2, type="l", col="red"))
with(data_filt, lines(Datetime, Sub_metering_3, type="l", col="blue"))
with(data_filt, legend("topright", col=c("black", "red", "blue"), lty=1, legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")))

# close the pdf device.
dev.off ()
