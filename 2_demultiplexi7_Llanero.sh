#PBS -S /bin/bash
#PBS -q batch
#PBS -N HiSeqDec17_2_demultiplexi7
#PBS -l nodes=1:ppn=12:AMD
#PBS -l walltime=48:00:00
#PBS -l mem=60gb
#PBS -M njbayonav@gmail.com
#PBS -m abe

cd $PBS_O_WORKDIR

#loading the software in the cluster
module load stacks/2.0beta7

#Running the process_radtagas pipeline

mkdir /lustre1/njbayona/HiSeq_Dec17_2/demultiplex_i7

process_radtags -P -1 /lustre1/njbayona/HiSeq_Dec17_2/Data/Intensities/BaseCalls/Undetermined_S0_R1_001.fastq.gz -2 /lustre1/njbayona/HiSeq_Dec17_2/Data/Intensities/BaseCalls/Undetermined_S0_R2_001.fastq.gz -b /lustre1/njbayona/HiSeq_Dec17_2/i7_tags_2.txt -r --index_null --disable_rad_check --retain_header -o /lustre1/njbayona/HiSeq_Dec17_2/demultiplex_i7 -i gzfastq

