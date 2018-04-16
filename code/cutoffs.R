cutoffs <- function(data,splitvar,cutpoint,y,func="mean") {
  u <- list(ifelse(data[,splitvar] <= cutpoint,1,0))
  less <- aggregate(data[,y],by=u,func)[2,2]
  more <- aggregate(data[,y],by=u,func)[1,2]
  output <- c(less,more)
  output
}
