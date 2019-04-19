#PBS -S /bin/bash
#PBS -q batch
#PBS -N demultiplex_3rad
#PBS -l nodes=1:ppn=12
#PBS -l walltime=48:00:00
#PBS -l mem=125gb
#PBS -M keb27269@uga.edu
#PBS -m abe
#PBS -o $HOME/demultiplex3.out.$PBS_JOBID
#PBS -e $HOME/demultiplex3.err.$PBS_JOBID

basedir="/home/keb27269/projects/stream_cap/"
#mkdir $basedir
cd $basedir

#loading the software in the cluster
module load Stacks/2.3e-foss-2016b

#Running the process_radtagas pipeline
#mkdir /lustre1/njbayona/C_intermedius_3RAD/

#Concatenate Plate 1 Replicates (Read 1 and Read 2)
#cat /lustre1/njbayona/HiSeq_Dec17_2/demultiplex_i7/Ariel_Plate1_1.1.fq.gz /lustre1/njbayona/HiSeq_Dec17_2/demultiplex_i7/Ariel_Plate1_2.1.fq.gz \
#> /lustre1/njbayona/C_intermedius_3RAD/C_intermedius_Plate1.1.fq.gz
#cat /lustre1/njbayona/HiSeq_Dec17_2/demultiplex_i7/Ariel_Plate1_1.2.fq.gz /lustre1/njbayona/HiSeq_Dec17_2/demultiplex_i7/Ariel_Plate1_2.2.fq.gz \
#> /lustre1/njbayona/C_intermedius_3RAD/C_intermedius_Plate1.2.fq.gz

#Concatenate Plate 2 Replicates (Read 1 and Read 2)
#cat /lustre1/njbayona/HiSeq_Dec17_2/demultiplex_i7/Ariel_Plate2_1.1.fq.gz /lustre1/njbayona/HiSeq_Dec17_2/demultiplex_i7/Ariel_Plate2_2.1.fq.gz \
#> /lustre1/njbayona/C_intermedius_3RAD/C_intermedius_Plate2.1.fq.gz
#cat /lustre1/njbayona/HiSeq_Dec17_2/demultiplex_i7/Ariel_Plate2_1.2.fq.gz /lustre1/njbayona/HiSeq_Dec17_2/demultiplex_i7/Ariel_Plate2_2.2.fq.gz \
#> /lustre1/njbayona/C_intermedius_3RAD/C_intermedius_Plate2.2.fq.gz

#Set Loop
set -ueo pipefail
FILE="Karen_3RADs"

#Run process_radtags on each Plate
for FNAME in $FILE
do
echo "process_radtags_$FNAME"
mkdir /scratch/keb27269/stream_cap/demultiplex_$FNAME
process_radtags -P -1 /scratch/keb27269/stream_cap/3rad_data/$FNAME.1.fq.gz \
-2 /scratch/keb27269/stream_cap/3rad_data/$FNAME.2.fq.gz \
-b /scratch/keb27269/stream_cap/$FNAME\_barcodes.txt -q -c --filter_illumina -r -t 140 --inline_inline \
--renz_1 ecoRI --renz_2 nheI -o /scratch/keb27269/stream_cap/demultiplex_$FNAME -i gzfastq
done

#Create a folder to move all demultiplexed files
mkdir /scratch/keb27269/stream_cap/demultiplex_all/

#Copy demultiplexed files into new folder
for FNAME in $FILE
do
cp /scratch/keb27269/stream_cap/demultiplex_$FNAME/* /scratch/keb27269/stream_cap/demultiplex_all/
done

#Remove rem files from process radtags
rm /scratch/keb27269/stream_cap/demultiplex_all/*rem*
