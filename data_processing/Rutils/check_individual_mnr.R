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
source('obs2zsc.R')
source('obs2corr.R')
require('ggplot2')
require('reshape2')
require('Rmisc')
require('dlm')
source('C:/Users/ebrid/Documents/GitHub/Reliability/Code/FlashRupdated/functions/distance.R')
source('C:/Users/ebrid/Documents/GitHub/Reliability/Code/FlashRupdated/functions/reliability.R')
source('C:/Users/ebrid/Documents/GitHub/Reliability/Code/FlashRupdated/functions/computerank.R')
source('C:/Users/ebrid/Documents/GitHub/Reliability/Code/R/processing/hell_dist.R')
source('C:/Users/ebrid/Documents/GitHub/Reliability/Code/R/processing/thresh_mnr.R')
source('obs2kf.R')

#datasets <- c('NKI', 'BNU1', 'BNU2', 'HNU1', 'DC1')
datasets <- c('NKI', 'BNU1', 'BNU2')
outpath <- 'C:/Users/ebrid/Documents/GitHub/ugrad-data-design-team-0/reveal/images/week_822/'
#kfopts <- c('kf', 'no kf')
kfopts <- c('no kf')
scan_pos <- c(2, 3, 3, 3, 3)
inpath <- 'C:/Users/ebrid/Documents/R/FNGS_results/fngs_fnirt_v3/'

## Loading Timeseries --------------------------------------------------------------------------------

atlases <- c('desikan_2mm', 'Talairach_2mm')
for (at in atlases) {
  # dir.create(paste(outpath, at, "/", sep=""))
  for (dataset in datasets) {
    opath <- paste(outpath, dataset, "/", at, "/", sep="") 
    # dir.create(opath)
    tpath <- paste(inpath, dataset, "/", at, "/", sep="")
    tsnames <- list.files(tpath, pattern="\\.rds", full.names=TRUE)
    
    tsobj <- open_timeseries(tsnames, sub_pos=scan_pos[which(datasets == dataset)])
    
    ts <- tsobj[[1]]
    sub <- tsobj[[3]]
    
    maxmnr <- 0
    
    for (opt in kfopts) {
      if (isTRUE(all.equal(opt, 'kf'))) {
        kf <- obs2kf(ts)
        #zsc <- signal2zscore(ts)
        corr <- obs2corr(kf)
  
      } else {
        #zsc <- signal2zscore(ts)
        corr <- obs2corr(ts)
      }
      
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
      
      thresh_obj <- thresh_mnr(wgraphs, sub, N = 25)
      
      mnrthresh <- thresh_obj[[1]]
      Dthresh <- thresh_obj[[2]]
      mnrthresh <- 0
      
      ranked_graphs <- rank_matrices(wgraphs)
      Drank <- distance(ranked_graphs)
      mnrrank <- mnr(rdf(Drank, sub))
      
      Draw <- distance(wgraphs)
      mnrraw <- mnr(rdf(Draw, sub))
      
      optmax_mnr <- max(c(mnrraw, mnrrank, mnrthresh))
      if (isTRUE(optmax_mnr > maxmnr)) {
        maxmnr <- optmax_mnr
        kfo <- opt
        if (isTRUE(all.equal(maxmnr, mnrraw))) {
          Dmax <- Draw
          winner <- 'raw'
        } else if (isTRUE(all.equal(maxmnr, mnrrank))) {
          Dmax <- Drank
          winner <- 'rank'
        } else {
          Dmax <- Dthresh
          winner <- 'thresh'
        }    
      }
    }
    
    ## Produce Plots for MNR --------------------------------------------------------
    
    kdeobj <- hell_dist(Dmax, sub)
    kde_dist <- data.frame(kdeobj[[1]]$y, kdeobj[[2]]$y, kdeobj[[1]]$x)
    colnames(kde_dist) <- c("intra", "inter", "Graph Distance")
    meltkde <- melt(kde_dist, id="Graph Distance")
    colnames(meltkde) <- c("Graph Distance", "Relationship", "Probability")
    
    
    distance_title <- sprintf('MNR = %.4f, best = %s, %s', maxmnr, winner, kfo)
    distance_plot <- ggplot(melt(Dmax), aes(x=Var1, y=Var2, fill=value)) + 
      geom_tile() +
      scale_fill_gradientn(colours=c("darkblue","blue","purple","green","yellow"),name="distance") +
      xlab("Scan") + ylab("Scan") + ggtitle(distance_title) +
      theme(text=element_text(size=20))
    
    kde_plot <- ggplot()+geom_ribbon(data=meltkde, aes(x=`Graph Distance`, ymax=Probability, fill=Relationship), ymin=0, alpha=0.5) +
      ggtitle("Subject Relationships") + theme(text=element_text(size=20))
    
    png(paste(outpath, dataset, "_", kfopts, "_", at, ".png", sep=""), height=600, width = 1200)
    multiplot(distance_plot, kde_plot, layout=matrix(c(1,2), nrow=1, byrow=TRUE))
    dev.off()
  }
}