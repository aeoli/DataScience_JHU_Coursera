# Download data from here https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
library(dplyr)

# Load data
setwd("3. Exploratory data analysis/Final_assignment/")
source <- readRDS("exdata_data_NEI_data/Source_Classification_Code.rds")
summary <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")

# Question: Have total emissions from PM2.5 decreased in the Baltimore City (fips == "24510") from 
# 1999 to 2008? Use base plotting.
q2 <- summary %>% filter(fips == "24510") %>% group_by(year) %>% 
  summarise(Emissions = sum(Emissions)) 
png("plot2.png")
plot(q2, type = 'l', main="Total PM2.5 emissions by year (Baltimore City)")
dev.off()
