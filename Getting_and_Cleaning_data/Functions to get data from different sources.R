###### ____ Getting and Cleaning Data - Week 1 ____ ######

## USEFUL FUNCTIONS
getwd()
setwd()

if (!file.exists("path folder or file")) {
  dir.create("path folder/name")
}

# download file from internet
fileURL <- "https://something.com"
file <- download.file(fileURL, 
                      destfile = "./DestFolder", # or destfile = "./Folder/Filename.csv" to 'save as'
                      method = "curl") 
list.files("./DestinationFolder") # to check if everything went fine
dateDownloaded <- date() # to store the download date, just in case


# reading local files
data <- read.table(file = "./filepath",
                   sep = ",", # or read.csv() or read.csv2() if the file is CSV
                   header = TRUE,
                   na.strings = "-1", # set NA with specific characters (-1, 99, "Not Available"...)
                   quote = "", # to specify whether there are any quoted values ´
                   nrows = 100, # how many rows to read
                   skip = 2) # number of lines to skip at the beginning


# reading Excel files
library(xlsx)
data <- read.xlsx("./filepath",  # read.xlsx2() is much faster but might be unstable in some circumstances
                  sheetIndex = 1, # which Excel sheet is the data on
                  header = T)
write.xlsx() # to save as Excel file

library(XLConnect) # another nice package to work with Excel files


# reading XML files (eXtensible Markup Languange), very used in internet applications
library(XML)
fileURL <- "https:www.tuamadre.com/beyonce/queen.xml"
doc <- xmlTreeParse(fileURL, useInternal = T) # download the xml file as a R structured object 
# use htmlTreeParse(fileURL, useInternal = T) for html files, the following stays the same

rootNode <- xmlRoot(doc) # the root node is sort of the wrapper for the entire document
xmlName(rootNode) # prints out the name of the file
names(rootNode) #prints out the name of each nested element of the xml file

rootNode[[1]] # to access the first nested element (it's a huge chunk of xml code)
rootNode[[1]][[1]] # to access the first node of the first element (e.g. <name>Waffle</name>)

xmlSApply(rootNode,xmlValue) # programmatically extracts the values of the file removing the tags <A></A>
# However, it does it by collapsing all the values together, which makes it difficult to separate them.
# Learning some XPath programming language might be beneficial, when working often with XML files.
# This language can be passed in xmlSApply() to improve the extraction process. For example,
# xmlSApply(rootNode,"//name",xmlValue) extracts all values of the node 'name' as a character vector, etc.


# reading JSON files (JavaScript Object Notation) from an API
library(jsonlite) # amazing package
JSONdata <- fromJSON("https://api.github.com/users/aeoli/repos")
names(JSONdata)

myjson <- toJSON(iris, pretty = TRUE) # exports data in JSON format
cat(myjson) # example


# the data.table package
library(data.table) # written in C so it is much faster than data.frame, also in subsetting/grouping/etc.
df <- data.table(x = rnorm(9), y = rep(c("a","b","c"), each = 3), z = rnorm(9))
# however the syntax is quite different, it requires some study



