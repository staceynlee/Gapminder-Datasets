# Load libraries and data
library(ggplot2)
library(dplyr)
library(plyr)
library(tidyr)
library(readxl)

df <- read_excel("/Users/staceylee/Desktop/GitHub/Gapminder-Datasets/indicator\ GDP.xlsx")

# Remove rows with NAs
df_clean <- na.omit(df)

# Rename countries column and turn years into single column
df_clean <- rename(df_clean, c("pwt 7.1 rgdpl" = "Countries"))
df_clean <- gather(df_clean, "year", "gdp", 2:62)

# Plot GDP by country in 1950
df1950 <- filter(df_clean, year == "1950.0") 

ggplot(aes(x = Countries, y = gdp), data = df1950) + geom_bar(stat = "identity") + 
  theme(axis.text.x=element_text(angle = 90, hjust = 1, 
                                 vjust = 0.5, size = 11, margin=margin(5,5,10,5,"pt"))) + 
  labs(title = "GDP in 1950", y = "GDP/capita")

# Plot GDP by country in 2010
df2010 <- filter(df_clean, year == "2010.0")

ggplot(aes(x = Countries, y = gdp), data = df2010) + geom_bar(stat = "identity") + 
  theme(axis.text.x=element_text(angle = 90, hjust = 1, 
                                 vjust = 0.5, size = 11, margin=margin(5,5,10,5,"pt"))) + 
  labs(title = "GDP in 2010", y = "GDP/capita")

# Plot GDP by country by year
both <- filter(df_clean, year == "1950.0" | year == "2010.0")
  
ggplot(aes(x = Countries, y = gdp, color = year), data = both) + geom_bar(stat = "identity") + 
  theme(axis.text.x=element_text(angle = 90, hjust = 1, 
                                 vjust = 0.5, size = 11, margin=margin(5,5,10,5,"pt"))) + 
  labs(title = "GDP in 1950 vs 2010", y = "GDP/capita")

# Plot total GDP by year
totaldf <- na.omit(df)
totaldf <- rename(totaldf, c("pwt 7.1 rgdpl" = "Countries"))
totaldf <- select(totaldf, -Countries)
totaldfsum <- summarise_each(totaldf, funs(mean))
totaldfsum <- gather(totaldfsum, "year", "mean_gdp", 1:61)
USsum <- filter(df_clean, Countries == "United States")
  
ggplot() + geom_line(aes(x = year, y = mean_gdp, group = 1), color = "black", size = 1, 
                     data = totaldfsum) + 
  geom_line(aes(x = year, y = gdp, group = 1, label = "US"), color = "sky blue", size = 1, data = USsum) +
  theme(axis.text.x=element_text(angle = 90, hjust = 1, 
                                 vjust = 0.5, size = 11, margin=margin(5,5,10,5,"pt"))) +
  labs(title = "US (Blue) and Worldwide (Black) GDP Over Time", x = "Year", y = "GDP/capita")
