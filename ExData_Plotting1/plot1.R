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

# convert type to date.
data1 <- data %>% mutate(Date = dmy(Date))

# filter to the reqd. dates.
data_filt <- data1 %>% filter(Date %in% dmy(c("1/2/2007", "2/2/2007")))

# open png file to export the plot.
png(file="plot1.png", height=480, width=480, units="px")

# plot histogram with x, y labels and title.
with(data_filt, hist(Global_active_power, main="Global Active Power", xlab="Global Active Power (kilowatts)", ylab="Frequency", col="Red"))

# close the pdf device.
dev.off ()
