torank <- function(lnumeric) {
  
  lnumeric = rank(lnumeric)
  ar = array(dim=c(70,70,34)) ##adjust 34 to 68 for AR(2)
  for (i in 1:34) {           ##adjust 34 to 68 for AR(2)
    for (j in 1:70) {
      for (k in 1:70) {
        ar[k,j,i] = lnumeric[(i-1)*4900+(j-1)*70+k]
      }
    }
  }
  return(ar)
  
  
  
}