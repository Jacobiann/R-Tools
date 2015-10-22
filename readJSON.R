library(rjson)
#read data
needFile <- "C:\\Users\\s3553\\Desktop\\car.json"
json <- scan(needFile ,what = "character" , sep = "\n")
title <- function(x) fromJSON(x) [c("air","documentId")]
data <- lapply(json,title)
#convert to dataframe
df <- data.frame(matrix(unlist(data), nrow=length(data), byrow=T))
colnames(df) <- c("air","documentId")
