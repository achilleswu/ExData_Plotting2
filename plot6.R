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


i<-NEI$fips=="24510"
BAL<-NEI[i,]
i<-NEI$fips=="06037"
LA<-NEI[i,]
i<-BAL$SCC %in% unique(SCC[grep("Mobile", SCC$EI.Sector),]$SCC)
j<-LA$SCC %in% unique(SCC[grep("Mobile", SCC$EI.Sector),]$SCC)
d1<-BAL[i,]
d2<-LA[j,]
png("plot6.png")
par(mfrow=c(2,1))
plot(unique(d1$year), tapply(d1$Emissions, d1$year, sum), xlab="year", ylab="BAL Emission")
plot(unique(d2$year), tapply(d2$Emissions, d2$year, sum), xlab="year", ylab="LA Emission")
dev.off()
