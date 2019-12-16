

#This assumes your empirical data is in the object "target" as a single vector
#your reference table of simulated ajSFS is in the object "sims" as a matrix
#the number of simulations you have is stored in the object "nsims"
#the tolerance level for accepted simulations is in the object "tol"

for(i in 1:length(target)){
sims[,i]=(sims[,i]-target[i])^2
}
abcresults=rep(0,nsims)
for(i in 1:nsims){
abcresults[i]=(sum(sims[i,]))^.5
}
if(sort(abcresults)[1]==sort(abcresults)[((nsims*tol)+1)]){
abcresults=which(abcresults==sort(abcresults)[1])
} else {
abcresults=order(abcresults)[1:((nsims*tol)+1)]
}

#Your resulting object "abcresults" then is a list of indices
#corresponding to the accepted simulations
#to get a posterior distribution, you could enter "param[abcresults]"
