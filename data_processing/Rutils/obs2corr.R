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
# a utility to convert timeseries to correlation matrices. 
#
#
obs2corr <- function(observations) {

  corr_data <- sapply(names(observations),  function(x) abs(cor(observations[[x]])),
                      simplify=FALSE, USE.NAMES=TRUE)
  
  return(corr_data)
}