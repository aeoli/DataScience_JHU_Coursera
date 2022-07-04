###### ____ Getting and Cleaning Data - Week 3 ____ ######

### SUBSETTING AND SUMMARIZING DATA

## Check object size
data <- rnorm(1e5)
object.size(data)
print(object.size(data), units = "Mb")
rm(data)

## Table
data("iris")
table(iris$Species, useNA = "ifany") # if there are NAs, it will be printed out as an additional column

## Check if there are NAs in the dataset
colSums(is.na(iris))

## Cross tables (advanced tables for categorical variables)
data("warpbreaks")
summary(warpbreaks)
xtabs(breaks ~ tension, data = warpbreaks) # breaks per (~) tension

warpbreaks$replicate <- rep(1:3, len = 54) # however, if we add another variable it cannot handle it
xtabs(breaks ~ ., data = warpbreaks) # in 1 single table. breaks per (~) all vars (.)

## Flat tables: cross table with multiple dimensions
xt <- xtabs(breaks ~ ., data = warpbreaks) # We solve it with flat tables
ftable(xt)


### CREATING NEW VARIABLES

## Creating sequences
seq(1, 10, by = 2) # from 1 to 10, every 2 counts
seq(1, 10, length = 3) # from 1 to 10, only 3 values
x <- c(1,4,12,15,22)
seq(along = x) # from 1 to lenght(x)

## Creating new variables
iris$test <- iris$Petal.Length > 3
iris$test2 <- ifelse(iris$Petal.Width < 1.2, "Small", "Big")
xtabs(test ~ Species + test2, data = iris)

## Cut data by something
iris$cut <- cut(iris$Sepal.Length, breaks = quantile(iris$Sepal.Length))
table(iris$cut)
table(iris$cut,iris$Sepal.Length)

## Common transformations
abs(3.754) # absolute value
sqrt(3.754) # square root
ceiling(3.754) # round up
floor(3.754) # round down
round(3.754, digits = 2)
signif(3.754, digits = 2) # not sure what this one does
log(3.754) # but also log2(3.754) and log10(3.754)
exp(3.754) # exponentiating to x


### RESHAPING DATA FRAMES

## Some functions to check
melt()
dcast()
acast()

## dplyr package: simplified and much faster version of plyr (bc it's coded in C++)
library(dplyr)
# For every FUN, the first arg is the df, followed by instruction about what to do with it.
# no need to use $ or "" to specify the col name. The results is a new data frame.
select(iris, Species:test2) # from Species to test2. You can also use -(Species:test2) to exclude them.
filter(iris, Sepal.Length > 7 & Sepal.Width < 3) # WHERE statement
arrange(iris, Sepal.Length) # ORDER BY x
arrange(iris, desc(Sepal.Length)) # ORDER BY x DESC
rename(iris, qualcosa = test, qualcosaltro = test2) # SELECT x AS new_name
mutate(iris, test = Petal.Width - mean(Petal.Width)) # create new variable. SELECT FORMULA(x) AS new_column
gr_by <- group_by(iris, Species) # prepare a GROUP BY x
summarise(gr_by, mean_SL = mean(Sepal.Length), max_SW = max(Sepal.Width)) # visualize the GROUP BY

# Pipe operator: the most interesting asset of dplyr
iris %>% group_by(Species) %>% summarise(mean_SL = mean(Sepal.Length), max_SW = max(Sepal.Width))

# Join
merge(table_x, table_y, by = "id", all.x = TRUE) # if by is not specified merge will join all columns with the same
# name. We use by to specify the merging columns. Otherwise by.y and by.x to pick the individual column 
# names from each table. LEFT JOIN = all.x, RIGHT JOIN = all.y, INNER JOIN = all. Max 2 tables.

left_join(table_x, table_y, table_z) # dplyr function. Also for multiple joins. Automatically joins by 
# col with identical name. Otherwise it can be specifiec by = c("X_Col1" = "Y_Col1", etc.)







