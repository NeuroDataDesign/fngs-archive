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
# obs2fft.R
# Created by Eric Bridgeford on 2017-01-08.
# Email: ebridge2@jhu.edu
# Copyright (c) 2016. All rights reserved.
#
# a utility to convert timeseries to correlation matrices. 
# Inputs:
#   observations[[subs]][timesteps, rois]: a list of observations 
#                 for a particular subject.
#
# OUtputs:
#   amp_data[[subs]][timesteps, rois]: the amplitude spectrum of the data. 
#
obs2amp <- function(observations, normalize=TRUE) {
  
  amp_data <- sapply(observations,  function(x) {
    nt <- dim(x)[1]
    amp_sig <- apply(X=x, MARGIN=c(2), FUN=fft)/nt
    # one sided
    amp_sig <- 2*abs(amp_sig[1:ceiling(nt/2),,drop=FALSE])
    # normalized
    if (normalize) {
      amp_sig <- amp_sig %*% diag(1/apply(X=amp_sig, MARGIN=2, FUN=sum))
    }
    return(amp_sig)
  }, simplify=FALSE, USE.NAMES=TRUE)
  
  return(amp_data)
}