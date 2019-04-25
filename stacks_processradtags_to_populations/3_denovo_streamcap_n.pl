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

basedir="/scratch/keb27269/stream_cap/"
#mkdir $basedir
cd $basedir

module load Stacks/2.3e-foss-2016b
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

#for Notropis_lutipinnis
for FNAME  in $n
do
mkdir /scratch/keb27269/stream_cap/N_lutipinnis/denovo_output/denovo_n_$FNAME
denovo_map.pl --samples /scratch/keb27269/stream_cap/declone_all/N_lutipinnis/ \
--popmap /scratch/keb27269/stream_cap/N_lutipinnis/N_lutipinnis_populationmap.txt \
-o /scratch/keb27269/stream_cap/N_lutipinnis/denovo_output/denovo_n_$FNAME \
--paired -m 3 -n $FNAME -M 3 -t -T 12 \
-X "populations: -r 0.8 --fstats --fasta_strict --vcf --genepop"
done

#for Nocomis_leptocephalus
for FNAME  in $n
do
mkdir /scratch/keb27269/stream_cap/N_leptocephalus/denovo_output/denovo_n_$FNAME
denovo_map.pl --samples /scratch/keb27269/stream_cap/declone_all/N_leptocephalus/ \
--popmap /scratch/keb27269/stream_cap/N_leptocephalus/N_leptocephalus_populationmap.txt \
-o /scratch/keb27269/stream_cap/N_leptocephalus/denovo_output/denovo_n_$FNAME \
--paired -m 3 -n $FNAME -M 3 -t -T 12 \
-X "populations: -r 0.8 --fstats --fasta_strict --vcf --genepop"
done

#for Luxilus_zonistius
for FNAME  in $n
do
mkdir /scratch/keb27269/stream_cap/L_zonistius/denovo_output/denovo_n_$FNAME
denovo_map.pl --samples /scratch/keb27269/stream_cap/declone_all/L_zonistius/ \
--popmap /scratch/keb27269/stream_cap/L_zonistius/L_zonistius_populationmap.txt \
-o /scratch/keb27269/stream_cap/L_zonistius/denovo_output/denovo_n_$FNAME \
--paired -m 3 -n $FNAME -M 3 -t -T 12 \
-X "populations: -r 0.8 --fstats --fasta_strict --vcf --genepop"
done

#for Percina_nigrofasciata
for FNAME  in $n
do
mkdir /scratch/keb27269/stream_cap/P_nigrofasciata/denovo_output/denovo_n_$FNAME
denovo_map.pl --samples /scratch/keb27269/stream_cap/declone_all/P_nigrofasciata/ \
--popmap /scratch/keb27269/stream_cap/P_nigrofasciata/P_nigrofasciata_populationmap.txt \
-o /scratch/keb27269/stream_cap/P_nigrofasciata/denovo_output/denovo_n_$FNAME \
--paired -m 3 -n $FNAME -M 3 -t -T 12 \
-X "populations: -r 0.8 --fstats --fasta_strict --vcf --genepop"
done
