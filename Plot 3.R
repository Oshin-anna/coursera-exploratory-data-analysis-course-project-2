# Download archive file, if it does not exist

archiveFile <- "NEI_data.zip"

if(!file.exists(archiveFile)) {
  
  archiveURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  
  download.file(url=archiveURL,destfile=archiveFile)
}

if(!(file.exists("summarySCC_PM25.rds") && file.exists("Source_Classification_Code.rds"))) { 
  unzip(archiveFile) 
}

file_name <- "summarySCC_PM25.rds"
data <- readRDS(file_name)

emi_balt_t <- data %>% group_by(type, year) %>% filter(fips == "24510") %>% 
  summarise(total = sum(Emissions))


## `summarise()` has grouped output by 'type'. You can override using the `.groups` argument.
ggplot(emi_balt_t, aes(x = factor(year), 
                       y = total, fill = type, label = round(total))) + 
  geom_bar(stat = "identity") + facet_grid(. ~ type) + 
  ggtitle("Total PM2.5 Emissions in Baltimore City, Maryland") + 
  xlab("Year")+ ylab("PM2.5 Emissions in Tons") +
  theme_classic() + theme(plot.title = element_text(hjust = 0.5))
