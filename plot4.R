# Following Getting and Cleaning Data, using dplyr
# For dplyr reference, https://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html

library(dplyr)
library(ggplot2)

# In this plot both RDS files are read

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# RegEx used to opt for coal related coal combustions only
# Discussion forum aided into this understanding

coal_obsv <- grep('^fuel comb -(.*)- coal$', SCC$EI.Sector, ignore.case=TRUE)

# Matched rows are type of integer; converted to character type

match_rows <- as.character(SCC$SCC[coal_obsv])

# Selecting only necessary variables from the data frame i.e. year and Emissions

sub_NEI <- select(NEI, SCC, year, Emissions)

# Filtering for only those SCC in matched rows

sub_NEI <- filter(sub_NEI, SCC %in% match_rows)

# Breaking down the dataset into specific group of rows; in this case, by SCC and year
grouped <- group_by(sub_NEI, SCC, year)

# We summarize with aggregate functions like sum in this instance; we take the sum of Emissions
# NAs are removed, if any

summary <- summarize(grouped, total = sum(Emissions, na.rm=TRUE))

png("plot4.png", width=600, height=550)

print(ggplot(summary, aes(factor(year), total)) 
      + geom_bar(stat="identity") + xlab("Years") +
        ylab(expression('Total PM'[2.5]*" Emissions")) +
        ggtitle(expression('Total PM'[2.5]*"Emissions from various coal combustions over the span of 1999 to 2008")))

dev.off()






