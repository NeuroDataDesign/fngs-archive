# an example of a driver that loads timeseries data and produces
# a dataset wide distance estimation (along with mnr) and kde plot
# in a figure
#
# written by Eric Bridgeford
#
# structure of directories for proper analysis
#
# Options:
#   inpath: line 68; the path to the base where timeseries are
#   outpath: the path where output images will go
#   scan_pos: the position of the subject id in the name,
#             of the timeseries file. Example:
#               KKI_sub-0025964_session-1_output.RDS (all timeseries following this
#                                                     convention for a dataset)
#               - scan_pos for this dataset is 3
#   datasets: a list, 1:1 with the scan_pos (each dataset has a position that the
#                                            subject id will be)
#   atlases: the atlases to consider. should be a string of the names of each atlas.
#
# Example directory structure:
# basedir
#   |
#   dataset1
#   |  |
#   |  atlas1
#   |  |   | dataset1_sub-12398_...RDS
#   |  |   |  ...
#   |  atlas2
#   |  |   | dataset1_sub-12398_...RDS
#   |  |   |  ...
#   dataset2
#   |  |
#   |  atlas1
#   |  |   | dataset2_sub-12398_...RDS
#   |  |   |  ...
#   |  atlas2
#   |  |   | dataset2_sub-12398_...RDS
#   |  |   |  ...
#   ...
#   
#   Then our inputs would be structured as:
# inpath <- 'basedir'
# outpath <- '/your/outpath'
# scan_pos <- c(3,3) # note we assume _ and - delimiters
# datasets <- c('dataset1', 'dataset2')
# atlases <- c('atlas1', 'atlas2')

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
source('C:/Users/ebrid/Documents/GitHub/Reliability/Code/R/processing/kde_subject.R')
source('C:/Users/ebrid/Documents/GitHub/Reliability/Code/R/processing/thresh_mnr.R')

datasets <- c('BNU1')
outpath <- 'C:/Users/ebrid/Documents/GitHub/ugrad-data-design-team-0/reveal/images/week_913/'
scan_pos <- c(3)
inpath <- 'C:/Users/ebrid/Documents/R/FNGS_results/fngs_fnirt_v3/'
atlases <- c('desikan_2mm')

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
    
    corr <- obs2corr(ts)
    
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
    
    ## Produce Plots for discr ------------------------------------------------------
    
    kdeobj <- kde_subject(Dmax, sub)
    kde_dist <- data.frame(kdeobj[[1]]$y, kdeobj[[2]]$y, kdeobj[[1]]$x)
    colnames(kde_dist) <- c("intra", "inter", "Graph Distance")
    meltkde <- melt(kde_dist, id="Graph Distance")
    colnames(meltkde) <- c("Graph Distance", "Relationship", "Probability")
    
    
    distance_title <- sprintf('MNR = %.4f, best = %s', maxmnr, winner)
    distance_plot <- ggplot(melt(Dmax), aes(x=Var1, y=Var2, fill=value)) + 
      geom_tile() +
      scale_fill_gradientn(colours=c("darkblue","blue","purple","green","yellow"),name="distance") +
      xlab("Scan") + ylab("Scan") + ggtitle(distance_title) +
      theme(text=element_text(size=20))
    
    kde_plot <- ggplot()+geom_ribbon(data=meltkde, aes(x=`Graph Distance`, ymax=Probability, fill=Relationship), ymin=0, alpha=0.5) +
      ggtitle("Subject Relationships") + theme(text=element_text(size=20))
    
    png(paste(outpath, dataset, "_", at, ".png", sep=""), height=600, width = 1200)
    multiplot(distance_plot, kde_plot, layout=matrix(c(1,2), nrow=1, byrow=TRUE))
    dev.off()
  }
}