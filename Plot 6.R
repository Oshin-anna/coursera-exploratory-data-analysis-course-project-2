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

balti_la_year <- motor_emi %>% filter(fips == "24510" | fips == "06037") %>% 
  group_by(fips, year) %>% summarise(total = sum(Emissions))
balti_la_year <- mutate(balti_la_year, 
                        Unit = ifelse(fips == "24510", "Baltimore City", 
                                      ifelse(fips == "06037", "Los Angeles County")))


ggplot(balti_la_year, aes(factor(year), total, 
                          fill = Unit, label = round(total))) + 
  geom_bar(stat = "identity") + facet_grid(. ~ Unit) + 
  ggtitle("Total Motor Vehicle Emissions") +
  xlab("Year") + ylab("Pm2.5 Emissions in Tons") +
  theme(plot.title = element_text(hjust = 0.5)) + ylim(c(0, 8000)) +
  theme_classic() + geom_text(size = 4, vjust = -1)
