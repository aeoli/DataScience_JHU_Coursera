# Download data from here https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
library(dplyr)
library(viridis)
library(ggplot2)

# Load data
setwd("3. Exploratory data analysis/Final_assignment/")
source <- readRDS("exdata_data_NEI_data/Source_Classification_Code.rds")
summary <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")

# Question: Of the four types of sources indicated by the 'type' variable, which ones have seen decreases in 
# emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions? Use ggplot2.
q3 <- summary %>% filter(fips == "24510") %>% group_by(year,type) %>% 
  summarise(Emissions = sum(Emissions)) 

q3 %>% ggplot(aes(x=year, y=Emissions, group=type, color=type)) +
  geom_line() + 
  scale_color_viridis(discrete = TRUE) + 
  ggtitle("Total PM2.5 emissions by year (Baltimore City)") + 
  theme_light() + 
  ylab("Emissions") + 
  xlab("Year")

ggsave("plot3.png")
