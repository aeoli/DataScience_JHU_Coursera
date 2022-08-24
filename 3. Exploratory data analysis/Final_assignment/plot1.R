# Download data from here https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
library(dplyr)

# Load data
setwd("3. Exploratory data analysis/Final_assignment/")
source <- readRDS("exdata_data_NEI_data/Source_Classification_Code.rds")
summary <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")

# Question: Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Use base plotting.
q1 <- summary %>% group_by(year) %>% summarise(Emissions = sum(Emissions)) 
png("plot1.png")
plot(q1, type = 'l', main="Total PM2.5 emissions by year")
dev.off()
 