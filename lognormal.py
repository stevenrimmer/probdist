#############################################################################################################################
###
###  Lognormal parameters
###
###  Code to demonstrate link between mean and variance / mu and sigma in normal and log-normal distributions
###  10 December 2017 v1.0
###
#############################################################################################################################
###  
###  Demonstrate that the 'mu' and 'sigma' parameters in numpy's normal distribution  
###  do correspond to the mean and standard deviation of a random sample it generates.
###  
###  Demonstrate that taking the exponential of the randomly generated sample forms the
###  log-normal distribution by comparing to the book results for the mean and variance
###  and plotting a chart to reproduce the log-normal pdf from the scipy library.
###  
#############################################################################################################################



import numpy as np						# Call the numpy library, and state that we will use np as a pseduonym
from scipy import stats 					# Call the stats library from scipy
import time							# Call the time library to generate runtime statistics
import matplotlib.pyplot as plt					# Call a plotting library, and state that we will use plt as a psudonym

tic = time.time()						# Start timer
mu, sigma, sample = 0.25 , 0.75 , 1e6 				# Initialise parameters for mu, sigma and the number of simulations
S = np.random.normal(mu, sigma, sample)				# Genarate 'sample' instances of random numbers from normal distribution
S_bar = np.mean(S)						# Calculate the mean of the simulated numbers
S_var = np.var(S)						# Calculate the variance of the simulated numbers
expS = np.exp(S)						# Calculate the exponent of the random normal numbers is the sample
expS_bar = np.mean(expS)					# Calculate the mean of the exponentiated simulated numbers
expS_var = np.var(expS)						# Calculate the variance of the exponentiated simulated numbers
expS_mean = np.exp(mu + sigma**2/2)				# Calculate the mean of the log-normal distribution using standard result
expS_sig = np.exp(2*mu+sigma**2)*(np.exp(sigma**2)-1)		# Calculate the variance of the log-normal distribution using standard result
toc = time.time()						# End timer
timer = toc-tic							# Calculate run time
								# Output results to screen --
print('-----------------')
print('Calculation run time                                   : %.5f seconds' %timer)
print('-----------------')
print('Simulated mean of the normal distribution              : %.5f' %S_bar)
print('Input mean (= mu) of the normal distribution           : %.5f' %mu)
print('-----------------')
print('Simulated variance of the normal distribution          : %.5f' %S_var)
print('Input variance (=sigma^2) of the normal distribution   : %.5f' %sigma**2)
print('-----------------')
print('Simulated mean of the log-normal distribution          : %.5f' %expS_bar)
print('Calculated mean of the log-normal distribution         : %.5f' %expS_mean)
print('-----------------')
print('Simulated variance of the log-normal distribution      : %.5f' %expS_var)
print('Calculated variance of the log-normal distribution     : %.5f' %expS_sig)

tic = time.time()						# Restart timer
bin_num = 1000							# Set the number of bins to plot histogram
n, bins, patches = plt.hist(expS, bin_num,			# Generate a histogram of the exponentiated sample 'bin_num' bins 
			facecolor = 'blue', alpha=0.5)		# Colour the bars blue with a degree of transparency
z = bins[0:bin_num]+np.diff(bins)/2				# Calculate the position of the centre of the bins
y = stats.lognorm.pdf(z, sigma ,scale=np.exp(mu))		# Generate the lognormal pdf from the scipy library 
l = plt.plot(z, sample*y/sum(y),				# Plot the lognormal pdf result from the standard library
	linestyle = '--', color = 'red', linewidth = 2)		# Use a dashed line, in red of a given width
plt.axis([0,expS_mean+2*expS_sig,0,1.1*max(n)])			# Plot from 0 to 2sd into the tail and from 0 to above the largest bar
plt.grid(True)							# Add gridlines

toc = time.time()						# End timer
timer = toc-tic							# Calculate time to plot
								# Output runtime to screen
print('-----------------')					
print('Plot run time                                       : %.5f seconds' %timer)
print('-----------------')
plt.show()							# Plot chart

#############################################################################################################################
