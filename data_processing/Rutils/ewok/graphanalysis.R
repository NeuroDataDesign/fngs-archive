graphanalysis <- function() {
  
  require(ggplot2)
  require(reshape2)
  source('C:/Users/Eric/Documents/Github/fngs/data_processing/Rutils/open_timeseries.R')
  source('C:/Users/Eric/Documents/GitHub/Reliability/Code/FlashRupdated/functions/distance.R')
  source('C:/Users/Eric/Documents/GitHub/Reliability/Code/FlashRupdated/functions/reliability.R')
  source('C:/Users/Eric/Documents/GitHub/Reliability/Code/R/processing/hell_dist.R')
  source('C:/Users/Eric/Documents/GitHub/Reliability/Code/R/processing/thresh_mnr.R')
  source('C:/Users/Eric/Documents/R/arplotter.R')
  source('C:/Users/Eric/Documents/R/arfull.R')
  source('C:/Users/Eric/Documents/R/kalman.R')
  source('C:/Users/Eric/Documents/R/prod_pkde.R')
  source('C:/Users/Eric/Documents/R/torank.R')
  source('C:/Users/Eric/Documents/R/multiplot.R')
  
  
  fnames = list.files('R/rds_files/', pattern="\\.rds", full.names=TRUE)
  parsed = open_timeseries(fnames, scan_pos=2)
  ids = parsed[[2]]
  parsed = parsed[[1]]
  wgraphs = array(dim=c(899, 70, 34))
  for(i in 1:34) {wgraphs[,,i] <- t(parsed[[i]][1:70, 1:899])}
  
  
  wgraphs850 = array(dim=c(850,70,34)) # first 850 used for training
  for(i in 1:34) {wgraphs850[,,i] <- wgraphs[1:850,,i]}
  wgraphs49 = array(dim=c(49,70,34))   # last 49 used to test against predictions
  for(i in 1:34) {wgraphs49[,,i] <- wgraphs[851:899,,i]}
  
  
  R2_1 = arfull(1, wgraphs850, wgraphs49) #produces prediction plots & outputs R^2 values
  
  kfgraphs = kalman(wgraphs) #produces kalman filtered graphs
  
  # example for producing correlation graphs
  corr_kf = array(dim=c(70, 70, 34))
  for (i in 1:34) {corr_kf[,,i] = cor(kfgraphs[,,i])}
  distc_kf = distance(corr_kf)
  mc_kf = mnr(rdf(distc_kf, ids))
  pdistc_kf <- ggplot(melt(distc_kf), aes(x=Var2, y=Var1, fill=value)) + geom_tile(color="white") +
    scale_fill_gradientn(colours=c("darkblue","blue","purple","green","yellow"),name="distance") + ggtitle("mnr = 0.9492188")
  pkdec_kf = prod_pkde(distc_kf, ids)
  multiplot(pdistc_kf, pkdec_kf, cols=2)
  
  # example for producing AR graphs
  ARarray1_kf = array(dim=c(70, 70, 34))
  for (i in 1:34) {corr_kf[,,i] = ar(kfgraphs[,,i], aic=FALSE, order.max = 1)[[2]]}
  dist1_kf = distance(ARarray1_kf)
  m1_kf = mnr(rdf(dist1_kf, ids))
  pdist1_kf <- ggplot(melt(dist1_kf), aes(x=Var2, y=Var1, fill=value)) + geom_tile(color="white") +
    scale_fill_gradientn(colours=c("darkblue","blue","purple","green","yellow"),name="distance") + ggtitle("mnr = 0.7929688")
  pkde1_kf = prod_pkde(dist1_kf, ids)
  multiplot(pdist1_kf, pkde1_kf, cols=2)
  
}