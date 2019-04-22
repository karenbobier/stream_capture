#PBS -S /bin/bash
#PBS -q batch
#PBS -N declone_3rad
#PBS -l nodes=1:ppn=12
#PBS -l walltime=48:00:00
#PBS -l mem=125gb
#PBS -M keb27269@uga.edu
#PBS -m abe
#PBS -o $HOME/demultiplex4.out.$PBS_JOBID
#PBS -e $HOME/demultiplex4.err.$PBS_JOBID

basedir="/scratch/keb27269/stream_cap/"
#mkdir $basedir
cd $basedir

#loading the software in the cluster
module load Stacks/2.3e-foss-2016b

#Running the declone_filter pipeline
mkdir /scratch/keb27269/stream_cap/declone_all
set -ueo pipefail
FILE="13573
13574
13575
13576
13544
13545
13546
13547
13701
13702
13703
13704
13741
13742
13743
13744
13832
13833
13836
13838
13887
13888
13889
13890
13924
13925
13926
13930
13993
13994
13995
13996
"
i=1
for FNAME in $FILE
do
echo "declone_$FNAME"
clone_filter -P -1 /scratch/keb27269/stream_cap/demultiplex_all/$FNAME.1.fq.gz -2 /scratch/keb27269/stream_cap/demultiplex_all/$FNAME.2.fq.gz -o /scratch/keb27269/stream_cap/declone_all/ -i gzfastq --null_index --oligo_len_2 8
let "i+=1";
done

#change file names
rename .1.1. .1. *
rename .2.2. .2. *
