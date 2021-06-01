#!/bin/bash
#PBS -A UQ-SCI-BiolSci
#PBS -l walltime=05:00:00
#PBS -l select=1:ncpus=15:mem=60GB
#PBS -N snps_feleven_chrnine
cd $PBS_O_WORKDIR

#setting the job population bam paths list
BAMS=/30days/uqakaur3/recombinantpop/arraylists/bam-paths.txt

#setting the target regions (format is contig:start-end)
REGIONS=/30days/uqakaur3/pilot/region/sorted_chr9contig.txt

#setting reference genome and its location
REF=/90days/uqakaur3/Reference/SPD_CN1K_CtgRN.fasta

#declare variables

#filter : will keep SNP above this allele frequency (over all individuals)
MIN_MAF=0.05

#filter : will keep SNP with at least one read for this percentage of individuals
PERCENT_IND=0.5

#filter: will keep SNP with at least a coverage of this factor multiplied by the number of ind - across all ind. usually set 2-4
#times the coverage to remove repeated regions
MAX_DEPTH_FACTOR=3
MIN_DEPTH=1

module load angsd
N_IND=$(wc -l $BAMS | cut -d " " -f 1)
MIN_IND_FLOAT=$(echo "($N_IND * $PERCENT_IND)"| bc -l)
MIN_IND=${MIN_IND_FLOAT%.*}
MAX_DEPTH=$(echo "($N_IND * $MAX_DEPTH_FACTOR)" |bc -l)

echo " Calculate the SAF, MAF and GL for all individuals listed in $BAMS"
echo "keep loci with at leat one read for n individuals = $MIN_IND, which is $PERCENT_IND % of total $N_IND individuals"
echo "filter on allele frequency = $MIN_MAF"

####Calculate the SAF, MAF and GL
## an attempt with -nQueueSize 50 after -P flag : see how it goes??
angsd -P 15 \
-doMaf 1 -dosaf 1 -GL 2 -doGlf 2 -doMajorMinor 1 -doCounts 1 \
-anc $REF -remove_bads 1 -minMapQ 30 -minQ 20 -skipTriallelic 1 \
-minInd $MIN_IND -minMaf $MIN_MAF -setMaxDepth $MAX_DEPTH -setMinDepthInd $MIN_DEPTH \
-b $BAMS \
-rf $REGIONS -out chrnine_variants


#main features
#-P nb of threads -nQueueSize maximum waiting in memory (necesary to optimize CPU usage
# -doMaf 1 (allele frequencies)  -dosaf (prior for SFS) -GL (Genotype likelihood 2 GATK method - export GL in beagle format  -doGLF2) 
# -doMajorMinor 1 use the most frequent allele as major
# -anc provide a ancestral sequence = reference in our case -fold 1 
# -rf (file with the region written) work on a defined region : OPTIONAL
# -b (bamlist) input file
# -out  output file

#main filters
#filter on bam files -remove_bads (remove files with flag above 255) -minMapQ minimum mapquality -minQ (minimum quality of reads?)
#filter on frequency -minInd (minimum number of individuals with at least one read at this locus) we set it to 50%
#filter on allele frequency -minMaf, set to 0.05 

