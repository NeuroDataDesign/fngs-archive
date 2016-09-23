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
# signal2zscore.R
# Created by Eric Bridgeford on 2016-11-07.
# Email: ebridge2@jhu.edu
# Copyright (c) 2016. All rights reserved.
#
# a utility to kalman filter a set of timeseries.
#
#
obs2kf <- function(observations) {
  require('dlm')

  dlm = dlm(FF=1, GG=1, V=0.8, W=0.1, m0=0, C0=1e7)
  
  kf_data <- sapply(names(observations),  function(x) {
    flt <- dlmFilter(observations[[x]], dlm)$m
    array(flt[2:length(flt)], dim=dim(observations[[x]]))
  }, simplify=FALSE, USE.NAMES=TRUE)
  
  return(kf_data)
}