library(fitdistrplus)
library(logspline)
library(MASS) 
library(ADGofTest)
library(PhaseType)
library(actuar)

# Load data
setwd('C:/Users/s147569/Dropbox/School/BEP/preventive-maintenance/R scripts')
CsvData <-read.csv("TraceLifetimes.csv", header=TRUE)
lifetimes <- CsvData$Lifetime / (3600*1000) # In hours

# Compute
average <-mean(lifetimes)
standardDeviation <- sd(lifetimes)
cdf <- ecdf(lifetimes)
probDens <- density(lifetimes)
probDensFunction <- with(probDens,  approxfun(x, y))

hazardFun <- function(x) probDensFunction(x) / (1-cdf(x))
hazard <- Vectorize(hazardFun)

shapiro <- shapiro.test(lifetimes)
# p very small so not normally distributed

descdist(lifetimes, discrete = FALSE)
# It is in the beta area but the beta distribution has support [0,1]
# Gamma or Weibull is more likely

# estimate parameters
normalFit <- fitdistr(lifetimes, "normal")
weibullFit <- fitdistr(lifetimes, "weibull")
gammaFit <- fitdistr(lifetimes, "gamma")
# Test GoF
normalTest <-ad.test(lifetimes,pnorm, mean=average, sd=standardDeviation)
gammaTest <- ad.test(lifetimes,pgamma,shape=gammaFit$estimate[["shape"]], rate = gammaFit$estimate[["rate"]])
weibullTest <- ad.test(lifetimes, pweibull,shape=weibullFit$estimate[["shape"]], scale = weibullFit$estimate[["scale"]])

# Plot
x <- seq(0,2*average,2*average/100)
qqnorm(lifetimes); qqline(lifetimes)

# Cumulative density
plot(cdf,xlim=c(min(lifetimes),max(lifetimes)), col="green", xlab="time", ylab="Cumulative distribution",main="Observed (green) vs theoretical (red)")
lines(x,pgamma(x,shape=gammaFit$estimate[["shape"]], rate = gammaFit$estimate[["rate"]]), col="red")
#lines(x,pnorm(x,mean=average,sd=standardDeviation), col="blue")
#lines(x,pweibull(x,shape=weibullFit$estimate[["shape"]], scale = weibullFit$estimate[["scale"]]), col="black")

# Density
plot(probDens,xlim=c(min(lifetimes),max(lifetimes)), col="green", xlab="time", ylab="density",main="Observed density vs theoretical density")
lines(x,dgamma(x,shape=gammaFit$estimate[["shape"]], rate = gammaFit$estimate[["rate"]]), col="red")
lines(x,0.8*dgamma(x,shape=30, rate = gammaFit$estimate[["rate"]])+0.2*dgamma(x,shape=50, rate = gammaFit$estimate[["rate"]]), col="black")

# Hazard
plot(hazard,xlim=c(min(lifetimes),max(lifetimes)), col="green", xlab="time", ylab="hazard rate",main="Hazard rate over time")


print(paste("Gamma with shape",gammaFit$estimate[["shape"]],"and rate",gammaFit$estimate[["rate"]],"p-value",gammaTest$p.value))