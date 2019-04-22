#!/bin/bash
#PBS -q batch
#PBS -l nodes=1:ppn=12:tcgnode
#PBS -N bcl2fastq_HiSeqDec2017_2
#PBS -l walltime=48:00:00
#PBS -l mem=100gb
#PBS -M njbayonav@gmail.com
#PBS -m abe

cd $PBS_O_WORKDIR
module load bcl2fastq/2.17.1.14
time bcl2fastq --input-dir /lustre1/njbayona/HiSeq_Dec17_2/Data/Intensities/BaseCalls/ --output-dir /lustre1/njbayona/HiSeq_Dec17_2/Data/Intensities/BaseCalls/ \
--use-bases-mask y*,i*,i*,y* --sample-sheet /lustre1/njbayona/HiSeq_Dec17_2/SampleSheet_Llanero.csv --no-lane-splitting --ignore-missing-positions --ignore-missing-filter --ignore-missing-bcl --tiles s_[6] -r 4 -d 4 -p 4 -w 4 --create-fastq-for-index-reads