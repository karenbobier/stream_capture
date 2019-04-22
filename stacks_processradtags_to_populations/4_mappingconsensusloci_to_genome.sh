#PBS -S /bin/bash
#PBS -q highmem_q
#PBS -N refmap_I_scapularis
#PBS -l nodes=1:ppn=8
#PBS -l walltime=02:00:00
#PBS -l mem=200gb
#PBS -M keb27269@uga.edu
#PBS -m abe
#PBS -o $HOME/refmap.out.$PBS_JOBID
#PBS -e $HOME/refmap.err.$PBS_JOBID

basedir="/scratch/keb27269/EHS_Class/"
#mkdir $basedir
cd $basedir

module load Stacks/2.3e-foss-2016b
module load BWA/0.7.17-foss-2016b
module load Python/3.5.2-foss-2016b

#! bin/bash
#this protocol is created for PE data that was alredy anaylyzed in process_radtags and edited to run the I_scapularis_3RAD data
####################################################################################################################
#create the directories that are going to be used

#index your reference with burrow wheeler alignment
time bwa index /scratch/keb27269/EHS_Class/GCF_000208615.1_JCVI_ISG_i3_1.0_genomic.fna

#create directories
mkdir /scratch/keb27269/I_scapularis_3RAD/denovo_output/denovo_n_5/reference
mkdir /scratch/keb27269/I_scapularis_3RAD/denovo_output/denovo_n_5/catalog_new
cp /scratch/keb27269/I_scapularis_3RAD/denovo_output/denovo_n_5/* /scratch/keb27269/I_scapularis_3RAD/denovo_output/denovo_n_5/catalog_new/
rm /scratch/keb27269/I_scapularis_3RAD/denovo_output/denovo_n_5/catalog_new/catalog.fa.gz
rm /scratch/keb27269/I_scapularis_3RAD/denovo_output/denovo_n_5/catalog_new/catalog.calls

##create new catalog
time bwa mem -M /scratch/keb27269/EHS_Class/GCF_000208615.1_JCVI_ISG_i3_1.0_genomic.fna /scratch/keb27269/I_scapularis_3RAD/denovo_output/denovo_n_5/catalog.fa.gz | samtools view -b | samtools sort > /scratch/keb27269/I_scapularis_3RAD/denovo_output/denovo_n_5/reference/catalog_loci.bam
stacks-integrate-alignments -P /scratch/keb27269/I_scapularis_3RAD/denovo_output/denovo_n_5/ -B /scratch/keb27269/I_scapularis_3RAD/denovo_output/denovo_n_5/reference/catalog_loci.bam -O /scratch/keb27269/I_scapularis_3RAD/denovo_output/denovo_n_5/catalog_new/
