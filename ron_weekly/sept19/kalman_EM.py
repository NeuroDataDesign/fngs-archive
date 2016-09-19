# kalman_filter.py
# Created by Ron Boger on 2016-09-18
# Email: rboger2@jhu.edu
# Copyright (c) 2016. All rights reserved. 
#
# An implementation of a univariate EM Kalman Filter algorithm.
#
#
# given:
#     n is the number of variables we are tracking
#     t is the number of timesteps/observations
#     m is the number of sensors we are using
#
# NOTE: Generally, Z and X are in the forms [m, t] and [n, t]
#   respectively. Here, we use the forms [t, m] and [t, n], as these
#   are the general conventions to have observations (t) as the rows
#   and variables (n, m) as the columns.
# Inputs:
#   F[n, n]
#     - the update matrix
#     - updating the parameters for our predicted states
#   Z[t, m]
#     - the measurement vector
#     - outputs directly from the sensors
#   H[m, n]
#     - extraction matrix
#     - tells the sensor readings if we have input X
#     - ideally, Z^T = HX^T
#     - hope for this to be the identity matrix
#   R[t, m, m]
#     - variance-covariance matrix of the sensors
#   u[t, c, 1]
#     - move matrix
#     - change to X that is known to be happening
#   B[n, c]
#     - governs impact on each variable known change has
#   Q[t, n]
#     - the environment noise at each time step
#   p0[n, n]
#     - initial guess of the covariance matrix
#     - gives a sense of the possible noise in our estimate/process
#   x0[1, n]
#     - initial guess of the state we are in
# Outputs:
#   X[t, n]
#     - the state matrix
#   P[t, n, n]
#     - the process covariance matrices

import numpy as np
import matplotlib.pyplot as plt

def kalman_filter_multivariate(Fm, Z, H, R, u, B, Q, p0, x0):
	# access important dimensions
	t = Z.shape[0]
	n = x0.shape[1]
	m = Z.shape[1]

	#TODO: manipulate array inputs to be the same shape

	# c = u.shape[1]

	#allocate space for arrays
	X = np.zeros((t, n))
	P = np.zeros((t, n, n))
	X[0, :] = x0
	P[0, :, :] = p0

	for k in xrange(1,t):
		X[k, :] = np.dot(Fm, X[k-1, :]) + np.squeeze(np.dot(B, u[k, :, :]))
		P[k, :, :] = np.dot(np.dot(Fm, P[k-1,: ,:]), np.transpose(Fm)) + Q[k, :]
		K = np.dot(np.dot(P[k, :, :], np.transpose(H)), np.linalg.inv(np.array(np.dot(np.dot(H, P[k, :, :]), np.transpose(H))) + R[k, :, :]))
		X[k, :] = X[k, :] + np.dot(K, (Z[k, :] - np.dot(H, X[k, :])))
		P[k, :, :] = np.dot((np.eye(n) - np.dot(K, H)), P[k, :, :])

	return P, X

def univariate_simul():
	timesteps = 50

	true_value = .25
	variance = .1
	
	Z = np.random.normal(true_value, variance, size = (timesteps, 1))
	R = .2*np.ones((timesteps, 1, 1))
	Q = (1e-5)*np.ones((timesteps, 1))
	
	u = np.zeros((timesteps,1, 1)) #control variable matrix
	#for simplicity
	B = np.zeros((1, 1))
	H = np.ones((1, 1))
	Fm = np.ones((1, 1))

	p0 = np.ones((1, 1))
	x0 = np.zeros((1, 1))

	(P, X) = kalman_filter_multivariate(Fm, Z, H, R, u, B, Q, p0, x0)
	
	plt.figure()
	plt.plot(Z, 'k+', label = 'measurements')
	plt.plot(X, 'b-', label = 'kalman estimate')
	plt.plot(true_value*np.ones((timesteps,)))
	plt.legend()
	plt.title('Univariate Kalman filter on uniformly sampled random data')
	plt.xlabel('Time step')
	plt.ylabel('Value')
	plt.show()

def multivaraite_simul():
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
	# multivaraite_simul()
	univariate_simul()

if __name__ == '__main__':
	main()


