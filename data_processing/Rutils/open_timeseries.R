# Copyright 2014 Open Connectome Project (http://openconnecto.me)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#
# open_timeseries.R
# Created by Eric Bridgeford on 2016-11-07.
# Email: ebridge2@jhu.edu
# Copyright (c) 2016. All rights reserved.
#
#a function for opening the graph data
# Input:
#   fnames[nx1]: the filenames
#   scan_pos[1]: the position of the subject id in the filenames, separated by _ characters
# Outputs:
#   ts[[kxkxn]][n]][kxt]: the ts loaded from the specified file names
#   subjects[nx1]: the subject ids
#
open_timeseries <- function(fnames, scan_pos=2) {
  print("opening timeseries...")
  subjects <- c()
  numscans<-length(fnames)
  ts <- list()
  for (i in 1:numscans) { # most of the preprocessing now done in python instead
    print(i)
    tts <- readRDS(fnames[i]) # read the graph from the filename
    basename <- basename(fnames[i])     # the base name of the file
    base_split <- strsplit(basename, "_") # parse out the subject, which will be after the study name
    subjects[i] <- unlist(base_split)[scan_pos] # subject name must be a string, so do not convert to numeric
    tts[is.nan(tts)] <- 0
    ts[[i]] <-tts
  }
  pack <- list(ts, subjects)# pack up the subject ids and the graphs
  return(pack)
}

