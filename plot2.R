library(ggplot2)
library(dplyr)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

res<-tapply(NEI$Emissions, NEI$year, sum)
i<-NEI$fips=="24510"
BAL<-NEI[i,]

i1<-BAL$type=="POINT"
i2<-BAL$type=="NONPOINT"
i3<-BAL$type=="ON-ROAD"
i4<-BAL$type=="NON-ROAD"

d<-tapply(BAL[i1,]$Emissions, BAL[i1,]$year, sum)
d<-cbind(d, tapply(BAL[i2,]$Emissions, BAL[i2,]$year, sum))
d<-cbind(d, tapply(BAL[i3,]$Emissions, BAL[i3,]$year, sum))
d<-cbind(d, tapply(BAL[i4,]$Emissions, BAL[i4,]$year, sum))
d<-data.frame(d)
names(d)<-unique(BAL$type)
d<-mutate(d, year=rownames(d))


png("plot2.png")
plot(unique(BAL$year), tapply(BAL$Emissions, BAL$year, sum), xlab="year", ylab="Baltimore Emission")
dev.off()
