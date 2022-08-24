# Download data from here https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
library(dplyr)
library(viridis)
library(ggplot2)

# Load data
setwd("3. Exploratory data analysis/Final_assignment/")
source <- readRDS("exdata_data_NEI_data/Source_Classification_Code.rds")
summary <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")

# Question: Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle 
# sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time 
# in motor vehicle emissions?
source$SCC <- as.character(source$SCC)
IDs <- unique(source$SCC[grep("Vehicles",source$SCC.Level.Two,ignore.case = T)])

q6 <- summary %>% filter(fips %in% c("24510","06037"), SCC %in% IDs) %>% group_by(year,fips) %>% 
  summarise(Emissions = sum(Emissions))
city <- c("Los Angeles", "Baltimore City")
names(city) <- c("06037", "24510")

q6 %>% ggplot(aes(x=year, y=Emissions)) +
  geom_line() + 
  ggtitle("Total PM2.5 emissions from motor vehicles") + 
  theme_light() + 
  ylab("Emissions") + 
  xlab("Year") + 
  facet_grid(cols = vars(fips), labeller = labeller(fips = city))

ggsave("plot6.png")
