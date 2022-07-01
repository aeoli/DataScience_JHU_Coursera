###### ____ Quiz - Week 1 - Getting and Cleaning Data ____ ######

getwd()
setwd("../Getting_and_Cleaning_data/")

# Q1 - Download file from internet
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileURL, destfile = "./week1_quiz_data.csv", method = "curl") 
list.files() # to check if everything went fine
dateDownloaded <- date() # to store the download date, just in case

# load data
data <- read.csv(file = "./week1_quiz_data.csv") 
dim(data)
str(data)
summary(data)

# Q1: How many properties are worth $1,000,000 or more?
q1 <- na.omit(data[data$VAL == 24,c("SERIALNO","VAL")])
nrow(q1)

# Q2: Look up the variable FES in the code book. Which "tidy data" principle does it violate?
summary(data$FES)
table(data$FES)
class(data$FES)

# Q3: Reading Excel files. Read rows 18-23 and columns 7-15. What is the asked value?
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
download.file(fileURL, destfile = "./week1_quiz_data_excel.xlsx", method = "curl") 
dat <- xlsx::read.xlsx("./week1_quiz_data_excel.xlsx", sheetIndex = 1, startRow = 2, header = T,
                       colIndex = 7:15, rowIndex = 18:23) 
sum(dat$Zip*dat$Ext,na.rm=T) # find this value: 36534720

# Q4: Read the XML data How many restaurants have zipcode 21231? 
library(XML)
fileURL <- "http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
doc <- xmlTreeParse(fileURL, useInternal = T)
rootNode <- xmlRoot(doc) # the root node is sort of the wrapper for the entire document

rootNode[[1]][[1]] # to access the first node of the first element
zip <- xpathSApply(rootNode,"//zipcode",xmlValue)
sum(zip == 21231)

# Q5: Which one has the lowerst user time?
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileURL, destfile = "./week1_quiz_data_q5.csv", method = "curl") 
DT <- data.table::fread(file = "./week1_quiz_data_q5.csv") 

system.time(tapply(DT$pwgtp15,DT$SEX,mean))
system.time(rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2])
system.time(mean(DT$pwgtp15,by=DT$SEX))
system.time(mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15))
system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))
system.time(DT[,mean(pwgtp15),by=SEX])



