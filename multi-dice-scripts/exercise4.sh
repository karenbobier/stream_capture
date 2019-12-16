#PBS -S /bin/bash
#PBS -q batch
#PBS -N multi_dice1
#PBS -l nodes=1:ppn=12
#PBS -l walltime=4:00:00:00
#PBS -l mem=125gb
#PBS -M keb27269@uga.edu
#PBS -m abe
#PBS -o $HOME/multidice.out.$PBS_JOBID
#PBS -e $HOME/multidice.err.$PBS_JOBID

basedir="/scratch/keb27269/stream_cap/multi_dice/"
cd $basedir

module load R/3.4.4-foss-2016b-X11-20160819-GACRC
export PATH=${HOME}/apps/fastsimcoal2/2.6.0.2:$PATH

cp  L_zonistius_MSFS.obs dice_MSFS.obs

echo "zeta=sample(1:4,1,replace=T)/4
tau1s=sample(500000:2000000,1,replace=T)
beta=round(exp(.95*log(tau1s))):round(exp(1.05*log(tau1s)))
NPOP0=sample(100000:1000000,4,replace=T)
NPOP1=sample(100000:1000000,4,replace=T)
NM1=exp(sample(round((log(1e-5)*100000)):round((log(10)*100000)),4,replace=T)/100000)
MIG1=NM1/NPOP0
NM2=exp(sample(round((log(1e-5)*100000)):round((log(10)*100000)),4,replace=T)/100000)
MIG2=NM2/NPOP1
NM3=exp(sample(round((log(1e-5)*100000)):round((log(10)*100000)),4,replace=T)/100000)
MIG3=NM3/NPOP0
NM4=exp(sample(round((log(1e-5)*100000)):round((log(10)*100000)),4,replace=T)/100000)
MIG4=NM4/NPOP1
RESIZE0=exp(sample(round((log(.1)*100000)):round((log(10)*100000)),4,replace=T)/100000)
RESIZE1=exp(sample(round((log(.1)*100000)):round((log(10)*100000)),4,replace=T)/100000)
TIME2=c(rep(tau1s,(zeta*4)),sample(c(500000:2000000)[!c(500000:2000000)%in%beta],((1-zeta)*4),replace=T))
TIMEP=sample(50000:1998000,4,replace=T)/200000
TIME1=round(TIMEP*TIME2)
write.table(rbind(NPOP0,NPOP1,NM1,MIG1,NM2,MIG2,NM3,MIG3,NM4,MIG4,RESIZE0,RESIZE1,TIME2,TIMEP,TIME1),'dice.draws',row.names=F,col.names=F)
write.table(c(zeta,tau1s,mean(TIME2),var(TIME2)/mean(TIME2),mean(TIME1),var(TIME1)/mean(TIME1),mean(NM1),var(NM1)/mean(NM1),mean(NM2),var(NM2)/mean(NM2),mean(NM3),var(NM3)/mean(NM3),mean(NM4),var(NM4)/mean(NM4),mean(RESIZE0),var(RESIZE0)/mean(RESIZE0),mean(RESIZE1),var(RESIZE1)/mean(RESIZE1)),'dice.hyperdraws',row.names=F,col.names=F)
" >dice.R

echo "//Number of population samples (demes)
2
//Population effective sizes (number of genes)
NPOP0
NPOP1
//Samples sizes and samples age
8
8
//Growth rates: negative growth implies population expansion
0
0
//Number of migration matrices : 0 implies no migration between demes
3
//Migration matrix 0
0 MIG1
MIG2 0
//Migration matrix 1
0 MIG3
MIG4 0
//Migration matrix 2
0 0
0 0
//historical event: time, source, sink, migrants, new deme size, growth rate, migr mat index
3 historical events
TIME1 0 0 0 RESIZE0 0 1
TIME1 1 1 0 RESIZE1 0 1
TIME2 0 1 1 1 0 2
//Number of independent loci [chromosome]
1 0
//Per chromosome: Number of contiguous linkage Block: a block is a set of contiguous loci
1
//per Block:data type, number of loci, per gen recomb and mut rates
FREQ 1 0 0 OUTEXP
" >dice.template.par

