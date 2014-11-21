Exploratory Data Analysis Course Project 2  
==========================================  

I. Files :    
There should be 6 R script files, 6 png images and README.md in the repository. To run the scripts, put them in the same folder with original EPA dataset file.  

The working directory should looks like the following :   
./README.md  
./plot1.R  
./plot2.R  
./plot3.R  
./plot4.R  
./plot5.R  
./plot6.R  
./plot1.png  
./plot2.png  
./plot3.png  
./plot4.png  
./plot5.png  
./plot6.png  
./Source_Classification_Code.rds  
./summarySCC_PM25.rds  

II. File connection:  
Each script file will load dataset independently by  
NEI <- readRDS("summarySCC_PM25.rds")  
SCC <- readRDS("Source_Classification_Code.rds")  

III. Usage:  
* Each script file generates corresponding plot image file, i.e plot1.png ~ plot6.png in the same folder. 
* To run the script, load the scripts with source("plot1.R") ~ source("plot6.R")
