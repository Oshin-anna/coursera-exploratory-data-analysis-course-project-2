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

data_motor <- data_ssc[grepl("Vehicle", data_ssc$SCC.Level.Two), ]

motor_scc <- unique(data_motor$SCC)
motor_emi <- data[(data$SCC %in% motor_scc), ]
motor_year <- motor_emi %>% filter(fips == "24510") %>% group_by(year) %>% 
  summarise(total = sum(Emissions))

ggplot(motor_year, aes(factor(year), total, label = round(total))) + 
  geom_bar(stat = "identity", fill = "lightgreen") + 
  ggtitle("Total Motor Vehicle Emissions in Baltimore City") + 
  xlab("Year") + ylab("PM2.5 Emissions in Tonnes") +
  ylim(c(0, 450)) + theme_classic()+ geom_text(size = 5, vjust = -1) + 
  theme(plot.title = element_text(hjust = 0.5))
