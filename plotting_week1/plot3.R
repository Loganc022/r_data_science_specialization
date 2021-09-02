full_data <- data.table::fread(input='household_power_consumption.txt', 
                               header=TRUE,
                               na.strings="?")
pwr_data <- full_data[full_data$Date == "1/2/2007" | 
                        full_data$Date == "2/2/2007",]

pwr_data[,datetime:=(as.POSIXct(paste(Date,Time),format="%d/%m/%Y %H:%M:%S"))]

png('plot3.png',
    width=480,
    height=480)

with(pwr_data,
     plot(datetime,Sub_metering_1,
          col="black",
          type="l",
          ylab="Energy Sub Monitoring",
          xlab=""
     ),
)
with(pwr_data,lines(datetime,Sub_metering_2,col="red"))
with(pwr_data,lines(datetime,Sub_metering_3,col="blue"))

dev.off()
