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
#   fnames[subs]: the filenames
#   **NOTE** we assume that all dataset, scan, and run info is separated in the
#   filename by underscores. IE, dataset_subject_run_(other information).rds
#   dataset[1]: the positiohn of the dataset id in the filenames
#   scan_pos[1]: the position of the subject id in the filenames
#   run_pos[1]: the position of the run information in the filenames
# Outputs:
#   ts[[subs]][timesteps, rois]: the ts loaded from the specified file names
#   dataset[subs]: the dataset ids
#   subjects[subs]: the subject ids
#   runs[subs]: the run ids
#

open_timeseries <- function(fnames, dataset_pos=1, sub_pos=2, run_pos =3) {
  print("opening timeseries...")
  subjects <- vector("character", length(fnames))
  dataset <- vector("character", length(fnames))
  runs <- vector("character", length(fnames))
  numscans<-length(fnames)
  ts <- list()
  counter <- 0
  for (i in 1:length(fnames)) {
    tts <- readRDS(fnames[i]) # read the timeseries from the filename
    basename <- basename(fnames[i])     # the base name of the file
    base_split <- strsplit(basename, "\\.|-|_") # parse out the subject, which will be after the study name
    name <- unlist(base_split)
    dataset[i] <- name[dataset_pos]

    tts[is.nan(tts)] <- 0
    if (!any(apply(tts, MARGIN=1, function(x) sum(abs(x))) == 0)) {
      counter <- counter + 1
      ts[[counter]] <-t(tts)
      subjects[counter] <- name[sub_pos] # subject name must be a string, so do not convert to numeric
      runs[counter] <- name[run_pos]
    }
  }
  pack <- list(ts=ts, dataset=dataset, subjects=subjects[1:counter], runs=runs[1:counter])# pack up the dataset, subject, and run ids witht the timeseries
  return(pack)
}

