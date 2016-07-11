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
require('Rmisc')
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

## Compute MNR ----------------------------------------------------------------

thresh_obj <- thresh_mnr(wgraphs, sub)

mnrthresh <- thresh_obj[[1]]
Dthresh <- thresh_obj[[2]]

ranked_graphs <- rank_matrices(wgraphs)
Drank <- distance(ranked_graphs)
mnrrank <- mnr(rdf(Drank, sub))

if (mnrthresh > mnrrank) {
  maxmnr <- mnrthresh
  Dmax <- Dthresh
  winner <- 'thresh'
} else {
  maxmnr <- mnrrank
  Dmax <- Drank
  winner <- 'rank'
}

## Produce Plots for MNR --------------------------------------------------------

kdeobj <- hell_dist(Dmax, sub)
kde_dist <- data.frame(kdeobj[[1]]$y, kdeobj[[2]]$y, kdeobj[[1]]$x)
colnames(kde_dist) <- c("intra", "inter", "Graph Distance")
meltkde <- melt(kde_dist, id="Graph Distance")
colnames(meltkde) <- c("Graph Distance", "Relationship", "Probability")

distance_plot <- ggplot(melt(Dmax), aes(x=Var1, y=Var2, fill=value)) + 
  geom_tile(color="white") +
  scale_fill_gradientn(colours=c("darkblue","blue","purple","green","yellow"),name="distance") +
  xlab("Scan") + ylab("Scan") + ggtitle(sprintf('MNR = %.4f, best = %s', maxmnr, winner)) +
  theme(text=element_text(size=20))

kde_plot <- ggplot()+geom_ribbon(data=meltkde, aes(x=`Graph Distance`, ymax=Probability, fill=Relationship), ymin=0, alpha=0.5) +
  ggtitle("Intra and Inter Subject Relationships") + theme(text=element_text(size=20))

multiplot(distance_plot, kde_plot, layout=matrix(c(1,2), nrow=1, byrow=TRUE))