##PANEL DATA REGRESSION USING R STUDIO##
library(plm)
library(car)
library(lmtest)


datapanel <- read.delim("clipboard")
datapanel

pdata <- pdata.frame(datapanel, index=c("WILAYAH", "TAHUN"))
pdata


###{r DESCRIPTIVE}
names(pdata)
summary(pdata)
pdim(pdata)

###{r Variable}
X1 <- pdata$IPM
X2 <- pdata$AMH
X3 <- pdata$TPT
Y <- pdata$KEMISKINAN 


###{r COMMON EFFECT MODEL}
ce<-plm(Y ~ X1 + X2 + X3 , data = pdata, index =c("WILAYAH","TAHUN"), model = "pooling" )
ce


###{r FIXED EFFECT MODEL}
fe<-plm(Y ~ X1 + X2 + X3, data = pdata, index =c("WILAYAH","TAHUN"), model = "within" )
fe


###{r RANDOM EFFECT MODEL}
re<-plm(Y ~ X1 + X2 + X3, data = pdata, index =c("WILAYAH","TAHUN"), model = "random")
re


###{r CHOW TEST}
###If p-value < 0.05, then use FE.
chow<-pFtest(fe, ce)
chow
###FE


###{r HAUSMAN TEST}
###IF p-value < 0.05, then use FE. If p-value > 0.05, then use RE.
hausman<-phtest(re, fe)
hausman
###RE

###{r TWO WAY EFFECT}
###IF p-value < 0.05, then there's an effect
plmtest(re, effect="twoways", type="bp")


###{r INDIVIDUAL EFFECT}
###IF p-value < 0.05, then there's an effect
plmtest(re, effect="individual", type="bp")

###{r TIME EFFECT}
###IF p-value < 0.05, then there's an effect
plmtest(re, effect="time", type="bp")


### {SELECTED MODEL}
###the selected model is REM with individual effects
rem<-plm(Y ~ X1 + X2 + X3, data = pdata, index =c("WILAYAH"), model = "random")
summary(rem)


#{r MULTICOLLINEARITY}
###If coefficients correlations < 0.8 then there's no strong correlations between variable it means there is no multicollinearity
cor(pdata[c("IPM", "AMH", "TPT")], use = "complete.obs")

#{r}
###Also you can use VIF for multicollinearity, VIF < 10 it means there is no multicollinearity
vif(rem)

#{r HETEROSKEDASTICITY}
###If p-value of independent variable < 0.05, there is no heteroscedasticity
coeftest(rem, vcovHC)