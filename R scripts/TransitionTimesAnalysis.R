library(fitdistrplus)
library(logspline)
library(MASS) 
library(ADGofTest)

# Load data
setwd('C:/Users/s147569/Dropbox/School/BEP/Plugins/R scripts')
CsvData <-read.csv("TransitionTimes.csv", header=TRUE, na.strings=c("","NA"))
transitionTimes <- CsvData


weibullShapes <- numeric(56)
weibullPs <- numeric(56)

minExpP <- 1
minWeibullP <- 1


for (state in 1:56) {
  # Compute
  times <- Filter(function(t) {return(!is.na(t) && t > 0)},transitionTimes[[state]])
  
  average <-mean(times)
  standardDeviation <- sd(times)
  cdf <- ecdf(times)
  
  #descdist(times, discrete = FALSE)
  
  expFit <- fitdistr(times, "exponential")
  weibullFit <- fitdistr(times, "weibull")
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
  weibullTest <- ad.test(times, pweibull,shape=weibullFit$estimate[["shape"]], scale = weibullFit$estimate[["scale"]])
  expTest <- ad.test(times, pexp,rate = expFit$estimate[["rate"]])
  #shapiro <- shapiro.test(times)
  print(paste(expFit$estimate[["rate"]], weibullFit$estimate[["shape"]],expTest$p.value[[1]],weibullTest$p.value[[1]]))
  
  if (expTest$p.value[[1]] < minExpP)
    minExpP <- expTest$p.value[[1]]
  if (weibullTest$p.value[[1]] < minWeibullP)
    minWeibullP <- weibullTest$p.value[[1]]
  
  #normFit <- fitdistr(times, "normal")
  #print(ad.test(times, pnorm,mean = normFit$estimate[["mean"]], sd=normFit$estimate[["sd"]]))
}

