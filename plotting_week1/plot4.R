# Import Data
full_data <- data.table::fread(input='household_power_consumption.txt', 
                               header=TRUE,
                               na.strings="?")

# Subset Data for specific timeframe
pwr_data <- full_data[full_data$Date == "1/2/2007" | 
                        full_data$Date == "2/2/2007",]

# Create datetime variable for plotting weekdays
pwr_data[,datetime:=(as.POSIXct(paste(Date,Time),format="%d/%m/%Y %H:%M:%S"))]

# Build plot device
png('plot4.png',
    width=480,
    height=480)

# Create plotting framework
par(mfrow=c(2,2))

# Create plot 1
with(pwr_data,
     plot(datetime,Global_active_power,
          col="black",
          type="l",
          ylab="Global Active Power (kilowatts)",
          xlab=""
          )
    )

# Create Plot 2
with(pwr_data,
     plot(datetime,Voltage,
          col="black",
          type="l",
          xlab="datetime",
          ylab="Voltage"
          )
    )

# Create Plot 3
with(pwr_data,
     plot(datetime,Sub_metering_1,
          col="black",
          type="l",
          ylab="Energy Sub Monitoring",
          xlab=""
          )
    )
with(pwr_data,lines(datetime,Sub_metering_2,col="red"))
with(pwr_data,lines(datetime,Sub_metering_3,col="blue"))

# Create Plot 4
with(pwr_data,
     plot(datetime,Global_reactive_power,
          col="black",
          type="l",
          xlab="datetime",
          ylab="Global_reactive_power"
          )
     )
# Turn off plot device
dev.off()

