# In question 4, we have to see how coal combustion-related sources changed.
# In SCC files, there are several variables contain values which match "coal" and "comb".
# So I decide to compare SCC$Short.Name (91 obs matched) and SCC$EI.Sector(99 obs matched)first.
# And the result shows that there is no significant difference between them. Therefore, they should
# be able to represent the trend of coal combustion-related sources.

# load library and dataset
library(reshape2)
library(dplyr)
library(ggplot2)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
# Subset the SCC data by matching SCC$Short.Name and SCC$EI.Sector with "coal" and "comb"
shortName <- SCC$Short.Name
eiSector <- SCC$EI.Sector

coalCombInShort <- SCC[grepl("(?=.*coal)(?=.*comb)", SCC$Short.Name, ignore.case = TRUE, perl = TRUE),]
coalCombInEi <- SCC[grepl("(?=.*coal)(?=.*comb)", SCC$EI.Sector, ignore.case = TRUE, perl = TRUE),]
# Create a new dataframe for the total emissions from SCC$Short.Name and SCC$EI.Sector
USATotalEmissions <- data.frame(
		Pollutant = "PM25-PRI", 
		year = rep(c(1999, 2002, 2005, 2008), 2), 
		Emissions = rep(c(0, 0, 0, 0), 2),
		CollectFrom = rep(c("Short.Name", "EI.Sector"), each = 4)
	)
# Subset the coal combustion-related emission data by SCC$Short.Name
SCCCodeInShort <- as.character(coalCombInShort$SCC)
USACoalCombustionEmissions <- NULL
for(scc in SCCCodeInShort){
	USACoalCombustionEmissions <- rbind(USACoalCombustionEmissions, filter(NEI, SCC == scc))	
}
# Sum the emissions by year
for(yr in c(1999, 2002, 2005, 2008)){
	yrSum <- sum(filter(USACoalCombustionEmissions, year == yr)$Emissions)
	USATotalEmissions[(USATotalEmissions$year == yr & USATotalEmissions$CollectFrom == "Short.Name"),]$Emissions <- yrSum
}
# Subset the coal combustion-related emission data by SCC$EI.Sector
SCCCodeInEi <- as.character(coalCombInEi$SCC)
USACoalCombustionEmissions <- NULL
for(scc in SCCCodeInEi){
	USACoalCombustionEmissions <- rbind(USACoalCombustionEmissions, filter(NEI, SCC == scc))	
}
# Sum the emissions by year
for(yr in c(1999, 2002, 2005, 2008)){
	yrSum <- sum(filter(USACoalCombustionEmissions, year == yr)$Emissions)
	USATotalEmissions[(USATotalEmissions$year == yr & USATotalEmissions$CollectFrom == "EI.Sector"),]$Emissions <- yrSum
}
# Draw the plot to show the changes of emission and difference between data from SCC$Short.Name and SCC$EI.Sector.
# And then save the file as png.
png(file = "plot4.png", bg = "white", width = 720, height = 480)
p <- ggplot(USATotalEmissions, aes(year, Emissions)) 
p + labs(title = "Coal Combustion PM2.5 Emissions in USA") + stat_smooth(method = "lm") + geom_line(aes(colour = CollectFrom))
dev.off()