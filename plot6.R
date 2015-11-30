library(dplyr)
library(ggplot2)

NEI <- readRDS("summarySCC_PM25.rds")

# Only opted for type "ON-ROAD" implying to motor vehicles; filtered by fips == Baltimore, MD and LA County

combined <- filter(NEI, fips %in% c("24510", "06037"), type=="ON-ROAD")

# Selecting only pertinent columns

combined <- select(combined, fips, SCC, year, Emissions)

# Grouping by fips and year

combined <- group_by(combined, fips, year)

# We summarize with aggregate functions like sum in this instance; we take the sum of Emissions
# NAs are removed, if any

summary <- summarize(combined, total = sum(Emissions, na.rm=TRUE))

# For better representation, numerical fips are coverted to their corresponding names

summary$fips[summary$fips == "24510"] <- c("Baltimore")
summary$fips[summary$fips == "06037"] <- c("LA County")



png("plot6.png", width=750, height=750)

print(ggplot(summary, aes(factor(year), total, fill=factor(year))) + facet_grid(.~ fips)
      + geom_bar(stat="identity") + scale_fill_hue() + xlab("Years") + 
        ylab(expression('Total PM'[2.5]*" Emissions")) +
        ggtitle(expression('Total PM'[2.5]*" Baltimore vs LA Emissions from motor vehicle sources between 1999-2008")))

dev.off()


