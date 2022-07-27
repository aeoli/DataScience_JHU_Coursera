###### ____ Getting and Cleaning Data - Week 4 ____ ######

### EDITING TEXT VARIABLES
toupper("mimimi")
tolower("Mimimi")

strsplit("Lallero.1", "\\.") # splits a string using a pattern
sub("\\.","","Lallero.1.2.3") # substitutes the first thing that matches a pattern with a new string
gsub("\\.","","Lallero.1.2.3") # substitutes everything that matches a pattern with a new string

grep("are",c("volare","cantare","oh oh")) # returns the positions of a vector where a pattern is found
grepl("are",c("volare","cantare","oh oh")) # "logic grep": it returns TRUE/FALSE instead of position
grep("are",c("volare","cantare","oh oh"), value = T) # it returns the full value name instead of the position

nchar("tua madre")
substr(("tua madre"),1,3)
paste("tua","madre")

stringr::str_trim("tua     ") # removes whitespaces at the beginning/end/both of a string


### REGULAR EXPRESSIONS
# RegEx are ombinations of characters and metacharacters (which define the grammar)
# '^' matches the start of the line ('^I think' looks for setences that start with "I think")
# '$' represents the end of the line ('morning$')
# '[]' is used to make a list of characters ('[Bb][Uu][Ss][Hh]' will look for all variations of the word bush/bUsH/etc)
# '[-]' is used for ranges of letters ('[a-zA-Z]' will look for any letter, big or small)
# '[^]' ^ in those brackets means NOT ('[^ ]' means 'not a whitespace')
# They can be combined ('^[Ii] am' to look for 'I am' and 'i am' at the end of each sentence)
# '.' refers to any single character
# '|' means OR (marta|francesco|soup will look for results with either of those N words)
# '?' means optional (George W? Bush will look for the name with and without the W)
# '*' means any number (also 0) of the preceding character(s) ('.*' means 'anything')
# '+' means 'at least 1 of the preceding ch' ([0-9]+ means 'any number')
# '{min,max}' defines the min and max num of occurrences ('B{3,4}' will look for BBB and BBBB)



### DATE
d2 <- Sys.Date()
format(d2,"%a %b %d") # %d numeric daz - %a/%A abbr/normal weekday name - %m numeric month - %b/%B abbr/normal month name
                      # %y 2 digits year - %Y 4 digits year
x <- c("1jan1960","5mar1998")
z <- as.Date(x,"%d%b%Y")
z[2] - z[1]
as.numeric(z[2] - z[1])

weekdays(d2)
months(d2)

# the library(lubridate) as many cool functions for date formatting

