# load library and dataset
library(reshape2)
library(dplyr)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
# Create a new dataframe for the total emissions of 1999, 2002, 2005 and 2008
USATotalEmissions <- data.frame(
		Pollutant = "PM25-PRI", 
		year = c(1999, 2002, 2005, 2008), 
		Emissions = c(0, 0, 0, 0)
	)
# Calculate total emissions of each year in USA
for(yr in c(1999, 2002, 2005, 2008)){
	yrSum <- sum(filter(NEI, year == yr)$Emissions)
	USATotalEmissions[(USATotalEmissions$year == yr),]$Emissions <- yrSum
}
# draw the plot to show the changes of emission and save it as png file
png(file = "plot1.png", bg = "white", width = 720, height = 480)
plot(USATotalEmissions$year, 
		USATotalEmissions$Emissions,
		main = "PM2.5 Emissions in USA 1999-2008",
		xlab="Year",
		ylab="Total emissions from PM2.5 (tons)", 
		cex.lab=1.0,
		cex.axis=1.0,
		xaxt="n",
		ylim=c(3000000, 8000000),
		pch=20,
		type="o")
axis(1, at=c(1999, 2002, 2005, 2008))
lines(smooth.spline(USATotalEmissions$year, USATotalEmissions$Emissions, df=10), col = "blue")
dev.off()