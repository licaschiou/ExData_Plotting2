# In question 5, we have to see how motor vehicle sources changed.
# After looking into SCC$Short.Name, I decide to include all SCC matched to "motor" or "vehicles".
# So the subset will cover most of the motor vehicles in SCC. 

# load library and dataset
library(reshape2)
library(dplyr)
library(ggplot2)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
# Subset the emission data of Baltimore City
BaltimoreEmissions <- filter(NEI, fips == "24510")
# Create a new dataframe for the total motor vehicle emissions in Baltimore City
BaltimoreMotorEmissionsByYear <- data.frame(
		Pollutant = "PM25-PRI", 
		year = c(1999, 2002, 2005, 2008), 
		Emissions = c(0, 0, 0, 0)
	)
# Subset the Baltimore emission data by matching SCC$Short.Name with "motor" or "vehicles"
shortName <- SCC$Short.Name
motorSCC <- SCC[grepl("(?=.*motor)|(?=.*vehicles)", SCC$Short.Name, ignore.case = TRUE, perl = TRUE),]
SCCCodeMotor <- as.character(motorSCC$SCC)

BaltimoreMotorEmissions <- NULL
for(scc in SCCCodeMotor){
	BaltimoreMotorEmissions <- rbind(BaltimoreMotorEmissions, filter(BaltimoreEmissions, SCC == scc))	
}
# Calculate total motor vehicle emissions of each year in Baltimore City
for(yr in c(1999, 2002, 2005, 2008)){
	yrSum <- sum(filter(BaltimoreMotorEmissions, year == yr)$Emissions)
	BaltimoreMotorEmissionsByYear[(BaltimoreMotorEmissionsByYear$year == yr),]$Emissions <- yrSum
}
# draw the plot to show the changes of emission and save it as png file
png(file = "plot5.png", bg = "white", width = 720, height = 480)
p <- ggplot(BaltimoreMotorEmissionsByYear, aes(year, Emissions)) 
p + labs(title = "Motor Vehicle PM2.5 Emissions in Baltimore") + stat_smooth(method = "lm") + geom_line()
dev.off()