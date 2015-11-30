# Following Getting and Cleaning Data, using dplyr
# For dplyr reference, https://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html

library(dplyr)
library(ggplot2)

NEI <- readRDS("summarySCC_PM25.rds")

# Step 1: Data aggregation
# Filtering the dataset for Baltimore, MD based on fips

filtered_NEI <- filter(NEI, fips=="24510")

# Selecting only necessary variables from the data frame i.e. year and Emissions
# Breaking down the dataset into specific group of rows; in this case, by type and year


sub_NEI <- group_by(select(filtered_NEI, year, type, Emissions), type, year)

# We summarize with aggregate functions like sum in this instance; we take the sum of Emissions
# NAs are removed, if any

summ_NEI <- summarize(sub_NEI, total = sum(Emissions, na.rm=TRUE))

png("plot3.png", height=750, width=750)

# In aes function, color coded geometric lines by type 

print(ggplot(summ_NEI, aes(year, total, color = type))+ geom_line() +
  xlab("Years") +
  ylab(expression('Total PM'[2.5]*" Emissions")) +
  ggtitle('Total Emissions in Baltimore by type between 1998-2008'))

dev.off()



