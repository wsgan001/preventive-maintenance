library(fitdistrplus)
library(logspline)
library(MASS) 
library(ADGofTest)

# Load data
setwd('C:/Users/s147569/Dropbox/School/BEP/Plugins/R scripts')
CsvData <-read.csv("TraceLifetimes.csv", header=TRUE)
lifetimes <- CsvData$Lifetime / (3600*1000) # In hours

# Compute
average <-mean(lifetimes)
standardDeviation <- sd(lifetimes)
cdf <- ecdf(lifetimes)

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
qqnorm(lifetimes); qqline(lifetimes)
plot(cdf,xlim=c(0,2*average), col="green", ylab="F(x)",main="Observed (green) vs theoretical (red)")
x <- seq(0,2*average,2*average/100)
lines(x,pgamma(x,shape=gammaFit$estimate[["shape"]], rate = gammaFit$estimate[["rate"]]), col="red")
#lines(x,pnorm(x,mean=average,sd=standardDeviation), col="blue")
#lines(x,pweibull(x,shape=weibullFit$estimate[["shape"]], scale = weibullFit$estimate[["scale"]]), col="black")

print(paste("Gamma with shape",gammaFit$estimate[["shape"]],"and rate",gammaFit$estimate[["rate"]],"p-value",gammaTest$p.value))