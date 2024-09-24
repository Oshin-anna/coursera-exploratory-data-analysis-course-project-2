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

emi_year <- data %>% group_by(year) %>% summarise(total = sum(Emissions))
plot1 <- barplot(emi_year$total/1000, main = "Total PM2.5 Emissions", 
                 xlab = "Year", ylab = "PM2.5 Emissions in Kilotons", 
                 names.arg = emi_year$year, col = "orange", ylim = c(0,8300))

text(plot1, round(emi_year$total/1000), label = round(emi_year$total/1000), 
     pos = 3, cex = 1.2)
