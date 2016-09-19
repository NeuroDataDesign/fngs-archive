# kalman_em.R
# Created by Ewok on 2016-09-17
# Email: ewalke31@jhu.edu
# Copyright (c) 2016. All rights reserved. 
#
# An implementation of a multivariate Expectation Maximization Kalman Filter algorithm.
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
#   Sx
#     - kalman smoothed values
#   lik
#     - log likelihood
#   
kalman_em <- function(y, a, c, q, r, pi, v, max_i=20, tol=0.01) {
  
  source('C:/Users/Eric/Documents/R/KFS.R')
  A <- a
  C <- c
  Q <- q
  R <- r
  Pi <- pi
  V <- v
  y <- t(y)
  n <- dim(y)[2]  # number of timesteps
  d <- dim(A)[1]
  i <- 1  # iteration
  diff <- 1  # difference between iterations
  Pt <- array(0, dim=c(d,d,n))
  Ptt_1 <- array(0, dim=c(d,d,n-1))
  #lik <- array(0, dim=c(d,d,max_i))
  
  while (i <= max_i && diff > tol) {
    
    #  E Step:
    s <- KFS(A, C, Q, R, Pi, V, y)
    for (t in 1:n) {
      Pt[,,t] <- s$Sv[,,t]+s$Sx[,t]%*%t(s$Sx[,t])
      if (t != n) {
        Ptt_1[,,t] <- s$Scov[,,t]+s$Sx[,t+1]%*%t(s$Sx[,t])
      }
    }
    #like = (n/2)*log(solve(Q))-0.5*(solve(Q))%*%sum((s$Fx2-A%*%s$Fx1)^2)+((n+1)/2)*log(solve(R))-0.5*(solve(R))%*%sum((y-C%*%s$Fx1)^2)
    #lik[i] <- log(like)
    
    #  M Step:
    C_new <- y%*%t(s$Sx) / apply(Pt, c(1,2), sum)
    C_new <- C_new / norm(C_new, type="2")
    vR_new <- (apply(y*y, 1, sum)-apply((C_new%*%s$Sx)*y, 1, sum)) / n
    #R_new <- diag(vR_new)   I think this is more appropriate, but it's leading to the inverse error.
    R_new <- vR_new[1]*diag(d)
    A_new <- apply(Ptt_1, c(1,2), sum) / apply(Pt[,,1:n-1], c(1,2), sum)
    Pi_new <- array(s$Sx[,1], dim=c(1,d))
    Q_new <- diag(d)  # constraint
    V_new <- V  # constraint
    
    # updates
    diff <- norm(C_new-C)+norm(R_new-R)+norm(A_new-A)+norm(Q_new-Q)+norm(Pi_new-Pi)+norm(V_new-V)
    i <- i+1
    A <- A_new
    C <- C_new
    Q <- Q_new
    R <- R_new
    Pi <- Pi_new
    V <- V_new
  }
  #lik=lik[lik!=0]
  return(list(A=A, C=C, Q=Q, R=R, Pi=Pi, V=V, Sx=s$Sx))#, lik=lik))
}