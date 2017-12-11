#############################################################################################################################
###
###  Waiting times 
###
###  Code to demonstrate the link between the waiting times in a Poisson process to the Gamma and Exponential distributions
###  10 December 2017 v1.0
###
#############################################################################################################################
###  
###  Simulate an approximation to a Poisson process using discrete time steps
###  Measure the waiting time to each kth event
###  
###  Group the output to plot distribution
###  Compare the grouped output to waiting times drawn from:
###  	The Gamma distribution
###  	The Exponential distribution in the special case where k = 1, the waiting time between each Poisson events
###  
#############################################################################################################################

rm(list=ls())							# Remove objects currently in the workspace 
require(stats)							# Call the stats package for gamma and exponential distributions

tic = Sys.time()						# Start timer
p  = 0.001							# Rate for poisson process
n  = 10e6							# Number of time steps
k  = 5								# Waiting time for the kth arrival simulated
k_count = 0							# Counter to keep count up to kth-event

event <- array(dim=c(n))					# Initialise an n-array to record when events occur
count_event <- array(dim=c(n))					# Initialise an n-array to record the cumulative count of kth-events
clock_event <- array(dim=c(n))					# Initialise an n-array to record the time at which each kth-event happened

event = runif(n,0,1) < p					# Simulate events occurring for each time step using uniform distribution

								# Consider the first time step separately 
if (event[1] == 0) {						# If the first time step does not have an event: 
	count_event[1] = 0 } else {				#	Set the cumulative count to zero
								# If the first time step does contain an event:
	if (k_count == (k-1)) {					# 	And if we have reached the kth event:
	count_event[1] = 1					#		Set the cumulative kth-count to one
	clock_event[1] = 1					#		Record the first kth-event happening at t = 1
	} else {						#	Else if we have not reached the kth event:	
	count_event[1] = 0					#		Set the cumulative count to zero
	k_count = k_count + 1}					#		Increase the count of events seen before reaching the kth
	}

for (i in 2:n) {						# Set up a loop to consider the subsequent time steps in turn
	if (event[i] == 0) {					# If this time step does not have an event: 
	count_event[i] = count_event[i-1]			# 	Increase the cumulative count by one
	} else {						# If this time step does contain an event:
	if (k_count == (k-1)) {					#	And if we have reached the kth event:
	count_event[i] = count_event[i-1] + 1			#		Increase the cumulative count by one
	clock_event[count_event[i]] = i				#		Record the time step at which this event occurred
	k_count = 0						#		Reset the k-counter to start counting again
	} else {						#	Else if we have not reached the kth event:
	k_count = k_count + 1					#		Increease the k-counter by one
	count_event[i] = count_event[i-1]			#		Maintain the cumulative event count
	}}
}
tot_event = count_event[n]					# Record the total number of kth-events
wait_time <- array(dim=c(tot_event))				# Inialise an array to record the wait time to each kth-event 
wait_time[1] = clock_event[1]-1					# Record the wait time to the first kth-event
for (i in 2:tot_event) { 					# Set-up a loop to cycle through each kth-event
	wait_time[i] = clock_event[i]-clock_event[i-1] }	# Record the waiting for the kth-event

toc = Sys.time()						# End timer

cat("Runtime    : ", sprintf("%.5f",as.numeric(difftime(toc,tic,units=c("secs")))), "seconds \n \r")
								# Report the run time to screen
#############################################################################################################################

compare_gamma = rgamma(tot_event,shape=k,rate=p)		# Draw a waiting time from Gamma distribution
if (k == 1) { compare_exp = rexp(tot_event, p) }		# If k=1, draw a waiting time from Exponential distribution
	
wait_bucket <- array(dim=c(tot_event))				# Initialise array to bucket simulated waiting times for graphical output
compg_bucket <- array(dim=c(tot_event))				# Initialise array to bucket Gamma waiting times for graphical output
compe_bucket <- array(dim=c(tot_event))				# Initialise array to bucket Exponential waiting times for graphical output

wait_bucket = floor(wait_time/(k/p/25))				# Allocate simulated wait times to a bucket 
compg_bucket = floor(compare_gamma/(k/p/25))			# Allocate Gamma distributed wait times to a bucket
if (k == 1) {compe_bucket = floor(compare_exp/(k/p/25))}	# If k=1, allocate Exponential distributed wait times to a bucket

num_bucket = max(wait_bucket,compg_bucket)			# Determine the number of buckets to loop over
wait_count <- array(dim=c(num_bucket))				# Initialise array to count simulated waiting times in a bucket
compg_count <- array(dim=c(num_bucket))				# Initialise array to count Gamma waiting times in a bucket
compe_count <- array(dim=c(num_bucket))				# Initialise array to count Expontential waiting times in a bucket

for (i in 1:num_bucket) {					# Loop over number of buckets
	wait_count[i] = sum(wait_bucket == i)			# Count simulated wait times in the specific bucket
	compg_count[i] = sum(compg_bucket == i)			# Count Gamma wait times in specific bucket
	if (k == 1) { compe_count[i] = sum(compe_bucket == i)}	# Count Exponential wait times in specific bucket
	}							

plot(wait_count)						# Plot the simulated distribution
points(compg_count,col="red")					# Add the Gamma distribution
if (k == 1) {points(compe_count,col="blue")}			# If k=1, add the Exponential distribution

#############################################################################################################################
