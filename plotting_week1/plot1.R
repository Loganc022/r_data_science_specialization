
full_data <- fread(input='household_power_consumption.txt', 
                        header=TRUE,
                        na.strings="?")
pwr_data <- full_data[full_data$Date == "1/2/2007" | 
                        full_data$Date == "2/2/2007",]

png('plot1.png',
    width=480,
    height=480)

with(pwr_data,hist(Global_active_power, 
                   col='red', 
                   xlab='Global Active Power (kilowatts)',
                   main='Global Active Power'
                   )
)

dev.off()

