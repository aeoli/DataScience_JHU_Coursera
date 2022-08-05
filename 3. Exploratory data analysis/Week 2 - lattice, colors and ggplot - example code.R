##### Exploratory Data Analysis - Week 2 #####


#### LATTICE: good to quickly plot multivariate data for exploratory analyses
library(lattice)
xyplot(y ~ x | f * g, data) # scatterplot y by x, grouped by f and g
xyplot(Ozone~Wind, data = airquality, col = "red", pch = 8, main = "Big Apple Data") # example
xyplot(Ozone~Wind | as.factor(Month), data = airquality, layout = c(5,1)) # multi-panel scatter plots 

# To customise more a plot we need to add panel functions
xyplot(y ~ x | f, panel = function(x, y, ...) {
  panel.xyplot(x, y, ...)  ## First call the default panel function for 'xyplot'
  panel.abline(h = median(y), lty = 2)  ## Add a horizontal line at the median
  # panel.lmline(x, y, col = 2) ## Overlay a simple linear regression line --> alternative option
})


#### Colors
# colours(): lists the names of 657 predefined colors for any plotting function
sample(colours(),10) # check 10 random examples

# colorRamp()
palette1 <- colorRamp(c("red","blue")) # colorRamp creates a palette function between two colors. 
palette1(0) # The function only takes n arguments, which ranges from 0 to 1, and returns n colors (1 color for each arg)

# colorRampPalette: similar but returns a palette
p1 <- colorRampPalette(c("red","blue")) # creates a function palette between some colours
p1(6) # returns a palette of lenght 6 of those specified colours

# RColorBrewer package: contains premade palettes (sequentials, divergents, and qualitatives)
cols <- brewer.pal(3, "BuGn") # select 3 colors from the palette BuGn
pal <- colorRampPalette(cols) # creates a pal() with those 3 colors
pal(20) # creates 20 shades of those 3 colours


#### GGPLOT2
library(ggplot2)

## qplot() for quick exploratory graphs
qplot(displ, hwy, data = mpg, color = drv) # scatterplot
qplot(displ, hwy, data = mpg, color = drv, geom = c("point", "smooth")) # the gray areas indicate the 95% CI of the trend line
qplot(drv, hwy, data = mpg, geom = "boxplot")
qplot(drv, hwy, data = mpg, geom = "boxplot", color = manufacturer)
qplot(hwy, data = mpg, fill = drv) # histogram
qplot(displ, hwy, data = mpg, facets = . ~ drv) # multiple panels. <variable in rows> ~ <var in columns>, '.' stands for 'nothing'
qplot(hwy, data = mpg, facets = drv ~ ., binwidth = 2)
qplot(price, data = diamonds, geom = "density", color = cut) # density

qplot(carat, price, data = diamonds, color = cut) + geom_smooth(method = "lm") # complex scatterplot


## ggplot() for full customization
g <- ggplot(mpg, aes(displ, hwy))
g + geom_point()
g + geom_point() + geom_smooth()
g + geom_point() + geom_smooth(method = "lm") # fits a linear model
g + geom_point() + geom_smooth(method = "lm") + facet_grid(.~drv)
g + geom_point() + geom_smooth(method = "lm") + facet_grid(.~drv) + ggtitle("Swirl Rules!")
g + geom_point(aes(color = drv)) + labs(title = "Swirl Rules!", x = "Displacement", y = "Hwy Mileage")

g + geom_point(color = "pink", size = 4, alpha = 0.5)
g + geom_point(size = 4, alpha = 0.5, aes(color = drv)) # in this case we need to call aes() bc the color 
                                                        # is not a constant anymore but depends on the data
g + geom_point(aes(color = drv), size = 2, alpha = 0.5) + geom_smooth(size = 4, linetype = 3, method = "lm", se = FALSE)
    # linetype specified that it should be dashed instead of continuous, se (std err) told ggplot to turn off the CI's gray shadows
g + geom_point(aes(color = drv)) + theme_bw(base_family = "Times")

g <- ggplot(mpg, aes(displ, hwy, color = factor(year)))
g + geom_point() + facet_grid(drv ~ cyl, margins = TRUE) + # margins tells ggplot to display the totals over each row and column!!
    geom_smooth(method = "lm", se = FALSE, size = 1, color = "black")

ggplot(diamonds, aes(carat, price)) + geom_boxplot() + facet_grid(.~cut) # boxplot example






