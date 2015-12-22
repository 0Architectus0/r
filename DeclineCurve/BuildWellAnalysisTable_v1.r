library("stringi", lib.loc = "/Library/Frameworks/R.framework/Versions/3.2/Resources/library")
library("stringr", lib.loc = "/Library/Frameworks/R.framework/Versions/3.2/Resources/library")
library("aRpsDCA", lib.loc = "/Library/Frameworks/R.framework/Versions/3.2/Resources/library")

# Test Vars ---------------------------------------------------------------
resultdf <- read.csv("/Users/Vincent/Library/Mobile Documents/com~apple~CloudDocs/DEV/R/DeclineCurve/data/MonthlyProductionData v0.1.csv", encoding="UTF-8")
resultdf$API <- format(resultdf$API, scientific = F)
resultdf <- data.frame(list(as.character(resultdf$API), resultdf$CalcMonthInProd, resultdf$CalcGas))

# Prod --------------------------------------------------------------------
#dataList <- list(inpVal1, inpVal2, inpVal3)
#resultdf <- data.frame(dataList)

#TEST ---------------------------------------------------------------------
colnames(resultdf) <- c("API", "CalcMonth", "CalcGas")

#why aggregate here? should only be 1 calcgas per month per api
dfAgg1 <- aggregate(resultdf$CalcGas, by=list(resultdf$API, resultdf$CalcMonth), FUN=sum)
colnames(dfAgg1) <- c("API", "CalcMonth", "CalcGas")

dfAggMean <- aggregate(resultdf$CalcGas, by=list(resultdf$API, resultdf$CalcMonth), FUN=mean)
colnames(dfAggMean) <- c("API", "CalcMonth", "CalcGas")

# Build year 1 max value.
dfYr1 <- subset(dfAgg1, CalcMonth < 13)
colnames(dfYr1) <- c("API", "CalcMonth", "CalcGas")

dfYr1Max <- data.frame()
dfYr1Max <- rbind(dfYr1Max, aggregate(dfYr1$CalcGas, by=list(dfYr1$API), FUN=max))
colnames(dfYr1Max) <- c("API", "CalcGasYr1") 

# Build year 2 max value
dfYr2 <- subset(dfAgg1, CalcMonth > 12)
colnames(dfYr2) <- c("API", "CalcMonth", "CalcGas")

dfYr2Max <- aggregate(dfYr2$CalcGas, by=list(dfYr2$API), FUN=max)
colnames(dfYr2Max) <- c("API", "CalcGasYr2")

#dfYr1==agg1
#agg2==dfyr1Max

#create table for EUR
agg3 <- data.frame()
wellEUR <- data.frame(character(), character(), numeric(), character())
probAPI <- data.frame()

#populate EUR table
for(i in 1:nrow(dfYr1Max)) {
  agg3 <- subset(dfAggMean, dfYr1Max[i,]$API == API)
  colnames(agg3) <- c("API", "CalcMonth", "CalcGas") 
  
  
  #function to handle prob API rows
  handleProbAPI <- function(x) {
    probRow <- data.frame(format(agg3$API, scientific = FALSE), length(agg3$CalcMonth))
    probAPI <- rbind(probAPI, probRow)
  }
    
  # Get best fit. 
  #handle API's with less than three wells
  if(length(agg3$CalcMonth)<3){
    
    #dl <- list(as.character(format(agg3$API, scientific = FALSE)), "not valid", NULL, as.character(length(agg3$CalcMonth)))
    wellEURRow <- data.frame(as.character(format(agg3$API, scientific = FALSE)), "not valid", 0, as.character(length(agg3$CalcMonth)))
    colnames(wellEURRow) <- c("API", "hyp2expFitVal", "EUR", "CountProdMonths")
    colnames(wellEUR) <- colnames(wellEURRow)
    wellEUR <- rbind(wellEUR, wellEURRow)
    
    next
  }
  
  #reset var
  hyp2expFitVal <- list( "Not Valid", NULL )
  
  fitme.hyp2exp.t <- agg3[[2]]
  fitme.hyp2exp.q <- agg3[[3]]
  try( hyp2expFitVal <- best.hyp2exp( fitme.hyp2exp.q, fitme.hyp2exp.t ))#,  finally = hyp2expFitVal <-ist( "Not", NULL ))
  #e <- simpleError("test error")
  
  commaLoc1 <- regexpr(",",toString(hyp2expFitVal[1]))[1] + 5  
  commaLoc2 <- regexpr(",",substr(toString(hyp2expFitVal[1]), commaLoc1 + 1, 100000))[1] + commaLoc1 + 4
  commaLoc3 <- regexpr(",",substr(toString(hyp2expFitVal[1]), commaLoc2 + 1, 100000))[1] + commaLoc2 + 5
  endOfLine <- regexpr(")",toString(hyp2expFitVal[1]))[1]  
  
  qi <- as.numeric( substr( toString( hyp2expFitVal[1] ), 11, commaLoc1 - 6 ) )
  di <- as.numeric( substr( toString( hyp2expFitVal[1] ), commaLoc1 + 1, commaLoc2 - 5 ) )
  bfactor <- as.numeric( substr( toString( hyp2expFitVal[1] ), commaLoc2 + 1, commaLoc3 - 6 ) )
  df <- as.numeric( substr( toString( hyp2expFitVal [1] ), commaLoc3 + 1, endOfLine - 1 ) ) 
  
  try( decline <- arps.decline( qi, di, bfactor, df ) )
  EUR <-0
  try( EUR <- arps.eur( decline, 24 ) ) 
  dl <- list(as.character(dfYr1Max[i,]$API), toString(hyp2expFitVal[1]), EUR[1], toString(length(agg3$CalcMonth)))
  wellEURRow <- data.frame(dl)
  colnames(wellEURRow) <- c("API", "hyp2expFitVal", "EUR", "CountProdMonths")
  colnames(wellEUR) <- c("API", "hyp2expFitVal", "EUR", "CountProdMonths")
  wellEUR <- rbind(wellEUR, wellEURRow)
} 

# Merge year one and two together.
dfWellMaxTable <- merge(x=dfYr1Max, y=dfYr2Max, "API")
# Merge Max and EUR tables
dfWellAnalysisTable <- merge(x=dfWellMaxTable, y=wellEUR, "API")

colnames(dfWellAnalysisTable) <- c("API", "Yr1MaxCalcGas", "Yr2MaxCalcGas", "hyp2expFitVal", "EUR", "CountProdMonths")