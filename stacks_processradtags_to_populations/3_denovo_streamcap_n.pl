#PBS -S /bin/bash
#PBS -q highmem_q
#PBS -l nodes=1:ppn=12
#PBS -l mem=400gb
#PBS -N denovo_test_n
#PBS -l walltime=96:00:00
#PBS -M keb27269@uga.edu
#PBS -m abe
#PBS -o $HOME/denovo_n.out.$PBS_JOBID
#PBS -e $HOME/denovo_n.err.$PBS_JOBID

basedir="/scratch/keb27269/EHS_Class/"
#mkdir $basedir
cd $basedir

module load Stacks/2.3-foss-2016b-p1
module load Perl/5.26.0-GCCcore-6.4.0

set -ueo pipefail
n="1
2
3
4
5
6
7
8
9
10
"

for FNAME  in $n
do
mkdir /scratch/keb27269/I_scapularis_3RAD/denovo_output/denovo_n_$FNAME
denovo_map.pl --samples /scratch/keb27269/I_scapularis_3RAD/process_output_final/ \
--popmap /scratch/keb27269/EHS_Class/Iscap_D2_populationmap.txt \
-o /scratch/keb27269/I_scapularis_3RAD/denovo_output/denovo_n_$FNAME \
--paired -m 3 -n $FNAME -M 4 -t -T 12 \
-X "populations: -r 0.8 --fstats --fasta_strict --vcf --genepop"
done
