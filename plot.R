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

png("plot1.png")
plot(unique(NEI$year), res, xlab="year", ylab="Emission")
dev.off()

png("plot2.png")
plot(unique(BAL$year), tapply(BAL$Emissions, BAL$year, sum), xlab="year", ylab="Baltimore Emission")
dev.off()


png("plot3.png")
ggplot(d, aes(year, y=Emissions, color=type)) + geom_point(aes(y=POINT, col="POINT")) + geom_point(aes(y=NONPOINT, col="NONPOINT")) + geom_point(aes(y=`ON-ROAD`, col="ON-ROAD")) + geom_point(aes(y=`NON-ROAD`, col="NON-ROAD"))
dev.off()

i<-NEI$SCC %in% unique(SCC[grep("Coal", SCC[grep("Fuel Comb", SCC$EI.Sector),]$EI.Sector),]$SCC)
d<-NEI[i,]
png("plot4.png")
plot(unique(d$year), tapply(d$Emissions, d$year, sum), xlab="year", ylab="Emission")
dev.off()

i<-BAL$SCC %in% unique(SCC[grep("Mobile", SCC$EI.Sector),]$SCC)
d<-BAL[i,]
png("plot5.png")
plot(unique(d$year), tapply(d$Emissions, d$year, sum), xlab="year", ylab="Emission")
dev.off()

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
