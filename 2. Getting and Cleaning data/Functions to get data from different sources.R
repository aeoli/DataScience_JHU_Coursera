###### ____ Getting and Cleaning Data - Week 1 & 2 ____ ######

## USEFUL FUNCTIONS
getwd()
setwd()

if (!file.exists("path folder or file")) {
  dir.create("path folder/name")
}

# the data.table package
library(data.table) # written in C so it is much faster than data.frame, also in subsetting/grouping/etc.
df <- data.table(x = rnorm(9), y = rep(c("a","b","c"), each = 3), z = rnorm(9))
# however the syntax is quite different, it requires some study


# 1. Download file from internet
fileURL <- "https://something.com"
file <- download.file(fileURL, 
                      destfile = "./DestFolder", # or destfile = "./Folder/Filename.csv" to 'save as'
                      method = "curl") 
list.files("./DestinationFolder") # to check if everything went fine
dateDownloaded <- date() # to store the download date, just in case


# 2. Read local files
data <- read.table(file = "./filepath",
                   sep = ",", # or read.csv() or read.csv2() if the file is CSV
                   header = TRUE,
                   na.strings = "-1", # set NA with specific characters (-1, 99, "Not Available"...)
                   quote = "", # to specify whether there are any quoted values ´
                   nrows = 100, # how many rows to read
                   skip = 2) # number of lines to skip at the beginning
file() # open a connection to a txt file
url() # open a connection to a url 
gzfile() # open a connection to a .gz file
bzfile() # open a connection to a .bz2 file
?connections # to know more + REMEMBER to close the connections!
# for other extensions/apps the syntax is usually de same 'read.app' (e.g. read.spss())


# 3. Read Excel files
library(xlsx)
data <- read.xlsx("./filepath",  # read.xlsx2() is much faster but might be unstable in some circumstances
                  sheetIndex = 1, # which Excel sheet is the data on
                  header = T)
write.xlsx() # to save as Excel file

library(XLConnect) # another nice package to work with Excel files


# 4. Read XML files (eXtensible Markup Languange), very used in internet applications
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
xpathSApply(rootNode,"//name",xmlValue) # extracts all values of the node 'name' as a chr vector, etc.


# 5. Read JSON files (JavaScript Object Notation)
library(jsonlite) # amazing package
JSONdata <- fromJSON("https://api.github.com/users/aeoli/repos")
names(JSONdata)

myjson <- toJSON(iris, pretty = TRUE) # exports data in JSON format
cat(myjson) # example


# 6. Reading from MySQL
library(RMySQL)
server <- dbConnect(MySQL(), user = "username", host = "MySQL_server_URL")
databases <- dbGetQuery(server, "show databases;") # check all available databases
database <- dbConnect(MySQL(), db = "database_name", # select the db that we will need
                      user = "username", host = "MySQL_server_URL")
allTables <- dbListTables(database)
column_names <- dbListFields(database,"table_name") # to get the attributes/column names
table_data <- dbReadTable(database, "table_name") # to get the whole table
query_data <- dbGetQuery(database, "SELECT COUNT(*) FROM table_name;") # to pass a query on a table
dbDisconnect(server) # once finished --> don't forget this!


# 7. Reading HDF5 (Hierarchical Data Format 5) - for large datasets
# BiocManager::install("rhdf5")
library(rhdf5)

# create file and add info
create_file <- h5createFile("example.h5")
create_file <- h5createGroup("example.h5", "group1")
create_file <- h5createGroup("example.h5", "group1/subgroup1")
A <- matrix(1:10, nr = 5, nc = 2) # or a dataframe or anything else
h5write(A, "example.h5", "group1/subgroup1/A")

h5ls("example.h5") # to check the whole file
h5read("example.h5", "group1/subgroup1/A") # to read/extract a specific data element


# 8. Reading data from the Web / Web scraping
url <- url("http://any_URL.com/whatever")

# first option
html_code <- readLines(url) # or htmlTreeParse(url, useInternal = T), as seen above
close(url) # close connection
html_code # visualize
xpathSApply(etc, etc) # see above

# second option
library(httr)
html_data <- GET(url)
content <- content(html_data, as = "text") # extracts the content as one big text string
parsed_html <- htmlParse(content, asText = TRUE) # parses it 
xpathSApply(etc, etc) # see above

# in case of required authentication
GET("http://blabla/auth/user/password", authenticate("user","pwd"))


# 9. Reading data from APIs
library(httr)
my_app <- oauth_app("twitter", key = "the_key", secret = "the_secret")
sig <- sign_oauth1.0(my_app, token = "the_token", token_secret = "the_token_secret")
html_data <- GET("url.bla.bla.bla.json", sig)
json_raw <- content(html_data)
data <- jsonlite::fromJSON(json_raw)





