#############################################################################################################################
###
###  Galton Board
###
###  Code to demonstrate link between Bernoulli, Binomial and Normal distributions
###  4 December 2017 v1.0
###
#############################################################################################################################
###  
###  Simulate a Galton board.
###  Pins are hammered into a board in a triangle layout. 
###  A ball is dropped from the top, and has a probability p
###  of falling to the right and (1-p) falling to the left.
###  The ball will then hit the next pin. There are n rows of pins
###  in total. After hitting the final pin, the ball will land in
###  one of 101 buckets.
###
###  The code simulates this directly and counts the number of balls
###  in each bucket. It then calculates this result directly using the
###  binomial distribution from the (in-built) 'stats' package. 
###  Finally it shows the Normal distribution approximates the binomial 
###  distribution from large n. 
###  
#############################################################################################################################

rm(list=ls())							# Remove objects currently in the workspace
require(stats)							# Call the stats package for binomial and normal distribution
								# (If needed. This is probably already loaded.)

tic = Sys.time()						# Start timer
### Initialise parameters

p = 0.5								# Probability of falling right
n = 100								# Number of rows of pins
ns = 100001							# Number of simulations
bucket_count <- array(dim=c(n+1))				# Initialise an (n+1)-array to store count of balls
bucket_count[] = 0						# Start count at zero in each bucket
bounce <- array(dim=c(n))					# Initialise an n-array to store the path of a single ball
count_fall_right = 0						# Start the count for number of times the ball bounces left

for (s in 1:ns) {						# Initial a loop over the number of simulations
   bounce = runif(n,0,1) < p					# Generate n random numbers from the Uniform distribution [0,1]
								# to generate the path of a single ball through the board.
								# If the random number is less than p, count as 'bounce left' and 
								# store 'TRUE' in the entry of the bounce array which corresponds
								# to that row.
								# If not less than p, count as 'bounce right' and store 'FALSE'.
   which_bucket = sum(bounce)+1					# Count the number of 'TRUE' entries in bounce to determine
								# the bucket in which the ball lands.
   bucket_count[which_bucket] = bucket_count[which_bucket]+1	# Make a count of the ball in the bucket in which it lands
	}
toc = Sys.time()						# End timer
#############################################################################################################################

cat("Runtime of numerical simulation    : ", sprintf("%.5f",toc-tic), "seconds \n \r")	
								# Print the runtime of the numerical simulation (in seconds) to the screen
								# using 5 decimal places, starting a new line with carraige return

tic = Sys.time()						# Start timer
compare_binom = ns*dbinom(0:n,size=n,prob=p)			# Generate the binomial distribution directly from R stats library
compare_norm  = ns*dnorm(0:n,mean=n*p,sd=sqrt(n*p*(1-p)))	# Generate the normal distribution directly from R stats library
toc = Sys.time()						# End timer
cat("Runtime of statistical libraries   : ", sprintf("%.5f",toc-tic), "seconds \n \r")	
								# Print the runtime of calling the libraries (in seconds) to the screen

tic = Sys.time()						# Start timer
plot(bucket_count,pch=22)					# Plot the numerical simulation as a black square
points(compare_binom,pch=21,col="red")				# Overlay the binomial distribution as a red circle
lines(compare_norm,col="blue")					# Overlay the normal distribution as a blue line
toc = Sys.time()						# End timer

cat("Runtime of graphical output        : ", sprintf("%.5f",toc-tic),"seconds \n \r")	
								# Print the runtime of the graphical output (in seconds) to the screen

#############################################################################################################################
