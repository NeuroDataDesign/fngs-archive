# kalman_uni_em.R
# Created by Ewok on 2016-09-11
# Email: ewalke31@jhu.edu
# Copyright (c) 2016. All rights reserved. 
#
# An implementation of a univariate Expectation Maximization Kalman Filter algorithm.
#
# Inputs:
#   y[t]
#     - the observed data
#     - univariate, t timesteps
#   a, c, q, r, pi, v
#     - initial parameter values
#     - state transition, generative, state noise, output noise, state mean, covariance
#   max_i
#     - maximum number of iterations before cut-off
#     - default of 20
#   tol
#     - minimum difference between iterations before cut-off
#     - default of 0.01
#
# Outputs:
#   A, C, Q, R, Pi, V
#     - final parameter estimations
#     - equivalent to respectively named inputs
#   
kalman_uni_em <- function(y, a, c, q, r, pi, v, max_i=20, tol=0.01) {

  source('C:/Users/Eric/Documents/R/kalmansmoother.R')
  A <- a
  C <- c
  Q <- q
  R <- r
  Pi <- pi
  V <- v
  n <- length(y)  # number of timesteps
  i <- 1  # iteration
  diff <- 1  # difference between iterations
  Pt <- vector(, n)
  Ptt_1 <- vector(, n-1)
  
  while (i < max_i && diff > tol) {

    #  E Step:
    s <- kalmansmoother(A, 0, 0, C, Pi, V, y, Q, R)
    for (t in 1:n) {
      Pt[t] <- s$uncertainty[t]+s$state[t]*s$state[t]
      if (t != n) {
        Ptt_1[t] <- s$uncertainty[t]+s$state[t+1]*s$state[t]
      }
    }
    
    #  M Step:
    C_new <- sum(y*s$state) / sum(Pt)
    R_new <- (sum(y*y)-sum(C_new*s$state*y)) / n
    A_new <- sum(Ptt_1) / sum(Pt[1:n-1])
    Pi_new <- s$state[1]
    Q_new <- 1  # constraint
    V_new <- V  # constraint
    
    # updates
    diff <- abs(C_new-C)+abs(R_new-R)+abs(A_new-A)+abs(Q_new-Q)+abs(Pi_new-Pi)+abs(V_new-V)
    i <- i+1
    A <- A_new
    C <- C_new
    Q <- Q_new
    R <- R_new
    Pi <- Pi_new
    V <- V_new
  }
  return(list(A=A, C=C, Q=Q, R=R, Pi=Pi, V=V))
}