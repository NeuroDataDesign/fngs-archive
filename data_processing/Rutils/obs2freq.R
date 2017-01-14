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
# obs2freq.R
# Created by Eric Bridgeford on 2017-01-08.
# Email: ebridge2@jhu.edu
# Copyright (c) 2016. All rights reserved.
#
# a utility to convert timeseries to amplitude spectra. 
# Inputs:
#   observations[[subs]][timesteps, rois]: a list of observations 
#                 for a particular subject.
#   tr: the repetition time, in seconds, of each slice.
#   lc: the low cutoff frequency, in Hz, to ignore below.
#     frequencies below this cutoff are considered low-frequency
#     noise. Defaults to the standard 0.01 Hz for fMRI.
#
# OUtputs:
#   amp_data[[subs]][timesteps, rois]: the amplitude spectrum of the data. 
#
obs2amp <- function(observations, tr=NaN, lc=0.01, normalize=TRUE) {
  amp_data <- sapply(observations,  function(x) {
    amp_sig <- highpass_fft(x, tr=tr, lc=lc)
    amp_sig <- 2*amp_sig
    # normalized
    if (normalize) {
      amp_sig <- amp_sig %*% diag(1/apply(X=amp_sig, MARGIN=2, FUN=sum))
    }
    return(amp_sig)
  }, simplify=FALSE, USE.NAMES=TRUE)
  
  return(amp_data)
}
# a utility to convert timeseries to power spectra. 
# Inputs:
#   observations[[subs]][timesteps, rois]: a list of observations 
#                 for a particular subject.
#   tr: the repetition time, in seconds, of each slice.
#   lc: the low cutoff frequency, in Hz, to ignore below.
#     frequencies below this cutoff are considered low-frequency
#     noise. Defaults to the standard 0.01 Hz for fMRI.
#
# OUtputs:
#   amp_data[[subs]][timesteps, rois]: the amplitude spectrum of the data. 
#
obs2pow <- function(observations, tr=NaN, lc=0.01, normalize=TRUE) {
  pow_data <- sapply(observations,  function(x) {
    pow_sig <- highpass_fft(x, tr=tr, lc=lc)
    # one sided
    pow_sig <- pow_sig^2
    # normalized
    if (normalize) {
      pow_sig <- pow_sig %*% diag(1/apply(X=pow_sig, MARGIN=2, FUN=sum))
    }
    return(pow_sig)
  }, simplify=FALSE, USE.NAMES=TRUE)
  
  return(pow_data)
}

# highpass FFT for data
#
# Inputs:
#   Signal: the signal to fft.
#   tr: the repetition time, in seconds, of each slice.
#   lc: the low cutoff frequency, in Hz, to ignore below.
#     frequencies below this cutoff are considered low-frequency
#     noise. Defaults to the standard 0.01 Hz for fMRI.
#
highpass_fft <- function(signal, tr=NaN, lc=NaN) {
  nt <- dim(signal)[1]
  x <- apply(X=signal, MARGIN=c(2), FUN=fft)/nt
  if (!is.nan(tr) && !is.nan(lc)) {
    fs <- 1/tr  # the sampling frequency
    freq <- fs*seq(from=0, to=ceiling(nt/2)-1)/nt
    x[freq < lc] <- 0
  }
  x <- Re(abs(x))
  return(x[1:ceiling(nt/2),,drop=FALSE])
}