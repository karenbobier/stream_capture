#PBS -S /bin/bash
#PBS -q batch
#PBS -l nodes=1:ppn=1
#PBS -l mem=40gb
#PBS -N convert_vcf2sfs
#PBS -l walltime=48:00:00
#PBS -M keb27269@uga.edu
#PBS -m abe
#PBS -o $HOME/vcf2sfs.out.$PBS_JOBID
#PBS -e $HOME/vcf2sfs.err.$PBS_JOBID

basedir="/scratch/keb27269/stream_cap/obs_data/"
#mkdir $basedir
cd $basedir

module load Python/2.7.15-foss-2018b
#easysfs needs to run in python2
module load dadi/1.7.0-foss-2018b-Python-2.7.15
#module load       #dadi/2.0.2-foss-2018a-Python-3.6.4
module load matplotlib/2.1.2-fosscuda-2018b-Python-2.7.15
#matplotlib/2.1.2-foss-2018a-Python-3.6.4

export PATH=${HOME}/apps/fastsimcoal2/2.6.0.2:$PATH

#cp easySFS.py ./
chmod 777 easySFS.py


#convert vcf to sfs
#./easySFS -i input.vcf -p pops_file.txt --preview
cd $basedir/L_zonistius/
pwd
./easySFS.py -i populations.snps.vcf -p L_zonistius_populationmap.txt  -a --proj 8,8 -o L_zonistius_sfsfolded --prefix L_zonistius -f --ploidy 2 -v
./easySFS.py -i populations.snps.vcf -p L_zonistius_populationmap.txt  -a --proj 8,8 -o L_zonistius_sfsunfolded --prefix L_zonistius -f --unfolded --ploidy 2 -v
cd $basedir/N_lutipinnis/
pwd
./easySFS.py -i populations.snps.vcf -p N_lutipinnis_populationmap.txt -a --proj 8,8 -o N_lutipinnis_sfsfolded --prefix N_lutipinnis -f --ploidy 2 -v
./easySFS.py -i populations.snps.vcf -p N_lutipinnis_populationmap.txt -a --proj 8,8 -o N_lutipinnis_sfsunfolded --prefix N_lutipinnis -f --unfolded --ploidy 2 -v

cd $basedir/N_leptocephalus/
pwd
./easySFS.py -i populations.snps.vcf -p N_leptocephalus_populationmap.txt -a --proj 8,8 -o N_leptocephalus_sfsfolded --prefix N_leptocephalus -f --ploidy 2 -v
./easySFS.py -i populations.snps.vcf -p N_leptocephalus_populationmap.txt -a --proj 8,8 -o N_leptocephalus_sfsunfolded --prefix N_leptocephalus -f --unfolded --ploidy 2 -v
cd $basedir/P_nigrofasciata
pwd
./easySFS.py -i populations.snps.vcf -p P_nigrofasciata_populationmap.txt -a --proj 8,8 -o P_nigrofasciata_sfsfolded --prefix P_nigrofasciata -f --ploidy 2 -v
./easySFS.py -i populations.snps.vcf -p P_nigrofasciata_populationmap.txt -a --proj 8,8 -o P_nigrofasciata_sfsunfolded --prefix P_nigrofasciata -f --unfolded --ploidy 2 -v

# ##project down to 3 diploids
cd $basedir/L_zonistius/
pwd
./easySFS.py -i populations.snps.vcf -p L_zonistius_populationmap.txt  -a --proj 6,6 -o L_zonistius_sfsfolded_proj3 --prefix L_zonistius -f --ploidy 2 -v
./easySFS.py -i populations.snps.vcf -p L_zonistius_populationmap.txt  -a --proj 6,6 -o L_zonistius_sfsunfolded_proj3 --prefix L_zonistius -f --unfolded --ploidy 2 -v
cd $basedir/N_lutipinnis/
pwd
./easySFS.py -i populations.snps.vcf -p N_lutipinnis_populationmap.txt -a --proj 6,6 -o N_lutipinnis_sfsfolded_proj3 --prefix N_lutipinnis -f --ploidy 2 -v
./easySFS.py -i populations.snps.vcf -p N_lutipinnis_populationmap.txt -a --proj 6,6 -o N_lutipinnis_sfsunfolded_proj3 --prefix N_lutipinnis -f --unfolded --ploidy 2 -v
cd $basedir/N_leptocephalus/
pwd
./easySFS.py -i populations.snps.vcf -p N_leptocephalus_populationmap.txt -a --proj 6,6 -o N_leptocephalus_sfsfolded_proj3 --prefix N_leptocephalus -f --ploidy 2 -v
./easySFS.py -i populations.snps.vcf -p N_leptocephalus_populationmap.txt -a --proj 6,6 -o N_leptocephalus_sfsunfolded_proj3 --prefix N_leptocephalus -f --unfolded --ploidy 2 -v
cd $basedir/P_nigrofasciata
pwd
./easySFS.py -i populations.snps.vcf -p P_nigrofasciata_populationmap.txt -a --proj 6,6 -o P_nigrofasciata_sfsfolded_proj3 --prefix P_nigrofasciata -f --ploidy 2 -v
./easySFS.py -i populations.snps.vcf -p P_nigrofasciata_populationmap.txt -a --proj 6,6 -o P_nigrofasciata_sfsunfoldedproj3 --prefix P_nigrofasciata -f --unfolded --ploidy 2 -v
