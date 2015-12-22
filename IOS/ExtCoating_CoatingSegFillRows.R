#read data set
Extcoating <- read.csv("Data/ExternalCoating.csv", header = T)


#funtion parameters beg_meas

#subset to get single row per coating
BegExtCoating <- Extcoating[Extcoating$Begin.and.End == 'BEG_MEAS',]


#intialize variables

pipeSet <- data.frame()

# 1st attempt -------------------------------------------------------------


#append ft increment rows per coating/row dim(BegExtCoating)[1]
# for( i in 1:dim(BegExtCoating)[1]){
#   coatSet <- data.frame()
#   for (j in 0:(BegExtCoating$EVENT_LENGTH[i]-1)){
#     #copy original row
#     orow <- BegExtCoating[i,c(1:9)]
#     
#     #replace begining and ending values
#     orow$BEG_STN <- BegExtCoating[i,]$BEG_STN + (j)
#     orow$END_STN <- orow$BEG_STN+1 
#     
#     #replace length?
#     #orow$EVENT_LENGTH <-  1
#     
#     #
#     #orow$Begin.and.End <- "Coating Segment"
#     
#     #coating event data set 
#     coatSet <- rbind(coatSet, orow)
#   }
#   pipeSet <- rbind(pipeSet,BegExtCoating[i,], coatSet, Extcoating[i+1,])
# }

# 2nd try -----------------------------------------------------------------
#append ft increment rows per coating/row dim(BegExtCoating)[1]
for( i in 2){
  coatSet <- data.frame()
  orow <- BegExtCoating[i,]
  
  for (j in 0:(BegExtCoating$EVENT_LENGTH[i]-1)){
    #copy original row
   #coating event data set 
    
    coatSet <- rbind(coatSet, orow)
    
    #replace begining and ending values
    #orow$BEG_STN <- BegExtCoating[i,]$BEG_STN + (j)
    #orow$END_STN <- orow$BEG_STN+1 
    
    #replace length?
    #orow$EVENT_LENGTH <-  1
    
    #
    #orow$Begin.and.End <- "Coating Segment"
    
  }
  seg_start <- BegExtCoating$EVENT_LENGTH[i]
  coatSet <- cbind(coatSet, seg_start, seg_end)
  pipeSet <- rbind(pipeSet,BegExtCoating[i,], coatSet, Extcoating[i+1,])
}
