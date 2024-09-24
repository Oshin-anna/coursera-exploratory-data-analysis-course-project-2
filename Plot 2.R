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

emi_balt <- data %>% group_by(year) %>% filter(fips == "24510") %>% 
  summarise(total = sum(Emissions))

plot2 <- barplot(emi_balt$total, 
                 main = "Total PM2.5 Emissions in Baltimore City, Maryland", 
                 xlab = "Year", ylab = "PM2.5 Emissions in Tons", 
                 names.arg = emi_balt$year, col = "darkmagenta", ylim = c(0,3600))

text(plot2, round(emi_balt$total), label = round(emi_balt$total), 
     pos = 3, cex = 1.2)
