# load library and dataset
library(reshape2)
library(dplyr)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Subset the emission data of Baltimore City
BaltimoreEmissions <- filter(NEI, fips == "24510")
# Create a new dataframe for the total emissions of 1999, 2002, 2005 and 2008 in Baltimore City
BaltimoreTotalEmissions <- data.frame(
		Pollutant = "PM25-PRI", 
		year = c(1999, 2002, 2005, 2008), 
		Emissions = c(0, 0, 0, 0)
	)
# Calculate total emissions of each year in Baltimore City
for(yr in c(1999, 2002, 2005, 2008)){
	yrSum <- sum(filter(BaltimoreEmissions, year == yr)$Emissions)
	BaltimoreTotalEmissions[(BaltimoreTotalEmissions$year == yr),]$Emissions <- yrSum
}
# draw the plot to show the changes of emission and save it as png file
png(file = "plot2.png", bg = "white", width = 720, height = 480)
plot(BaltimoreTotalEmissions$year, 
		BaltimoreTotalEmissions$Emissions,
		main = "PM2.5 Emissions in Baltimore 1999-2008",
		xlab="Year",
		ylab="Total emissions from PM2.5 (tons)", 
		cex.lab=1.0,
		cex.axis=1.0,
		xaxt="n",
		pch=20,
		type="o")
axis(1, at=c(1999, 2002, 2005, 2008))
lines(smooth.spline(BaltimoreTotalEmissions$year, BaltimoreTotalEmissions$Emissions, df=10), col = "blue")
dev.off()
