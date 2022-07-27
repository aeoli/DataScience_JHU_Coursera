# Quiz Week 1 - R Programming

# Load data 
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/rprog/data/quiz1_data.zip",temp)
data <- read.csv(unz(temp, "hw1_data.csv"))
unlink(temp)

# 11. Col names
colnames(data)

# 12. print first 2 rows
head(data, 2)

# 13. num of rows
nrow(data)

# 14. extract last 2 rows
tail(data, 2)

# 15. What is the value of Ozone in the 47th row?
data$Ozone[47]

# 16. How many missing values are in the Ozone column of this data frame?
sum(is.na(data$Ozone))

# 17. What is the mean of the Ozone column in this dataset? Exclude NAs
mean(data$Ozone[!is.na(data$Ozone)])

# 18. Extract the subset of rows where Ozone is above 31 and Temp above 90. 
# What is the mean of Solar.R in this subset?
sub <- data[data$Ozone > 31 & data$Temp > 90,]
mean(sub$Solar.R[!is.na(sub$Solar.R)])

# 19. What is the mean of "Temp" when "Month" is equal to 6? 
mean(data[data$Month == 6 & !is.na(data$Temp),"Temp"])

# 20. What was the maximum ozone value in the month of May (i.e. Month is equal to 5)?
max(data[data$Month == 5 & !is.na(data$Ozone),"Ozone"])








