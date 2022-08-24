# Download data from here https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
library(dplyr)
library(viridis)
library(ggplot2)

# Load data
setwd("3. Exploratory data analysis/Final_assignment/")
source <- readRDS("exdata_data_NEI_data/Source_Classification_Code.rds")
summary <- readRDS("exdata_data_NEI_data/summarySCC_PM25.rds")

# Question: Across the USA, how have emissions from coal combustion-related sources changed from 1999–2008?
source$SCC <- as.character(source$SCC)
IDs <- unique(source$SCC[grep("coal",source$Short.Name,ignore.case = T)])

q4 <- summary %>% filter(SCC %in% IDs) %>% group_by(year) %>% summarise(Emissions = sum(Emissions)) 

q4 %>% ggplot(aes(x=year, y=Emissions)) +
  geom_line() + 
  scale_color_viridis(discrete = TRUE) + 
  ggtitle("Total coal-derived PM2.5 emissions by year (USA)") + 
  theme_light() + 
  ylab("Emissions") + 
  xlab("Year")

ggsave("plot4.png")
