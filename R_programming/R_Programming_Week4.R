# Programming assignment - Week 4 - R Programming 
# Hospital quality

## LOAD DATA
outcome <- read.csv("rprog_data_ProgAssignment3-data/outcome-of-care-measures.csv", 
                    colClasses = "character")
library(dplyr)


## EXPLORE DATA
head(outcome)
dim(outcome)
str(outcome)
summary(outcome)
names(outcome) 


## PROCESS DATA
for (n in c(11,13:15,17,18:21)) {
  outcome[, n] <- as.numeric(outcome[, n])
}


## 1. Plot the 30 day mortality rates for heart attack
hist(outcome[, 11], xlab = "30 days Death Mortality Rates", 
     main = "Frequency of Heart Attack Mortality")


## 2. Finding the best hospital in a state
best <- function(state, outcome) {
  ## 1. Read outcome data
  df <- read.csv("rprog_data_ProgAssignment3-data/outcome-of-care-measures.csv", 
                      colClasses = "character")
  df <- df[,c(2,7,11,17,23)] # subset main data frame
  
  defaultW <- getOption("warn") # temporarily suppress warning messages
  options(warn = -1) 
  for (n in c(3:5)) {df[, n] <- as.numeric(df[, n])} # convert to numeric
  options(warn = defaultW) # reactivate warning messages
  
  names(df) <- c("hospital", "state", "heart attack", "heart failure", "pneumonia") # rename columns

  ## 2. Check that state and outcome are valid
  quality <- FALSE
  if(!(tolower(state) %in% tolower(unique(df$state)))){
    message("Invalid State")
    } else if(!(tolower(outcome) %in% c("heart attack", "heart failure", "pneumonia"))){
      message("Invalid outcome: Possible outcomes are “heart attack”, “heart failure”, or “pneumonia”")
      } else {
        quality <- TRUE
        }
    
  ## 3. Return hospital name in that state with lowest 30-day death rate
  if (quality == TRUE) {
    hospitals <- na.omit(df[df$state == state, c("hospital",outcome)]) # filter df based on input & remove NAs
    bestH <- hospitals[order(hospitals[,2],hospitals$hospital),][1,1] # sort and pick top hospital
    bestH
  }
}


# 3. Ranking hospitals by outcome in a state
rankhospital <- function(state, outcome, num = "best") {
  ## 1. Read outcome data
  df <- read.csv("rprog_data_ProgAssignment3-data/outcome-of-care-measures.csv", 
                 colClasses = "character")
  df <- df[,c(2,7,11,17,23)] # subset main data frame
  
  defaultW <- getOption("warn") # temporarily suppress warning messages
  options(warn = -1) 
  for (n in c(3:5)) {df[, n] <- as.numeric(df[, n])} # convert to numeric
  options(warn = defaultW) # reactivate warning messages
  
  names(df) <- c("hospital", "state", "heart attack", "heart failure", "pneumonia") # rename columns

  ## 2. Check that state and outcome are valid
  quality <- FALSE
  if(!(tolower(state) %in% tolower(unique(df$state)))){
    message("Invalid State")
  } else if(!(tolower(outcome) %in% c("heart attack", "heart failure", "pneumonia"))){
    message("Invalid outcome: Possible outcomes are “heart attack”, “heart failure”, or “pneumonia”")
  } else {
    quality <- TRUE
  }
  
  ## 3. Return hospital name in that state with the given rank
  if (quality == TRUE) {
    hospitals <- na.omit(df[df$state == state, c("hospital",outcome)]) # filter df based on input & remove NAs
    
    if (tolower(num) == "best") {
      rankH <- hospitals[order(hospitals[,2],hospitals$hospital),][1,1] # pick best hospital
    } else if (tolower(num) == "worst") {
      rankH <- hospitals[order(hospitals[,2],hospitals$hospital),][nrow(hospitals),1] # pick worst hospital
      } else if (num <= nrow(hospitals)) {
        rankH <- hospitals[order(hospitals[,2],hospitals$hospital),][num,1] # pick hospital by rank
        } else {rankH <- NA} # otherwise NA
    
    rankH # print result
  }
}


# 4. Ranking hospitals in all states
rankall <- function(outcome, num = "best") {
  ## 1. Read outcome data
  df <- read.csv("rprog_data_ProgAssignment3-data/outcome-of-care-measures.csv", 
                 colClasses = "character")
  df <- df[,c(2,7,11,17,23)] # subset main data frame
  
  defaultW <- getOption("warn") # temporarily suppress warning messages
  options(warn = -1) 
  for (n in c(3:5)) {df[, n] <- as.numeric(df[, n])} # convert to numeric
  options(warn = defaultW) # reactivate warning messages
  
  names(df) <- c("hospital", "state", "heart attack", "heart failure", "pneumonia") # rename columns

  ## 2. Check that state and outcome are valid
  if(!(tolower(outcome) %in% c("heart attack", "heart failure", "pneumonia"))){
    quality <- FALSE
    message("Invalid outcome: Possible outcomes are “heart attack”, “heart failure”, or “pneumonia”")
  } else {
    quality <- TRUE
  }
  
  ## 3. For each state, find the hospital of the given rank
  if (quality == TRUE) {
    hospitals <- na.omit(df[, c("hospital","state",outcome)]) # filter df based on input & remove NAs
    sortedH <- hospitals[order(hospitals$state,hospitals[,3],hospitals$hospital),] # sort by state, value, hospital name
    states <- unique(sortedH$state) # list of states
    results <- data.frame(state = states,hospital = NA) # create empty df
    
    if (tolower(num) == "best") { # take top result of each state
      for (state in states) {
        y <- sortedH[sortedH$state == state,1:2][1,]
        results[results$state == state,2] <- y$hospital
        } 
      } else if (tolower(num) == "worst") { # take last results of each state
        for (state in states) {
          y <- sortedH[sortedH$state == state,1:2]
          y <- y[nrow(y),]
          results[results$state == state,2] <- y$hospital
          } 
      } else if (num <= nrow(hospitals)) { # take n result of each state
        for (state in states) {
          y <- sortedH[sortedH$state == state,1:2][num,]
          results[results$state == state,2] <- y$hospital
          }
    } else {message("Input 'num' too big")} # otherwise NA
    
    results[,c(2,1)] # print result
  }
}






