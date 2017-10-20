library(fitdistrplus)
library(logspline)
library(MASS) 
library(ADGofTest)

# Load data
setwd('C:/Users/s147569/Dropbox/School/BEP/SVN/Trunk/R scripts')
CsvData <-read.csv("TransitionTimes.csv", header=TRUE, na.strings=c("","NA"))
StateLifetimes <-read.csv("StateLifetimes.csv", header=TRUE, na.strings=c("","NA"))
transitionTimes <- CsvData


weibullShapes <- numeric(56)
weibullPs <- numeric(56)

minExpP <- 1
minWeibullP <- 1


for (state in 1:57) {
  # Compute
  times <- Filter(function(t) {return(!is.na(t) && t > 0)},transitionTimes[[state]])
  if (length(times)==0) {
    next
  }
  average <-mean(times)
  standardDeviation <- sd(times)
  cdf <- ecdf(times)
  pdf <- density(times)
  
  #descdist(times, discrete = FALSE)
  
  #expFit <- fitdistr(times, "exponential")
  #weibullFit <- fitdistr(times, "weibull")
  #gammaFit <- fitdistr(times, "gamma")
  #normFit <- fitdistr(times, "normal")
  #print(ad.test(times, pexp,rate = expFit$estimate[["rate"]]))
  
  #plot(cdf,xlim=c(0,2*average), col="green", ylab="F(x)")
  #x <- seq(0,2*average,2*average/100)
  #lines(x,pexp(x, rate = expFit$estimate[["rate"]]), col="red")
  #lines(x,pweibull(x,shape=weibullFit$estimate[["shape"]], scale = weibullFit$estimate[["scale"]]), col="black")
  #lines(x,pgamma(x, shape=gammaFit$estimate[["shape"]],rate = gammaFit$estimate[["rate"]]), col="blue")
  #lines(x,pnorm(x, mean=normFit$estimate[["mean"]],sd = normFit$estimate[["sd"]]), col="black") # Normal does not fit at all
  #print(weibullFit)
  #weibullTest <- ad.test(times, pweibull,shape=weibullFit$estimate[["shape"]], scale = weibullFit$estimate[["scale"]])
  #expTest <- ad.test(times, pexp,rate = expFit$estimate[["rate"]])
  #shapiro <- shapiro.test(times)
  #print(paste(expFit$estimate[["rate"]],expTest$p.value[[1]]))
  
  #x <- seq(min(times),max(times)-min(times),(max(times)-min(times))/100)
  #plot(pdf,xlim=c(min(times),max(times)), col="green", xlab="time", ylab="density",main=paste("Observed density vs theoretical density",state))
  #lines(x,dexp(x,rate = expFit$estimate[["rate"]]), col="black")
  
  #if (expTest$p.value[[1]] < minExpP)
  #  minExpP <- expTest$p.value[[1]]
  #if (weibullTest$p.value[[1]] < minWeibullP)
  #  minWeibullP <- weibullTest$p.value[[1]]
  
  #normFit <- fitdistr(times, "normal")
  #print(ad.test(times, pnorm,mean = normFit$estimate[["mean"]], sd=normFit$estimate[["sd"]]))
}

# State lifetimes
for (state in 1:57) {
  # Compute
  times <- Filter(function(t) {return(!is.na(t) && t > 0)},StateLifetimes[[state]])
  if (length(times)==0) {
    next
  }
  average <-mean(times)
  standardDeviation <- sd(times)
  cdf <- ecdf(times)
  pdf <- density(times)
  plot(pdf,xlim=c(min(times),max(times)), col="green", xlab="time", ylab="density",main=paste("Time to live in state ",state))
}
