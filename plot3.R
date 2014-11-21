# load library and dataset
library(reshape2)
library(dplyr)
library(ggplot2)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
# Subset the emission data of Baltimore City
BaltimoreEmissions <- filter(NEI, fips == "24510")
# Create a new dataframe for the total emissions of each type of each year in Baltimore City
BaltimoreEmissionsByType <- data.frame(
		Pollutant = "PM25-PRI",
		type = rep(levels(as.factor(BaltimoreEmissions$type)), each = 4),
		year = rep(c(1999, 2002, 2005, 2008),4),
		Emissions = c(0, 0, 0, 0)
	)
# Calculate total emissions of each type of each year in Baltimore City
for(t in levels(BaltimoreEmissionsByType$type)){
	typeSubSet <- filter(BaltimoreEmissions, type == t)
	for(yr in c(1999, 2002, 2005, 2008)){
		yrSum <- sum(filter(typeSubSet, year == yr)$Emissions)
		BaltimoreEmissionsByType[(BaltimoreEmissionsByType$type == t & BaltimoreEmissionsByType$year == yr),]$Emissions <- yrSum
	}
}
# draw the plot to show the changes of different types of emission and save it as png file
png(file = "plot3.png", bg = "white", width = 720, height = 480)
p <- ggplot(BaltimoreEmissionsByType, aes(year, Emissions)) 
p + labs(title = "PM2.5 Emissions in Baltimore City") + stat_smooth(method = "lm") + facet_grid(. ~ type)+ geom_line()
dev.off()