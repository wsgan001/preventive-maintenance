library(fitdistrplus)
library(logspline)
library(MASS) 

# Load data
setwd('C:/Users/s147569/Dropbox/School/BEP/Plugins/R scripts')
CsvData <-read.csv("TraceLifetimes.csv", header=TRUE)
lifetimes <- CsvData$Lifetime

# Compute
average <-mean(lifetimes)
standardDeviation <- sd(lifetimes)
cdf <- ecdf(lifetimes)

shapiro <- shapiro.test(lifetimes)
# p very small so not normally distributed

descdist(lifetimes, discrete = FALSE)
# It is in the beta area but the beta distribution has support [0,1]
# Gamma is more likely

distr <- fitdistr(0.00001*lifetimes,"gamma") 
gammaTest <- ks.test(0.00001*lifetimes,"pgamma", 39.1476, 0.00824)
weibullTest <- ks.test(0.00001*lifetimes, "pweibull", scale=6.04, shape=5069.89)

# Plot
plot(cdf,xlim=c(0,2*average))
qqnorm(lifetimes); qqline(lifetimes)