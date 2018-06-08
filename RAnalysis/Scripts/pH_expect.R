
Data <-read.table("Tank_Fluctuations.csv", header=TRUE, sep=",")
Data$Time <- as.POSIXct(Data$Time, format = "%H:%M", tz="HST") #convert date to HI time

Data$AMBIENT.Total <- Data$AMBIENT-0.14
Data$LOW.Total <- Data$LOW-0.14
Data$XLOW.Total <- Data$XLOW-0.14

#plot Temp and pH and save to output
pdf("~/MyProjects/BioMin_HIS/RAnalysis/Output/Expected_pH_Flux.pdf")
par(mfrow=c(2,1))
plot(as.numeric(as.character(AMBIENT)) ~ Time, Data, col = "blue", type="l", ylim=c(7.0, 8.0),  xlab="Time", ylab="pH NBS")
lines(as.numeric(as.character(LOW)) ~ Time, Data, col = "red")
lines(as.numeric(as.character(XLOW)) ~ Time, Data, col = "gray")
axis.POSIXct(side=1, Data$Time)

plot(as.numeric(as.character(AMBIENT.Total)) ~ Time, Data, col = "blue", type="l", ylim=c(7.0, 8.0),  xlab="Time", ylab="pH Total")
lines(as.numeric(as.character(LOW.Total)) ~ Time, Data, col = "red")
lines(as.numeric(as.character(XLOW.Total)) ~ Time, Data, col = "gray")
axis.POSIXct(side=1, Data$Time)
dev.off()

