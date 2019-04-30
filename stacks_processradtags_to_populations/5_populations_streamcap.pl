#PBS -S /bin/bash
#PBS -q highmem_q
#PBS -l nodes=1:ppn=12
#PBS -l mem=200gb
#PBS -N Populations_streamcap
#PBS -M keb27269@uga.edu
#PBS -l walltime=3:00:00:00
#PBS -m abe
#PBS -o $HOME/populations.out.$PBS_JOBID
#PBS -e $HOME/populations.err.$PBS_JOBID

basedir="/scratch/keb27269/stream_cap/"
#mkdir $basedir
cd $basedir

#module load Stacks/2.3b-foss-2016b
module load Stacks/2.3e-foss-2016b
module load Perl/5.26.0-GCCcore-6.4.0

set -ueo pipefail
SPECIES="N_lutipinnis
N_leptocephalus
L_zonistius
P_nigrofasciata
"

for i in $SPECIES
do

mkdir /scratch/keb27269/stream_cap/$i/denovo_output/denovo_n_4_catalog_new/multiple_snp
populations -t 12 -P /scratch/keb27269/stream_cap/$i/denovo_output/denovo_n_4_catalog_new/ -M /scratch/keb27269/stream_cap/$i/$i\_populationmap.txt -O /scratch/keb27269/stream_cap/$i/denovo_output/denovo_n_4_catalog_new/multiple_snp -r 0.6 -p 2 --fasta_loci --fasta_samples --fasta_samples_raw --vcf --fstats --genepop --vcf_haplotypes --phylip --phylip_var --structure --treemix
# -r is proportion f indvs that must have the locus, -p minimum number of populations a locus needs to be present in, other flags for output files. -fstats is for Fst,
mkdir /scratch/keb27269/stream_cap/$i/denovo_output/denovo_n_4_catalog_new/single_snp
#to restrict data analysis to only the first SNP per locus
populations -t 12 -P /scratch/keb27269/stream_cap/$i/denovo_output/denovo_n_4_catalog_new/ -M /scratch/keb27269/stream_cap/$i/$i\_populationmap.txt -O /scratch/keb27269/stream_cap/$i/denovo_output/denovo_n_4_catalog_new/single_snp -r 0.6 -p 2 --fasta_loci --fasta_samples --fasta_samples_raw --vcf --fstats --genepop --vcf_haplotypes --phylip --phylip_var --structure --treemix --write_single_snp

mkdir /scratch/keb27269/stream_cap/$i/denovo_output/denovo_n_4_catalog_new/filter_snp
# more conservative selection of loci, only export loci present in 80% of indvs and have a frequency greater than 5%.
populations -t 12 -P /scratch/keb27269/stream_cap/$i/denovo_output/denovo_n_4_catalog_new/ -M /scratch/keb27269/stream_cap/$i/$i\_populationmap.txt -O /scratch/keb27269/stream_cap/$i/denovo_output/denovo_n_4_catalog_new/filter_snp -r 0.8 -p 2 --min_maf 0.05 --fasta_loci --fasta_samples --fasta_samples_raw --vcf --fstats --genepop --vcf_haplotypes --phylip --phylip_var --structure --treemix

done
