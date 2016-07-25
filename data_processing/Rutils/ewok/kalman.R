kalman <- function(obs) {
  
  filtered = vector("list", 34)
  kfgraphs = array(dim=c(899, 70, 34))
  dlm = dlm(FF=1, GG=1, V=0.8, W=0.1, m0=0, C0=1e7)
  for (i in 1:34) {
    filtered[[i]] = dlmFilter(obs[,,i], dlm)
    kfgraphs[,,i] = filtered[[i]][3][[1]][2:62931]
  }
  return(kfgraphs)
}