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
#   div[[subs]][roi, rois]: the kullback-leibler divergence for each pair of rois.
#
# Outputs:
#   dist[nsub, nsub]: the hellinger distance between each pair of subjects.

div2dist <- function(div) {
  nsub <- length(div)
  dist <- array(NaN, dim=c(nsub, nsub))
  for (sub1 in 1:nsub) {
    for (sub2 in 1:nsub) {
      dist[sub1, sub2] <- hell_dist(div[[sub1]], div[[sub2]])
    }
  }
  return(dist)
}

hell_dist <- function(a, b) {
  1/sqrt(2)*norm(sqrt(a) - sqrt(b), "f")
}