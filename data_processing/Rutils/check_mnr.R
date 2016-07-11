# an example of a driver that loads timeseries data and produces
# a dataset wide distance estimation (along with mnr) and kde plot
# in a figure
#
# written by Eric Bridgeford

dirn <- dirname(parent.frame(2)$ofile)
dirn <- dirname(sys.frame(1)$ofile)
setwd(dirn)

## Sources ------------------------

source('open_timeseries.R')
source('signal2zscore.R')
require('ggplot2')
require('reshape2')
## Loading Timeseries ----------------
gpath <- 'C:/Users/ebrid/Documents/GitHub/ugrad-data-design-team-0/data_processing/fngs_v1/rds_files/'
tsnames <- list.files(gpath, pattern="\\.rds", full.names=TRUE)

tsobj <- open_timeseries(tsnames, scan_pos=2)

ts <- tsobj[[1]]
sub <- tsobj[[2]]

cor <- signal2zscore(ts)