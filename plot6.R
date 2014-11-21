# Same as question 5, I choose all SCC matched to "motor" or "vehicles". 
# So the subset will cover most of the motor vehicles in SCC. 

# load library and dataset
library(reshape2)
library(dplyr)
library(ggplot2)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
# Subset the emission data of Baltimore City
BaltimoreEmissions <- filter(NEI, fips == "24510")
# Subset the emission data of Los Angeles County
LAEmissions <- filter(NEI, fips == "06037")
# Create a new dataframe for the total emissions from motor vehicles in Baltimore City and Los Angeles County
BaltimoreLAMotorEmissions <- data.frame(
		Pollutant = "PM25-PRI", 
		year = rep(c(1999, 2002, 2005, 2008), 2), 
		Emissions = rep(c(0, 0, 0, 0), 2),
		Region = rep(c("Baltimore City", "Los Angeles County"), each = 4)
	)
# Subset the Baltimore and LA emission data by matching SCC$Short.Name with "motor" or "vehicles"
shortName <- SCC$Short.Name
motorSCC <- SCC[grepl("(?=.*motor)|(?=.*vehicles)", SCC$Short.Name, ignore.case = TRUE, perl = TRUE),]
SCCCodeMotor <- as.character(motorSCC$SCC)

BaltimoreMotorEmissions <- NULL
LAMotorEmissions <- NULL
for(scc in SCCCodeMotor){
	BaltimoreMotorEmissions <- rbind(BaltimoreMotorEmissions, filter(BaltimoreEmissions, SCC == scc))
	LAMotorEmissions <- rbind(LAMotorEmissions, filter(LAEmissions, SCC == scc))		
}
# Sum the emissions by year
for(yr in c(1999, 2002, 2005, 2008)){
	yrSum <- sum(filter(BaltimoreMotorEmissions, year == yr)$Emissions)
	BaltimoreLAMotorEmissions[(BaltimoreLAMotorEmissions$year == yr & BaltimoreLAMotorEmissions$Region == "Baltimore City"),]$Emissions <- yrSum
	yrSum <- sum(filter(LAMotorEmissions, year == yr)$Emissions)
	BaltimoreLAMotorEmissions[(BaltimoreLAMotorEmissions$year == yr & BaltimoreLAMotorEmissions$Region == "Los Angeles County"),]$Emissions <- yrSum
}
# Draw the plot to show the changes and compare the difference between Baltimore and LA.
# And then save the file as png.
png(file = "plot6.png", bg = "white", width = 720, height = 480)
p <- ggplot(BaltimoreLAMotorEmissions, aes(year, Emissions)) 
p + labs(title = "Motor Vehicle PM2.5 Emissions in Baltimore & LA") + facet_grid(. ~ Region) + stat_smooth(method = "lm") + geom_line()
dev.off()