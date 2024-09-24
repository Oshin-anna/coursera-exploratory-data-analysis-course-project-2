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

ssc_file <- "Source_Classification_Code.rds"
data_ssc <- readRDS(ssc_file)

data_coal <- data_ssc[grepl("Comb.*Coal", data_ssc$EI.Sector), ]

coal_scc <- unique(data_coal$SCC)
coal_emi <- data[(data$SCC %in% coal_scc), ]
coal_year <- coal_emi %>% group_by(year) %>% summarise(total = sum(Emissions))

ggplot(coal_year, aes(factor(year), total/1000, label = round(total/1000))) + 
  geom_bar(stat = "identity", fill = "darkgreen") + 
  ggtitle("Total coal combustion related PM2.5 Emissions") + 
  xlab("Year") + ylab("PM2.5 Emissions in Kilotons") +
  ylim(c(0, 620)) + theme_classic()+ geom_text(size = 5, vjust = -1) + 
  theme(plot.title = element_text(hjust = 0.5))
