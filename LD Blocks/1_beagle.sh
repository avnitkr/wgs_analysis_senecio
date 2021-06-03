#!/bin/bash
#PBS -A UQ-SCI-BiolSci
#PBS -l walltime=05:00:00
#PBS -l select=1:ncpus=15:mem=60GB
#PBS -N ld_BEAGLE

cd $PBS_O_WORKDIR

#setting the job population bam paths list
BAMS=/30days/uqakaur3/recombinantpop/arraylists/bam-paths.txt

#setting the target regions (format is contig:start-end)
REGIONS=/30days/uqakaur3/pilot/region/sorted_chr9contig.txt

#setting reference genome and its location
REF=/90days/uqakaur3/Reference/SPD_CN1K_CtgRN.fasta

MIN_MAF=0.10 #filter : will keep SNP above this allele frequency (over all individuals)
PERCENT_IND=0.75 #filter : will keep SNP with at least one read for this percentage of individuals
MAX_DEPTH_FACTOR=3 #filter : will keep SNP with less than X time the no of individuals total coverage

#loading ANGSD
module load angsd

N_IND=$(wc -l $BAMS | cut -d " " -f 1)
MIN_IND_FLOAT=$(echo "($N_IND * $PERCENT_IND)"| bc -l)
MIN_IND=${MIN_IND_FLOAT%.*}
MAX_DEPTH=$(echo "($N_IND * $MAX_DEPTH_FACTOR)" |bc -l)


#make a beagle and filter for maf and min ind
angsd -P 15 \
      -dosaf 1 -GL 2 -doGlf 2 -doMaf 1 -doMajorMinor 1 -doCounts 1 \
      -anc $REF -rf $REGIONS \
      -remove_bads 1 -minMapQ 30 -minQ 20 -minInd $MIN_IND -setMaxDepth $MAX_DEPTH -minMaf $MIN_MAF \
      -b $BAMS -out ngsld_chrnine
