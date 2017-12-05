#############################################################################################################################
###
### 
###
###
###
###
#############################################################################################################################
###  
###  
###  
###  
###  
### 
###  
###  
###
###  
###  
###  
###  
###  
###  
#############################################################################################################################

rm(list=ls())			
require(stats)		

tic = Sys.time()
p  = 0.001
n  = 10e6
k  = 5


event <- array(dim=c(n))
count_event <- array(dim=c(n))
clock_event <- array(dim=c(n))
k_count = 0

event = runif(n,0,1) < p

if (event[1] == 0) {
	count_event[1] = 0 } else {
	if (k_count == (k-1)) {
	count_event[1] = 1
	clock_event[1] = 1
	} else {
	count_event[1] = 0
	k_count = k_count + 1}
	}

for (i in 2:n) {
	if (event[i] == 0) {
	count_event[i] = count_event[i-1]
	} else {
	if (k_count == (k-1)) {
	count_event[i] = count_event[i-1] + 1
	clock_event[count_event[i]] = i
	k_count = 0
	} else {
	k_count = k_count + 1
	count_event[i] = count_event[i-1]
	}}
}
tot_event = count_event[n]

wait_time <- array(dim=c(tot_event))
wait_time[1] = clock_event[1]-1
for (i in 2:tot_event) { wait_time[i] = clock_event[i]-clock_event[i-1] }

toc = Sys.time()
clock = 
cat("Runtime    : ", sprintf("%.5f",as.numeric(difftime(toc,tic,units=c("secs")))), "seconds \n \r")
#############################################################################################################################

#compare_exp = rexp(tot_event, p)
compare_gamma = rgamma(tot_event,shape=k,rate=p)

wait_bucket <- array(dim=c(tot_event))
wait_bucket = floor(wait_time*(5*p))
comp_bucket = floor(compare_gamma*(5*p))

num_bucket = max(wait_bucket,comp_bucket)
wait_count <- array(dim=c(num_bucket))
comp_count <- array(dim=c(num_bucket))
for (i in 1:num_bucket) {
	wait_count[i] = sum(wait_bucket == i)
	comp_count[i] = sum(comp_bucket == i)
	}

plot(wait_count)
points(comp_count,col="red")

#############################################################################################################################
