# an example of a driver that loads timeseries data and produces
# a dataset wide distance estimation (along with mnr) and kde plot
# in a figure
#
# written by Eric Bridgeford

dirn <- dirname(parent.frame(2)$ofile)
dirn <- dirname(sys.frame(1)$ofile)
setwd(dirn)

## Sources ----------------------------------------------------------------------------------------

source('open_timeseries.R')
source('signal2zscore.R')
source('obs2corr.R')
require('ggplot2')
require('reshape2')
source('C:/Users/ebrid/Documents/GitHub/Reliability/Code/FlashRupdated/functions/distance.R')
source('C:/Users/ebrid/Documents/GitHub/Reliability/Code/FlashRupdated/functions/reliability.R')
source('C:/Users/ebrid/Documents/GitHub/Reliability/Code/FlashRupdated/functions/computerank.R')
source('C:/Users/ebrid/Documents/GitHub/Reliability/Code/R/processing/hell_dist.R')
source('C:/Users/ebrid/Documents/GitHub/Reliability/Code/R/processing/thresh_mnr.R')

## Loading Timeseries --------------------------------------------------------------------------------
gpath <- 'C:/Users/ebrid/Documents/GitHub/ugrad-data-design-team-0/data_processing/fngs_v1/rds_files/'
tsnames <- list.files(gpath, pattern="\\.rds", full.names=TRUE)

tsobj <- open_timeseries(tsnames, scan_pos=2)

ts <- tsobj[[1]]
sub <- tsobj[[2]]

zsc <- signal2zscore(ts)
corr <- obs2corr(zsc)

## Change Convention from preferred vara[[sub]][array] to vara[sub,array] for use with old code ---------
nroi <- dim(corr[["1"]])[1]
nscans <- length(corr)
wgraphs <- array(rep(NaN, nroi*nroi*nscans), c(nroi, nroi, nscans))

counter <- 1
for (subject in names(corr)) {
  wgraphs[,,counter] <- corr[[subject]]
  counter <- counter + 1
}

thresh_obj <- thresh_mnr(wgraphs, sub)

mnrthresh <- thresh_obj[[1]]
Dthresh <- thresh_obj[[2]]

ranked_graphs <- rank_matrices(wgraphs)
Drank <- distance(ranked_graphs)
mnrrank <- mnr(rdf(Drank, sub))

