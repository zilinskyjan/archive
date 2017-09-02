sumTable <- function(var1, lab, tabname) {
  nonmissing <- which(!is.na(var1))
  Min <- summary(var1)[["Min."]]
  Mean <- summary(var1)[["Mean"]]
  Max <- summary(var1)[["Max."]]
  N <-sum(!is.na(var1)) # this adds TRUEs
  SD <- sd(var1[nonmissing])
  tibstats <- tibble(Mean,SD,Min,Max,N)
  tibstats <- round(tibstats,1)
  tib <- add_column(Variable=lab,tibstats, .before = 1)
  assign(tabname, tib, envir = .GlobalEnv)
}


