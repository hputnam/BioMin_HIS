#http://166.122.78.194:80/cgi-bin/datalog.xml?sdate=1806030000&days=2
#http://www.informit.com/articles/article.aspx?p=2215520

install.packages("XML")
install.packages("plyr")
install.packages("ggplot2")
install.packages("gridExtra")

require("XML")
require("plyr")
require("ggplot2")
require("gridExtra")


xmlfile <- xmlParse("http://166.122.78.194:80/cgi-bin/datalog.xml?sdate=1806010000&days=3") #read in the last 2 days of Apex data

Apex.Data <- ldply(xmlToList(xmlfile), data.frame) #convert xml to dataframe

Apex.Data2 <- Apex.Data[4:nrow(Apex.Data),]
Apex.Data2 <- head(Apex.Data2,-2)
  
#Apex.Data2[c(1:nrow(Apex.Data2)-2,)]

#keep columnes with 
Probe.Data <- Apex.Data2[,c(3,6,9,15, 75, 78, 72, 81, 84, 90)]
colnames(Probe.Data ) <- c("Date.Time", "Tmp_XL", "pH_XL", "Salt_XL", "Tmp_L", "pH_L", "Salt_L","Tmp_A", "pH_A", "Salt_A")  
Probe.Data$Date.Time <- as.POSIXct(Probe.Data$Date.Time, format = "%m/%d/%Y %H:%M:%S", tz="HST")
write.csv(Probe.Data, "~/MyProjects/BioMin_HIS/RAnalysis/Output/Apex_Data_Output.csv")


pdf("~/MyProjects/BioMin_HIS/RAnalysis/Output/Apex_Output.pdf")
par(mfrow=c(2,1))
plot(as.numeric(as.character(Tmp_XL)) ~ Date.Time, Probe.Data, col = "grey", type="l", ylim=c(25.5, 28),  xlab="Time", ylab="Temperature °C")
lines(as.numeric(as.character(Tmp_L)) ~ Date.Time, Probe.Data, col = "red")
lines(as.numeric(as.character(Tmp_A)) ~ Date.Time, Probe.Data, col = "blue")
axis.POSIXct(side=1, Probe.Data$Date.Time)

plot(as.numeric(as.character(pH_XL)) ~ Date.Time, Probe.Data, col = "grey", type="l", ylim=c(7.1, 8.1),  xlab="Time", ylab="pH NBS")
lines(as.numeric(as.character(pH_L)) ~ Date.Time, Probe.Data, col = "red")
lines(as.numeric(as.character(pH_A)) ~ Date.Time, Probe.Data, col = "blue")
axis.POSIXct(side=1, Probe.Data$Date.Time)

# plot(as.numeric(as.character(Salt_XL)) ~ Date.Time, Probe.Data, col = "grey", type="l", ylim=c(20, 35),  xlab="Time", ylab="Salinity psu")
# lines(as.numeric(as.character(Salt_L)) ~ Date.Time, Probe.Data, col = "red")
# lines(as.numeric(as.character(Salt_A)) ~ Date.Time, Probe.Data, col = "blue")
# axis.POSIXct(side=1, Probe.Data$Date.Time)
dev.off()
