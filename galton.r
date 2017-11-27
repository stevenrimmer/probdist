rm()
setwd("C:/Users/s46kxj/Desktop/ProgAct")

p = 0.5
n = 100
ns = 100001
bucket <- array(dim=c(n+1))
bucket[] = 0
bounce <- array(dim=c(n))
count_heads = 0

for (s in 1:ns) {
bounce = runif(n,0,1)<p
location = sum(bounce)
bucket[location+1] = bucket[location+1]+1
count_heads = count_heads+location/(n*ns)
}
checkn = ns*dnorm(0:n,mean=n*p,sd=sqrt(n*p*(1-p)))
checkb = ns*dbinom(0:n,size=n,prob=p)
plot(bucket)
lines(checkn,col="red")
points(checkb,col="blue")

