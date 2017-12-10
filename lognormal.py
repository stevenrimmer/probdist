import numpy as np
from scipy import stats 
import time
import matplotlib.pyplot as plt
tic = time.time()
mu, sigma, sample = 0.5 , 0.75 , 1000000 	#mean and standard deviation
S = np.random.normal(mu, sigma, sample)
S_bar = np.mean(S)
S_var = np.var(S)
lnS = np.exp(S)
lnS_bar = np.mean(lnS)
lnS_var = np.var(lnS)
lnS_mean = np.exp(mu + sigma**2/2)
lnS_sig = np.exp(2*mu+sigma**2)*(np.exp(sigma**2)-1)
toc = time.time()
timer = toc-tic
print('-----------------')
print('Calculation run time                                : %.5f seconds' %timer)
print('-----------------')
print('Simulated mean of the normal distribution           : %.5f' %S_bar)
print('Input mean of the normal distribution               : %.5f' %mu)
print('-----------------')
print('Simulated variance of the normal distribution       : %.5f' %S_var)
print('Input variance of the normal distribution           : %.5f' %sigma**2)
print('-----------------')
print('Simulated mean of the log-normal distribution       : %.5f' %lnS_bar)
print('Input mean of the log-normal distribution           : %.5f' %lnS_mean)
print('-----------------')
print('Simulated variance of the log-normal distribution   : %.5f' %lnS_var)
print('Input variance of the log-normal distribution       : %.5f' %lnS_sig)

tic = time.time()
bin_num = 1000
n, bins, patches = plt.hist(lnS, bin_num, facecolor = 'blue', alpha=0.5)
z = bins[0:bin_num]+np.diff(bins)/2
y = stats.lognorm.pdf(z, sigma ,scale=np.exp(mu))
l = plt.plot(z, sample*y/sum(y), linestyle = '--', color = 'red', linewidth = 2)

plt.axis([0,lnS_mean+2*lnS_sig,0,1.1*max(n)])
plt.grid(True)

toc = time.time()
timer = toc-tic
print('-----------------')
print('Plot run time                                       : %.5f seconds' %timer)
print('-----------------')
plt.show()
