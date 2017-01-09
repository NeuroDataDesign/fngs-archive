# Copyright 2016 Neurodata (http://openconnecto.me)
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
# fft2div.R
# Created by Eric Bridgeford on 2017-01-08.
# Email: ebridge2@jhu.edu
# Copyright (c) 2016. All rights reserved.
#
# a utility to convert timeseries to correlation matrices. 
# Inputs:
#   amp[[subs]][freq, rois]: the amplitude spectrum for each ROI.
#
# OUtputs:
#   div_mtx[[subs]][roi, rois]: the kullback-leibler divergence for each pair of rois.
#
amp2div <- function(amp) {
  sapply(amp, function(x) {
    nroi <- dim(x)[2]
    div_mtx <- array(NaN, dim=c(nroi, nroi))
    for (roi1 in 1:nroi) {
      for (roi2 in 1:nroi) {
        div_mtx[roi1, roi2] <- kl_div(x[,roi1], x[,roi2])
      }
    }
    return(div_mtx)
  }, USE.NAMES=TRUE, simplify=FALSE)
}

# compute the kullback-leibler divergence from 2 pairs of observations
# Inputs:
#   a[t]: the first set of observations.
#   b[t]: the second set of observations.
# Outputs:
#   div: the KL-divergence for a, b

kl_div <- function(a, b) {
  return(sum(a*log(a/b)))
}