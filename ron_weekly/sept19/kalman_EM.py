# kalman_filter.py
# Created by Ron Boger on 2016-09-18
# Email: rboger2@jhu.edu
# Copyright (c) 2016. All rights reserved. 
#
# An implementation of a univariate EM Kalman Filter algorithm.
#
# Inputs:
#   y[t]
#     - observed data
#     - univariate t time stpe
#   a, c, q, r, pi, v
#     - initial parameter values
#     - state transition, generative, state noise, output noise, state mean, covariance
#   max_i
#     - maximum number of iterations before cut-off
#     - default of 20
#   tol
#     - minimum difference between iterations before cut-off
#     - default of 0.01
# Outputs:
#   A, C, Q, R, Pi, V
#     - final parameter estimations
#     - equivalent to respectively named inputs
#   Sx
#     - kalman smoothed values
#   lik
#     - log likelihood

import numpy as np
import matplotlib.pyplot as plt
from pykalman import KalmanFilter #has smoothing operation

def kalman_em_univariate(y, a, c, q, r, pi, v, max_i = None, tol = None):
	# access important dimensions

	if max_i is None:
		max_i = 20
	if tol is None:
		tol = .01
	
	A = a
	C = c #U_{p by d} matrix from compact SVD of Y
	Q = q
	R = r #should be identity matrix according to paper
	Pi = pi #0 vector according to paper
	V = v
	n = len(y) # number of timesteps
	i = 1 #iteration
	diff = 1 # difference between iterations
	Pt = np.zeros((n, 1))
	Ptt_1 = np.zeros((n-1, 1))
	lik = np.zeros((max_i, 1))
	
	while (i <= max_i) and (diff > tol):
		
		#E step
		# update expected values with Kalman filter smoother

		#M step

		#updates

	#how is Sx even initialized?
	return A, C, Q, R, Pi, V, Sx, lik


def univaraite_simul():
	timesteps = 50
	signal_1 = .25
	signal_2 = 4
	signal_variance = .1

	Z = np.zeros((timesteps, 2))
	Z[:, 0] = np.random.normal(signal_1, signal_variance, size = (timesteps,))
	Z[:, 1] = np.random.normal(signal_2, signal_variance, size = (timesteps,))
	R_mat_ind = signal_variance * np.eye(2)
	R = np.zeros((timesteps, 2, 2))
	for x in xrange(0,timesteps):
		R[x, :, :] = R_mat_ind
	Q = (1e-5)*np.ones((timesteps, 2))
	u = np.zeros((timesteps,1, 1)) #control variable matrix
	B = np.zeros((2, 1))
	H = np.eye(2)
	Fm = np.eye(2)

	p0 = np.eye(2)
	x0 = np.array([[.5, 4.5],])

	(P, X) = kalman_filter_multivariate(Fm, Z, H, R, u, B, Q, p0, x0)

	plt.figure()
	plt.plot(Z[:, 0], 'k+', label = 'measurements')
	plt.plot(X[:, 0], 'b-', label = 'kalman estimate')
	plt.plot(signal_1*np.ones((timesteps,)))

	plt.plot(Z[:, 1], 'y+', label = 'measurements')
	plt.plot(X[:, 1], 'g-', label = 'kalman estimate')
	plt.plot(signal_2*np.ones((timesteps,)))
	plt.legend()
	plt.title('Univariate Kalman filter on uniformly sampled random data')
	plt.xlabel('Time step')
	plt.ylabel('Value')
	plt.show()

def main():
	univariate_simul()

if __name__ == '__main__':
	main()


