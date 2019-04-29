#PBS -S /bin/bash
#PBS -q highmem_q
#PBS -N refmap_streamcap_pilot
#PBS -l nodes=1:ppn=8
#PBS -l walltime=2:00:00:00
#PBS -l mem=200gb
#PBS -M keb27269@uga.edu
#PBS -m abe
#PBS -o $HOME/refmap.out.$PBS_JOBID
#PBS -e $HOME/refmap.err.$PBS_JOBID

basedir="/scratch/keb27269/stream_cap/"
#mkdir $basedir
cd $basedir

module load Stacks/2.3e-foss-2016b
module load BWA/0.7.17-foss-2016b
module load Python/3.5.2-foss-2016b
module load Perl/5.26.0-GCCcore-6.4.0

#! bin/bash
#this protocol is created for PE data that was alredy anaylyzed in process_radtags and edited to run the I_scapularis_3RAD data
####################################################################################################################
#create the directories that are going to be used

#index your reference with burrow wheeler alignment
#time bwa index /scratch/keb27269/stream_cap/ref_genomes/Perca_flavens/GCF_004354835.1_PFLA_1.0_genomic.fna
#time bwa index /scratch/keb27269/stream_cap/ref_genomes/Pimephales_promelas/GCA_000700825.1_FHM_SOAPdenovo_genomic.fna

set -ueo pipefail
SPECIES="N_lutipinnis
N_leptocephalus
L_zonistius
P_nigrofasciata
"

#create directories
for i in $SPECIES
do
mkdir /scratch/keb27269/stream_cap/$i/denovo_output/denovo_n_4_reference
mkdir /scratch/keb27269/stream_cap/$i/denovo_output/denovo_n_4_catalog_new
cp /scratch/keb27269/stream_cap/$i/denovo_output/denovo_n_4/* /scratch/keb27269/stream_cap/$i/denovo_output/denovo_n_4_catalog_new/
rm /scratch/keb27269/stream_cap/$i/denovo_output/denovo_n_4_catalog_new/catalog.fa.gz
rm /scratch/keb27269/stream_cap/$i/denovo_output/denovo_n_4_catalog_new/catalog.calls
done

##create new catalog
#for N_lutipinnis
time bwa mem -M /scratch/keb27269/stream_cap/ref_genomes/Pimephales_promelas/GCA_000700825.1_FHM_SOAPdenovo_genomic.fna /scratch/keb27269/stream_cap/N_lutipinnis/denovo_output/denovo_n_4/catalog.fa.gz | samtools view -b | samtools sort > /scratch/keb27269/stream_cap/N_lutipinnis/denovo_output/denovo_n_4_reference/catalog_loci.bam
stacks-integrate-alignments -P /scratch/keb27269/stream_cap/N_lutipinnis/denovo_output/denovo_n_4/ -B /scratch/keb27269/stream_cap/N_lutipinnis/denovo_output/denovo_n_4_reference/catalog_loci.bam -O /scratch/keb27269/stream_cap/N_lutipinnis/denovo_output/denovo_n_4_catalog_new/

#for N_leptocephalus
time bwa mem -M /scratch/keb27269/stream_cap/ref_genomes/Pimephales_promelas/GCA_000700825.1_FHM_SOAPdenovo_genomic.fna /scratch/keb27269/stream_cap/N_leptocephalus/denovo_output/denovo_n_4/catalog.fa.gz | samtools view -b | samtools sort > /scratch/keb27269/stream_cap/N_leptocephalus/denovo_output/denovo_n_4_reference/catalog_loci.bam
stacks-integrate-alignments -P /scratch/keb27269/stream_cap/N_leptocephalus/denovo_output/denovo_n_4/ -B /scratch/keb27269/stream_cap/N_leptocephalus/denovo_output/denovo_n_4_reference/catalog_loci.bam -O /scratch/keb27269/stream_cap/N_leptocephalus/denovo_output/denovo_n_4_catalog_new/

#for L_zonistius
time bwa mem -M /scratch/keb27269/stream_cap/ref_genomes/Pimephales_promelas/GCA_000700825.1_FHM_SOAPdenovo_genomic.fna /scratch/keb27269/stream_cap/L_zonistius/denovo_output/denovo_n_4/catalog.fa.gz | samtools view -b | samtools sort > /scratch/keb27269/stream_cap/L_zonistius/denovo_output/denovo_n_4_reference/catalog_loci.bam
stacks-integrate-alignments -P /scratch/keb27269/stream_cap/L_zonistius/denovo_output/denovo_n_4/ -B /scratch/keb27269/stream_cap/L_zonistius/denovo_output/denovo_n_4_reference/catalog_loci.bam -O /scratch/keb27269/stream_cap/L_zonistius/denovo_output/denovo_n_4_catalog_new/

#for P_nigrofasciata
time bwa mem -M /scratch/keb27269/stream_cap/ref_genomes/Perca_flavens/GCF_004354835.1_PFLA_1.0_genomic.fna /scratch/keb27269/stream_cap/P_nigrofasciata/denovo_output/denovo_n_4/catalog.fa.gz | samtools view -b | samtools sort > /scratch/keb27269/stream_cap/P_nigrofasciata/denovo_output/denovo_n_4_reference/catalog_loci.bam
stacks-integrate-alignments -P /scratch/keb27269/stream_cap/P_nigrofasciata/denovo_output/denovo_n_4/ -B /scratch/keb27269/stream_cap/P_nigrofasciata/denovo_output/denovo_n_4_reference/catalog_loci.bam -O /scratch/keb27269/stream_cap/P_nigrofasciata/denovo_output/denovo_n_4_catalog_new/
