#http://166.122.78.194:80/cgi-bin/datalog.xml?sdate=1806030000&days=2
#http://www.informit.com/articles/article.aspx?p=2215520



library("XML")
library("plyr")

#############################################################
setwd("~/MyProjects/BioMin_HIS/RAnalysis/Data") #set working directory
#############################################################

xmlfile <- xmlParse("http://166.122.78.194:80/cgi-bin/datalog.xml?sdate=1806200000&days=4") #read in the date (180620) plus # days (days=4) of Apex data

Apex.Data <- ldply(xmlToList(xmlfile), data.frame) #convert xml to dataframe

Apex.Data2 <- Apex.Data[4:nrow(Apex.Data),] #remove extra metadata from top
Apex.Data2 <- head(Apex.Data2,-2) #remove extra metadata from bottom

#keep columnes with data of interest. This needs to be changed as it will be specific to the Apex configuration
Probe.Data <- Apex.Data2[,c(3,6,9,15, 75, 78, 72, 81, 84, 90)] #select columns
colnames(Probe.Data ) <- c("Date.Time", "Tmp_XL", "pH_XL", "Salt_XL", "Tmp_L", "pH_L", "Salt_L","Tmp_A", "pH_A", "Salt_A")  #rename columns
Probe.Data$Date.Time <- as.POSIXct(Probe.Data$Date.Time, format = "%m/%d/%Y %H:%M:%S", tz="HST") #convert date to HI time
write.csv(Probe.Data, "~/MyProjects/BioMin_HIS/RAnalysis/Output/Apex_Data_Output.csv") #write file to save data

#plot Temp and pH and save to output
pdf("~/MyProjects/BioMin_HIS/RAnalysis/Output/Apex_Output.pdf")
par(mfrow=c(2,1))
plot(as.numeric(as.character(Tmp_XL)) ~ Date.Time, Probe.Data, col = "grey", type="l", ylim=c(25.5, 30),  xlab="Time", ylab="Temperature °C")
lines(as.numeric(as.character(Tmp_L)) ~ Date.Time, Probe.Data, col = "red")
lines(as.numeric(as.character(Tmp_A)) ~ Date.Time, Probe.Data, col = "blue")
axis.POSIXct(side=1, Probe.Data$Date.Time)

plot(as.numeric(as.character(pH_XL)) ~ Date.Time, Probe.Data, col = "grey", type="l", ylim=c(7.1, 8.1),  xlab="Time", ylab="pH NBS")
lines(as.numeric(as.character(pH_L)) ~ Date.Time, Probe.Data, col = "red")
lines(as.numeric(as.character(pH_A)) ~ Date.Time, Probe.Data, col = "blue")
axis.POSIXct(side=1, Probe.Data$Date.Time)
dev.off()

All.Data <- read.csv("Apex_Data_All.csv", header=TRUE, sep=",", na.string="NA", as.is=TRUE)
All.Data$Date.Time <- as.POSIXct(All.Data$Date.Time, format = "%m/%d/%Y %H:%M", tz="HST") #convert date to HI time


#plot Temp and pH and save to output
pdf("~/MyProjects/BioMin_HIS/RAnalysis/Output/All_Apex_Output.pdf")
par(mfrow=c(2,1))
plot(as.numeric(as.character(Tmp_XL)) ~ Date.Time, All.Data, col = "grey", type="l", ylim=c(25.5, 30),  xlab="Time", ylab="Temperature °C")
lines(as.numeric(as.character(Tmp_L)) ~ Date.Time, All.Data, col = "red")
lines(as.numeric(as.character(Tmp_A)) ~ Date.Time, All.Data, col = "blue")
axis.POSIXct(side=1, Probe.Data$Date.Time)

plot(as.numeric(as.character(pH_XL)) ~ Date.Time, All.Data, col = "grey", type="l", ylim=c(7.1, 8.1),  xlab="Time", ylab="pH NBS")
lines(as.numeric(as.character(pH_L)) ~ Date.Time, All.Data, col = "red")
lines(as.numeric(as.character(pH_A)) ~ Date.Time, All.Data, col = "blue")
axis.POSIXct(side=1, Probe.Data$Date.Time)
dev.off()
