library(fitdistrplus)
library(logspline)
library(MASS) 
library(ADGofTest)
library(PhaseType)
library(actuar)

# Load data
setwd('C:/Users/s147569/Dropbox/School/BEP/Plugins/R scripts')
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

# Prior on starting state
dirpi <- c(1, 0, 0)
# Gamma prior: shape hyperparameters (one per matrix element, columnwise)
nu <- c(0, 1, 1, 1, 0, 1, 1, 1,0)
# Gamma prior: reciprocal scale hyperparameters (one per matrix row)
zeta <- c(1, 1, 1)
# Define dimension of model to fit
n <- 3
# Perform 20 MCMC iterations (fix inner Metropolis-Hastings to one iteration
# since starts in stationarity here). Do more in practise!!
res1 <- phtMCMC(lifetimes, n, dirpi, nu, zeta, 20, mhit=5)
print(res1)

dPhaseType <- dphtype(x=1:2, c(1, 0, 0), matrix(c(0,res1$nu$S21,res1$nu$S31,res1$nu$S12,0,res1$nu$S13,res1$nu$S31,res1$nu$S23,0),3), log = FALSE)

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
lines(x,dPhaseType, col="black")

# Hazard
plot(hazard,xlim=c(min(lifetimes),max(lifetimes)), col="green", xlab="time", ylab="hazard rate",main="Hazard rate over time")


print(paste("Gamma with shape",gammaFit$estimate[["shape"]],"and rate",gammaFit$estimate[["rate"]],"p-value",gammaTest$p.value))