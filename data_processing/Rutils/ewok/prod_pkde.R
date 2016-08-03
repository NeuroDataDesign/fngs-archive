prod_pkde <- function (dist, ids) {

  require(ggplot2)
  require(reshape2)
  source('C:/Users/Eric/Documents/GitHub/Reliability/Code/R/processing/hell_dist.R')
  hd = hell_dist(dist, ids)
  kde = data.frame(hd[[1]]$y, hd[[2]]$y, hd[[1]]$x)
  colnames(kde) = c("intra", "inter", "dist")
  meltkde = melt(kde, id='dist')
  pkde = ggplot() + geom_ribbon(data = meltkde, aes(x = dist, ymax = value, fill= variable, ymin=0), alpha=0.5)
  return(pkde)
}