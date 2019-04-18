#PBS -S /bin/bash
#PBS -q batch
#PBS -N demultiplex_Llanero
#PBS -l nodes=1:ppn=12:tcgnode
#PBS -l walltime=48:00:00
#PBS -l mem=125gb
#PBS -M njbayonav@gmail.com
#PBS -m abe

cd $PBS_O_WORKDIR

#loading the software in the cluster
module load stacks/2.0beta7

#Running the process_radtagas pipeline
mkdir /lustre1/njbayona/C_intermedius_3RAD/

#Concatenate Plate 1 Replicates (Read 1 and Read 2)
cat /lustre1/njbayona/HiSeq_Dec17_2/demultiplex_i7/Ariel_Plate1_1.1.fq.gz /lustre1/njbayona/HiSeq_Dec17_2/demultiplex_i7/Ariel_Plate1_2.1.fq.gz \
> /lustre1/njbayona/C_intermedius_3RAD/C_intermedius_Plate1.1.fq.gz
cat /lustre1/njbayona/HiSeq_Dec17_2/demultiplex_i7/Ariel_Plate1_1.2.fq.gz /lustre1/njbayona/HiSeq_Dec17_2/demultiplex_i7/Ariel_Plate1_2.2.fq.gz \
> /lustre1/njbayona/C_intermedius_3RAD/C_intermedius_Plate1.2.fq.gz

#Concatenate Plate 2 Replicates (Read 1 and Read 2)
cat /lustre1/njbayona/HiSeq_Dec17_2/demultiplex_i7/Ariel_Plate2_1.1.fq.gz /lustre1/njbayona/HiSeq_Dec17_2/demultiplex_i7/Ariel_Plate2_2.1.fq.gz \
> /lustre1/njbayona/C_intermedius_3RAD/C_intermedius_Plate2.1.fq.gz
cat /lustre1/njbayona/HiSeq_Dec17_2/demultiplex_i7/Ariel_Plate2_1.2.fq.gz /lustre1/njbayona/HiSeq_Dec17_2/demultiplex_i7/Ariel_Plate2_2.2.fq.gz \
> /lustre1/njbayona/C_intermedius_3RAD/C_intermedius_Plate2.2.fq.gz

#Set Loop
set -ueo pipefail
FILE="Plate1
Plate2"

#Run process_radtags on each Plate 
for FNAME in $FILE
do
echo "process_radtags_$FNAME"
mkdir /lustre1/njbayona/C_intermedius_3RAD/demultiplex_$FNAME
process_radtags -P -1 /lustre1/njbayona/C_intermedius_3RAD/C_intermedius_$FNAME.1.fq.gz \
-2 /lustre1/njbayona/C_intermedius_3RAD/C_intermedius_$FNAME.2.fq.gz \
-b /lustre1/njbayona/HiSeq_Dec17_2/demultiplex_i7/$FNAME\_barcodes.txt -q -c --filter_illumina -r -t 140 --inline_inline \
--renz_1 xbaI --renz_2 ecoRI -o /lustre1/njbayona/C_intermedius_3RAD/demultiplex_$FNAME -i gzfastq
done

#Create a folder to move all demultiplexed files
mkdir /lustre1/njbayona/C_intermedius_3RAD/demultiplex_all/

#Copy demultiplexed files into new folder
for FNAME in $FILE
do
cp /lustre1/njbayona/C_intermedius_3RAD/demultiplex_$FNAME/* /lustre1/njbayona/C_intermedius_3RAD/demultiplex_all/
done

#Remove rem files from process radtags
rm /lustre1/njbayona/C_intermedius_3RAD/demultiplex_all/*rem*