###### ____ Quiz - Week 4 - Getting and Cleaning Data ____ ######

# Q1. Apply strsplit() to split all the names of the data frame on the characters "wgtp". 
# What is the value of the 123 element of the resulting list?
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(url, "./Getting_and_Cleaning_data/getdata_data_ss06hid.csv")
df <- read.csv("Getting_and_Cleaning_data/getdata_data_ss06hid.csv")
x <- strsplit(names(df), split = "wgtp") 
x[123] # ""   "15"

file.remove("Getting_and_Cleaning_data/getdata_data_ss06hid.csv")


# Q2. Load the Gross Domestic Product data for the 190 ranked countries in this data set:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv 
# Remove the commas from the GDP numbers in millions of dollars and average them. What is the average? 
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(url, "./Getting_and_Cleaning_data/Q2.csv")
Q2 <- read_csv("./Getting_and_Cleaning_data/Q2.csv", skip = 3)

Q2 <- Q2 %>% rename("CountryCode" = "...1", "GDP (m$)" = "US dollars)") %>% 
  select(-contains("...")) %>% drop_na 
Q2$`GDP (m$)` <- as.numeric(gsub(",","",Q2$`GDP (m$)`))
mean(Q2$`GDP (m$)`) # 377652.4


# Q3. In the data set from Question 2 what is a regular expression that would allow you to count the number of 
# countries whose name begins with "United"? Assume that the variable with the country names in it is named  
# countryNames. How many countries begin with United?
grep("^United", Q2$Economy) # 3 countries (1, 6, 32)
Q2[c(1, 6, 32),"Economy"] # US, UK, UAE


# Q4. Using the dataset from Q2, also load the educational data from this data set
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
# Match the data based on the country shortcode. Of the countries for which the end of the fiscal year is available, 
# how many end in June?
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(url, "./Getting_and_Cleaning_data/Q4.csv")
Q4 <- read_csv("./Getting_and_Cleaning_data/Q4.csv")

Q4m <- merge(Q2, Q4, by = "CountryCode")
sum(grepl("^Fiscal year end: June",Q4m$`Special Notes`)) # 13



# Q5. You can use the quantmod (http://www.quantmod.com/) package to get historical stock prices for publicly traded 
# companies on the NASDAQ and NYSE. Use the following code to download data on Amazon's stock price and get the times 
# the data was sampled. How many values were collected in 2012? How many values were collected on Mondays in 2012?
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)
sum(year(sampleTimes) == 2012) # 250
length(sampleTimes[year(sampleTimes) == 2012 & wday(sampleTimes) == 2]) # 47
length(sampleTimes[year(sampleTimes) == 2012 & format(sampleTimes,"%a") == "Mon"]) # alt solution format(sampleTimes,"%a")


file.remove(c("./Getting_and_Cleaning_data/Q2.csv","./Getting_and_Cleaning_data/Q4.csv"))
