# Following Getting and Cleaning Data, using dplyr
# For dplyr reference, https://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html

library(dplyr)
library(ggplot2)

NEI <- readRDS("summarySCC_PM25.rds")

# Only opted for type "ON-ROAD" implying to motor vehicles; filtered by fips == Baltimore, MD

filtered_NEI <- filter(NEI, fips=="24510", type=="ON-ROAD")

sub_NEI <- select(filtered_NEI, year, SCC, Emissions)

# Breaking down the dataset into specific group of rows; in this case, by year

grouped <- group_by(sub_NEI, year)

# We summarize with aggregate functions like sum in this instance; we take the sum of Emissions
# NAs are removed, if any


summary <- summarize(grouped, total = sum(Emissions, na.rm=TRUE))

png("plot5.png", width=750, height=750)

print(ggplot(summary, aes(factor(year), total, fill=factor(year))) 
      + geom_bar(stat="identity") + xlab("Years") +
        ylab(expression('Total PM'[2.5]*" Emissions")) +
        ggtitle(expression('Total PM'[2.5]*" Baltimore's Emissions from various motor vehicle sources between 1999 and 2008")))

dev.off()







