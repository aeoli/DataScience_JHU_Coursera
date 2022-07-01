###### ____ Quiz - Week 2 - Getting and Cleaning Data ____ ######

# Q1. API stuff --> I'm too lazy for this one

# Q2. The sqldf package allows for execution of SQL commands on R data frames. We will use the
# sqldf package to practice some queries. Download the American Community Survey data and load 
# it into an R object called 'asc'. Which command will select data for the probability weights 
# "pwgtp1" with ages less than 50?
library("sqldf")
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(url, "./Getting_and_Cleaning_data/ss06pid.csv")
acs <- read.csv(f)
query1 <- sqldf("select pwgtp1 from acs where AGEP < 50")

# Q3. Using the same data frame, what is the equivalent function to unique(acs$AGEP) ?
sqldf("select distinct AGEP from acs")
file.remove("./Getting_and_Cleaning_data/ss06pid.csv")

# Q4. How many characters are in the 10th, 20th, 30th and 100th lines of this HTML?
con <- url("http://biostat.jhsph.edu/~jleek/contact.html")
html_code <- readLines(con)
close(con)
c(nchar(html_code[10]), nchar(html_code[20]), nchar(html_code[30]), nchar(html_code[100]))


# Q5. Read this data into R and report the sum of the numbers in the 4th of the 9th columns
library(XML)
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"
html_code <- readLines(url, n = 10) # to get a preview
width <- c(1, 9, 5, 4, 1, 3, 5, 4, 1, 3, 5, 4, 1, 3, 5, 4, 1, 3)
colNames <- c("filler", "week", "filler", "SST_Nino1+2", "filler", "SSTA_Nino1+2", 
              "filler", "SST_Nino3", "filler", "SSTA_Nino3", "filler", "SST_Nino34", "filler", 
              "SSTA_Nino34", "filler", "SST_Nino4", "filler", "SSTA_Nino4")
d <- read.fwf(url, width, header = FALSE, skip = 4, col.names = colNames)
d <- d[,-grep("filler", names(d))]
sum(d[,4])
