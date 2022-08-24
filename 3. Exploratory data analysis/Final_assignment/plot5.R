# Download data from here https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
library(dplyr)
library(viridis)
library(ggplot2)

# Load data
setwd("3. Exploratory data analysis/Final_assignment/")
source <- readRDS("exdata_data_NEI_data/Source_Classification_Code.rds")
summary <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")

# Question: How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
source$SCC <- as.character(source$SCC)
IDs <- unique(source$SCC[grep("Vehicles",source$SCC.Level.Two,ignore.case = T)])

q5 <- summary %>% filter(fips == "24510", SCC %in% IDs) %>% group_by(year) %>% 
  summarise(Emissions = sum(Emissions))

q5 %>% ggplot(aes(x=year, y=Emissions)) +
  geom_line() + 
  ggtitle("Total PM2.5 emissions from motor vehicles (Baltimore City)") + 
  theme_light() + 
  ylab("Emissions") + 
  xlab("Year")

ggsave("plot5.png")
