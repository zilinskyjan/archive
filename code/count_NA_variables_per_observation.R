A <- data.frame(V1=c(1,2,3),
                V2=c(NA,NA,0),
                V3=c(0,0,0),
                V4=c(NA,2,3))

A$howmanymissing <- 0

for (obs in 1:nrow(A)) {
  A[obs,"howmanymissing"] <- is.na(A[obs,]) %>% sum()
}