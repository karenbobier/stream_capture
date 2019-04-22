#PBS -S /bin/bash
#PBS -q highmem_q
#PBS -l nodes=1:ppn=24
#PBS -l mem=400gb
#PBS -N process_radtags_streamcap
#PBS -l walltime=96:00:00
#PBS -M keb27269@uga.edu
#PBS -m abe
#PBS -o $HOME/process_streamcap.out.$PBS_JOBID
#PBS -e $HOME/process_streamcap.err.$PBS_JOBID

basedir="/scratch/keb27269/stream_cap/"
#mkdir $basedir
cd $basedir

#loading the software in the cluster
module load Stacks/2.3e-foss-2016b

mkdir /scratch/keb27269/I_scapularis_3RAD/

set -ueo pipefail
SAMPLES="13573
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

for i in $SAMPLES
do
mkdir /scratch/keb27269/I_scapularis_3RAD/process_output_first_$i
process_radtags -P -1 /scratch/keb27269/EHS_Class/raw_D2/$i\_R1_001.fastq.gz -2 /scratch/keb27269/EHS_Class/raw_D2/$i\_R2_001.fastq.gz \
-b /scratch/keb27269/EHS_Class/barcodes_D2/$i\.txt --inline_inline -c -q -r -t 140 --disable_rad_check \
-o /scratch/keb27269/I_scapularis_3RAD/process_output_first_$i/ -i gzfastq
done

for i in $SAMPLES
do
mkdir /scratch/keb27269/I_scapularis_3RAD/process_output_second_$i
process_radtags -P -1 /scratch/keb27269/I_scapularis_3RAD/process_output_first_$i/$i\.1.fq.gz -2 /scratch/keb27269/I_scapularis_3RAD/process_output_first_$i/$i\.2.fq.gz \
-c -q -t 140 --renz_1 mspI --renz_2 bamHI \
-o /scratch/keb27269/I_scapularis_3RAD/process_output_second_$i/ -i gzfastq
done

mkdir /scratch/keb27269/I_scapularis_3RAD/process_output_final
cp /scratch/keb27269/I_scapularis_3RAD/process_output_second_*/*.fq.gz /scratch/keb27269/I_scapularis_3RAD/process_output_final/
cd /scratch/keb27269/I_scapularis_3RAD/process_output_final/
rename .1.1. .1. *
rename .2.2. .2. *
gunzip *.fq.gz
sed -Ei 's/\/1\/1/\/1/' *.1.fq
sed -Ei 's/\/2\/2/\/2/' *.2.fq
gzip *.fq

rm *rem*
