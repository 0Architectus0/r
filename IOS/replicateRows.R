library("zoo", lib.loc="~/R/win-library/3.2")
library("timeDate", lib.loc="~/R/win-library/3.2")

Extcoating <- read.csv("Data/ExternalCoating.csv", header = T)
#subset to get single row per coating
BegExtCoating <- Extcoating[Extcoating$Begin.and.End == 'BEG_MEAS',]

#rowNum <- 1

pipeSet <- data.frame()

#append ft increment rows per coating/row dim(BegExtCoating)[1]
 for( rowNum in 1:2){
     #coatSet <- data.frame()
     #for (j in 0:(BegExtCoating$EVENT_LENGTH[i]-1)){
       #copy original row
       #orow <- BegExtCoating[i,c(1:9)]
       
       #replicate beginning row for foot unit length of pipe 
        #test <- BegExtCoating[rep(row.names(BegExtCoating), BegExtCoating$EVENT_LENGTH), 1:2 ]
        #test <- BegExtCoating[rep(BegExtCoating[2,], BegExtCoating$EVENT_LENGTH[2]), 1:5 ]
       
       #test1 <- data.frame(lineNum = BegExtCoating[,1], DesigNum = BegExtCoating[,2], descrip = as.character(BegExtCoating[,3]), stringsAsFactors = F)
       test1 <- data.frame(lineNum = BegExtCoating[,1], DesigNum = BegExtCoating[,2], descrip = BegExtCoating[,3], stringsAsFactors = F)
       
       test2 <- rep(test1[rowNum, c(1:3)], 3)
       test3 <- unlist(test2)
       test4 <- matrix(test3, byrow = T) 
       test5 <- data.frame(test4)
       
       string
       
       
       test6 <- data.frame(matrix(unlist(test2, use.names = T), nrow = 3, byrow = T), stringsAsFactors = F)
     #replace with i 
       testA <- rep(BegExtCoating[rowNum,c(1,3)], BegExtCoating$EVENT_LENGTH[rowNum]+1)
       
       #testA[1]
       
       testA
       poo <- unlist(testA, use.names =TRUE) 
       #testA[1[1]:36[1]]
       
       testB <- unlist(testA)
       
       df <- data.frame(matrix(unlist(testA, use.names = T), nrow = BegExtCoating$EVENT_LENGTH[rowNum]+1, byrow = T), stringsAsFactors = F)
       
       unl <- unlist(testA, recursive = T, use.names = T)
       
       colnames(df)<- c(names(testA[1:36]))
       
       mid <- c(df$BEG_STN[1]:df$END_STN[1] )
       
       coatSet <- cbind(df, mid)
       
       
       #replace begining and ending values
        #orow$BEG_STN <- BegExtCoating[i,]$BEG_STN + (j)
       
        #orow$END_STN <- orow$BEG_STN+1 

       #replace length?
        #orow$EVENT_LENGTH <-  1
       
       #
       #orow$Begin.and.End <- "Coating Segment"
       
       #coating event data set 
       #coatSet <- rbind(coatSet, orow)
     #}
    pipeSet <- rbind(pipeSet, coatSet)
    }
   