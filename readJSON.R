library(rjson)
needFile <- "C:\\Users\\s3553\\Desktop\\car.json"
json <- scan(needFile ,what = "character" , sep = "\n")
title <- function(x) fromJSON(x) [c("air","documentId")]
data <- lapply(json,title)
df <- data.frame(matrix(unlist(data), nrow=length(data), byrow=T))
colnames(df) <- c("air","documentId")
