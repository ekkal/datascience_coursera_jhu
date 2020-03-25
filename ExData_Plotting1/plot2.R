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
png(file="plot2.png", height=480, width=480, units="px")

# plot line chart.
with(data_filt, plot(Datetime, Global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)"))

# close the pdf device.
dev.off ()
