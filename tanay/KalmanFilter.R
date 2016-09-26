# Returns updated current state and probability estimates
KalmanFilter <- function(A, B, H, currStateEst, currProbEst, Q, R, controlVect, measVect) {
  # Prediction
  predStateEst = A * currStateEst + B * controlVect
  predProbEst = (A * currProbEst) * t(A) + Q
  
  # Observation
  diff = measVect - (H * predStateEst)
  diffCov = H * predProbEst * t(H) + R
  
  # Update
  kalmanGain = predProbEst * t(H) * solve(diffCov)
  newCurrStateEst = predStateEst + kalmanGain * diff
  newCurrProbEst = (diag(nrow(kalmanGain)) - kalmanGain * H) * predProbEst
  #newCurrProbEst = (1 - kalmanGain * H) * predProbEst
  
  return(c(newCurrStateEst, newCurrProbEst))
}

A <- matrix(c(1), 1, 1)
B <- matrix(c(0), 1, 1)
H <- matrix(c(1), 1, 1)
currStateEst <- matrix(c(3), 1, 1)
currProbEst <- matrix(c(1), 1, 1)
Q <- matrix(c(0.00001), 1, 1)
R <- matrix(c(0.1), 1, 1)
controlVect <- matrix(c(0), 1, 1)

measuredData = 5
trueData = 5
kalmanData = 0

set.seed(1)

for (i in 1:600) {
  meas <- rnorm(1, 5, 1)
  measuredData <- c(measuredData, meas)
  trueData <- c(trueData, 5)
  
  temp <- KalmanFilter(A, B, H, currStateEst, currProbEst, Q, R, controlVect, matrix(meas, 1, 1))
  currStateEst <- temp[1]
  currProbEst <- temp[2]
  
  kalmanData <- c(kalmanData, currStateEst)
}

plot(trueData, type = "l")
lines(measuredData, type = "l", col = "blue")
lines(kalmanData, type = "l", col = "red")