for i in {1..10000}
do
R -s <dice.R >/dev/null 2>&1
cat dice.draws|awk "NR==1" >>dice.NPOP0
cat dice.draws|awk "NR==2" >>dice.NPOP1
cat dice.draws|awk "NR==3" >>dice.NM1
cat dice.draws|awk "NR==4" >>dice.MIG1
cat dice.draws|awk "NR==5" >>dice.NM2
cat dice.draws|awk "NR==6" >>dice.MIG2
cat dice.draws|awk "NR==7" >>dice.NM3
cat dice.draws|awk "NR==8" >>dice.MIG3
cat dice.draws|awk "NR==9" >>dice.NM4
cat dice.draws|awk "NR==10" >>dice.MIG4
cat dice.draws|awk "NR==11" >>dice.RESIZE0
cat dice.draws|awk "NR==12" >>dice.RESIZE1
cat dice.draws|awk "NR==13" >>dice.TIME2
cat dice.draws|awk "NR==14" >>dice.TIMEP
cat dice.draws|awk "NR==15" >>dice.TIME1
cat dice.hyperdraws|awk "NR==1" >>dice.zeta
cat dice.hyperdraws|awk "NR==2" >>dice.tau1s
cat dice.hyperdraws|awk "NR==3" >>dice.meantau1
cat dice.hyperdraws|awk "NR==4" >>dice.omegatau1
cat dice.hyperdraws|awk "NR==5" >>dice.meantau2
cat dice.hyperdraws|awk "NR==6" >>dice.omegatau2
cat dice.hyperdraws|awk "NR==7" >>dice.meanM1
cat dice.hyperdraws|awk "NR==8" >>dice.omegaM1
cat dice.hyperdraws|awk "NR==9" >>dice.meanM2
cat dice.hyperdraws|awk "NR==10" >>dice.omegaM2
cat dice.hyperdraws|awk "NR==11" >>dice.meanM3
cat dice.hyperdraws|awk "NR==12" >>dice.omegaM3
cat dice.hyperdraws|awk "NR==13" >>dice.meanM4
cat dice.hyperdraws|awk "NR==14" >>dice.omegaM4
cat dice.hyperdraws|awk "NR==15" >>dice.meanepsilon0
cat dice.hyperdraws|awk "NR==16" >>dice.omegaepsilon0
cat dice.hyperdraws|awk "NR==17" >>dice.meanepsilon1
cat dice.hyperdraws|awk "NR==18" >>dice.omegaepsilon1

for b in {1..4}
do
cat dice.draws|cut -d ' ' -f ${b} >dice.draw
cat dice.template.par|sed -e "s/NPOP0/`cat dice.draw|awk 'NR==1'`/g" -e "s/NPOP1/`cat dice.draw|awk 'NR==2'`/g" -e "s/MIG1/`cat dice.draw|awk 'NR==4'`/g" -e "s/MIG2/`cat dice.draw|awk 'NR==6'`/g" -e "s/MIG3/`cat dice.draw|awk 'NR==8'`/g" -e "s/MIG4/`cat dice.draw|awk 'NR==10'`/g" -e "s/RESIZE0/`cat dice.draw|awk 'NR==11'`/g" -e "s/RESIZE1/`cat dice.draw|awk 'NR==12'`/g" -e "s/TIME2/`cat dice.draw|awk 'NR==13'`/g" -e "s/TIME1/`cat dice.draw|awk 'NR==15'`/g" >dice.par
/home/keb27269/apps/fastsimcoal2/2.6.0.2/fsc26 -i dice.par -n 10000 -m -c 1 --multiSFS >/dev/null 2>&1
cat dice/dice_MSFS.txt|awk 'NR==3' >>dice.SFS.${b}
done
done
