# Following Getting and Cleaning Data, using dplyr
# For dplyr reference, https://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html

library(dplyr)

NEI <- readRDS("summarySCC_PM25.rds")

# Step 1: Data aggregation
# Filtering the dataset for Baltimore, MD based on fips

filtered_NEI <- filter(NEI, fips=="24510")

# Selecting only necessary variables from the data frame i.e. year and Emissions
# Breaking down the dataset into specific group of rows; in this case, year only

sub_NEI <- group_by(select(filtered_NEI, year, Emissions), year)

# We summarize with aggregate functions like sum in this instance; we take the sum of Emissions
# NAs are removed, if any

summ_NEI <- summarize(sub_NEI, total = sum(Emissions, na.rm=TRUE))

# Step 2: Plotting 


png("plot2.png", height=480, width=480)

# Barplot discriminates different years by colors 

barplot(height=summ_NEI$total, names.arg=summ_NEI$year, xlab="Years", ylab=expression('total PM'[2.5]*' emission'),
        main=expression('Total PM'[2.5]*' emissions over 1999, 2002, 2005 and 2008 for Baltimore'),
	col=c("black", "darkblue", "red","yellow"))

dev.off()



