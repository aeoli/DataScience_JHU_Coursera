### Programming assignment - Week 2 - R Programming
library(dplyr)
library(plyr)


## Part 1
# Write a function named 'pollutantmean' that calculates the mean of a pollutant (sulfate or nitrate) 
# across a list of monitors. It takes three arguments: 'directory', 'pollutant', and 'id'. Given a 
# vector of monitor ID numbers, 'pollutantmean' reads that monitors' data from the specified 'directory'
# and returns the mean of the pollutant across all of the monitors, ignoring any missing values (NAs).

pollutantmean <- function(dir, poll, id = 1:332){
  # Extract files and prepare df
  my_files <- list.files(dir, full.names = T)
  my_data <- list()
  my_data <- lapply(my_files, read.csv)
  df <- do.call("rbind", my_data)
  
  # Convert NaN to NA
  df$sulfate[is.nan(df$sulfate)] <- NA
  df$nitrate[is.nan(df$nitrate)] <- NA
  
  mean(df[df$ID %in% id,poll], na.rm = T)
}


## Part 2
# Write a function that reads a directory full of files and reports the number of completely observed 
# cases in each data file. The function should return a data frame where the first column is the name 
# of the file and the second column is the number of complete cases.

complete <- function(dir, id = 1:332){
  # Extract files and prepare df
  my_files <- list.files(dir, full.names = T)
  my_data <- list()
  my_data <- lapply(my_files, read.csv)
  df <- do.call("rbind", my_data)
  
  # Convert NaN to NA
  df$sulfate[is.nan(df$sulfate)] <- NA
  df$nitrate[is.nan(df$nitrate)] <- NA
  
  # Create data frame
  df <- df[df$ID %in% id,]
  cases <- na.omit(df) %>% count("ID")
  cases
}


## Part 3
# Write a function that takes a directory of data files and a threshold for complete cases and 
# calculates the correlation between sulfate and nitrate for monitor IDs where the number of completely
# observed cases is greater than the threshold. The function should return a vector of correlations for
# the monitors that meet the threshold requirement. Otherwise, a numeric vector of length 0.

corr <- function(dir, threshold = 0){
  # Extract files and prepare df
  my_files <- list.files(dir, full.names = T)
  my_data <- list()
  my_data <- lapply(my_files, read.csv)
  df <- do.call("rbind", my_data)
  
  # Convert NaN to NA
  df$sulfate[is.nan(df$sulfate)] <- NA
  df$nitrate[is.nan(df$nitrate)] <- NA
  df <- na.omit(df)
  
  # Filter cases
  cases <- df %>% count("ID")
  IDs <- cases[cases$freq > threshold,"ID"]
  
  # Calculate corr
  df2 <- df[df$ID %in% IDs,]
  ddply(df2, .(ID), function(df2){return(data.frame(COR = cor(df2$sulfate, df2$nitrate)))})
  # alternative (slower)
  # s <- split(df2, df2$ID) # splits the df by a group (or more than 1)
  # do.call("rbind",lapply(s, function(x) cor(x$sulfate,x$nitrate))) # lapply passes 1 FUN on each group
}


##### QUIZ #####
getwd()

# Q1: 4.064128
pollutantmean("specdata", "sulfate", 1:10)

# Q2: 1.706047
pollutantmean("specdata", "nitrate", 70:72)

# Q3: 1.477143
pollutantmean("specdata", "sulfate", 34)

# Q4: 1.702932
pollutantmean("specdata", "nitrate")

# Q5: 228 148 124 165 104 460 232
complete("specdata", c(6, 10, 20, 34, 100, 200, 310))$freq

# Q6: 219
complete("specdata", 54)$freq

# Q7: error
RNGversion("3.5.1")  
set.seed(42)
cc <- complete("specdata", 332:1)
use <- sample(332, 10)
print(cc[use, "freq"])

# Q8: error
cr <- corr("specdata")                
cr <- sort(cr$COR)   
RNGversion("3.5.1")
set.seed(868)                
out <- round(cr[sample(length(cr), 5)], 4)
print(out)

# Q9: error
cr <- corr("specdata", 129)                
cr <- sort(cr$COR)                
n <- length(cr)    
RNGversion("3.5.1")
set.seed(197)                
c(n, round(cr[sample(n, 5)], 4))

# Q10: .0000 -0.0190  0.0419  0.1901
cr <- corr("specdata", 2000)                
n <- nrow(cr)                
cr <- corr("specdata", 1000)                
cr <- sort(cr$COR)
print(c(n, round(cr, 4)))








