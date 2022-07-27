###### ____ Quiz - Week 3 - Getting and Cleaning Data ____ ######

# Q1. Create a logical vector that identifies the households on greater than 10 acres who sold more 
# than $10,000 worth of agriculture products. Assign that logical vector to the variable 
# agricultureLogical. Apply the which() function like this to identify the rows of the data frame 
# where the logical vector is TRUE: which(agricultureLogical) 
# What are the first 3 values that result?
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(url, "./Getting_and_Cleaning_data/getdata_data_ss06hid.csv")
acs <- read.csv("Getting_and_Cleaning_data/getdata_data_ss06hid.csv")
agricultureLogical <- which(acs$ACR == 3 & acs$AGS == 6)
agricultureLogical[1:3] # 125, 238, 262

file.remove("Getting_and_Cleaning_data/getdata_data_ss06hid.csv")


# Q2. Using the 'jpeg' package, read in the following picture of your instructor into R: 
# https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg 
# Use the parameter native=TRUE. What are the 30th and 80th quantiles of the resulting data? 
library("jpeg")
url_pic <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file(url_pic, "./Getting_and_Cleaning_data/2Fjeff.jpg")
pic <- jpeg::readJPEG("Getting_and_Cleaning_data/2Fjeff.jpg", native = T)

quantile(pic, probs = c(0.3,0.8)) # -15259150 -10575416

file.remove("Getting_and_Cleaning_data/2Fjeff.jpg")


# Q3. Load the Gross Domestic Product data for the 190 ranked countries in this data set:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv 
# Load the educational data from this data set:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
# Match the data based on the country shortcode. How many of the IDs match? Sort the data frame in 
# descending order by GDP rank (so United States is last). What is the 13th country in the resulting df?
url1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
url2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(url1, "./Getting_and_Cleaning_data/Q3_1.csv")
download.file(url2, "./Getting_and_Cleaning_data/Q3_2.csv")
Q3_1 <- read_csv("./Getting_and_Cleaning_data/Q3_1.csv", skip = 3)
Q3_2 <- read_csv("./Getting_and_Cleaning_data/Q3_2.csv")

Q3_1 <- Q3_1 %>% rename("CountryCode" = "...1", "GDP (m$)" = "US dollars)") %>% 
  select(-contains("...")) %>% drop_na 
Q3_1$`GDP (m$)` <- as.numeric(gsub(",","",Q3_1$`GDP (m$)`))
Q3_1$Ranking <- as.numeric(Q3_1$Ranking)

Q3 <- merge(Q3_1, Q3_2, by = "CountryCode")
Q3_sorted <- Q3 %>% arrange(desc(Ranking))
Q3_sorted[13,1] # 189 and KNA (St. Kitts and Nevis)


# Q4. What is the average GDP ranking for the "High income: OECD" and "High income: nonOECD" group?  
Q3_sorted %>% group_by(`Income Group`) %>% summarise(avg_IG = mean(Ranking, digits = 6)) # 33, 91.9


# Q5. Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income.Group. 
# How many countries are Lower middle income but among the 38 nations with highest GDP?
Q5 <- Q3_sorted %>% mutate(quantiles = ntile(Ranking, 5))
table(Q5$quantiles, Q5$`Income Group`) # 5

file.remove(c("./Getting_and_Cleaning_data/Q3_1.csv","./Getting_and_Cleaning_data/Q3_2.csv"))
