#!/bin/bash
#PBS -A UQ-SCI-BiolSci
#PBS -l walltime=07:00:00
#PBS -l select=1:ncpus=15:mem=60GB
#PBS -N chr_nine_assoc

cd $PBS_O_WORKDIR

#setting quantitative phenotype file
PHENO=/30days/uqakaur3/recombinantpop/arraylists/pheno.yquant #this file must be one single column with quantitative phenotype, each line is one individual in the same order as bamfile

#setting the job population bam paths list
BAMS=/30days/uqakaur3/recombinantpop/arraylists/bam-paths.txt

#setting the target regions (format is contig:start-end)
REGIONS=/30days/uqakaur3/pilot/region/sorted_chr9contig.txt

#loading ANGSD
module load angsd

#prepare variables

#filter : will keep SNP above this allele frequency (over all individuals)
MIN_MAF=0.05

#filter : will keep SNP with at least one read for this percentage of individuals
PERCENT_IND=0.5

#filter: will keep SNP with at least a coverage of this factor multiplied by the number of ind - across all ind. usually set 2-4
#times the coverage to remove repeated regions
MAX_DEPTH_FACTOR=3

module load angsd

N_IND=$(wc -l $BAMS| cut -d " " -f 1)
MIN_IND_FLOAT=$(echo "($N_IND * $PERCENT_IND)"| bc -l)
MIN_IND=${MIN_IND_FLOAT%.*}
MAX_DEPTH=$(echo "($N_IND * $MAX_DEPTH_FACTOR)" |bc -l)
MIN_DEPTH=1

##note : Claire used -nQueueSize 50 prior -yQuant $PHENO -- figure out why it is required?
##run a test with -nQueueSize 50

# perform gwas on all samples with option doAsso=4 reports size effects and LRT
angsd -P 15 -rf ${REGIONS} -yQuant $PHENO \
      -doAsso 4 -GL 2 -doPost 1 -doMajorMinor 1 -doMaf 1 -doCounts 1 \
      -remove_bads 1 -minMapQ 30 -minQ 20 -minInd $MIN_IND -minMaf $MIN_MAF -setMaxDepth $MAX_DEPTH -setMinDepthInd $MIN_DEPTH \
      -b $BAMS -out chr_nine.quant.EM.gwas
      
## perform gwas on all samples with option doAsso=2
angsd -P 15 -yQuant $PHENO \
-doAsso 2 -GL 2 -doPost 1 -doMajorMinor 1 -doMaf 1 -doCounts 1 \
-remove_bads 1 -minMapQ 30 -minQ 20 -minInd $MIN_IND -minMaf $MIN_MAF -setMaxDepth $MAX_DEPTH -setMinDepthInd $MIN_DEPTH \
-b $BAMS -out chr_nine.quant.gwas

# perform gwas on all samples with option doAsso=5
angsd -P 15 -yQuant $PHENO \
-doAsso 5 -GL 2 -doPost 1 -doMajorMinor 1 -doMaf 1 -doCounts 1 \
-remove_bads 1 -minMapQ 30 -minQ 20 -minInd $MIN_IND -minMaf $MIN_MAF -setMaxDepth $MAX_DEPTH -setMinDepthInd $MIN_DEPTH \
-b $BAMS -out chr_nine.quant.STEM.gwas
