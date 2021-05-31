#!/bin/bash
#PBS -A UQ-SCI-BiolSci
#PBS -l walltime=00:30:00
#PBS -l select=1:ncpus=10:mem=4GB
#PBS -N bam-depth-array
#PBS -J 1-62
set -e
set -u
set -o pipefail

#changing to the temporary job directory
cd ${TMPDIR}

#loading the programs
module load samtools

#setting the sample list
SAMPLELIST=/30days/uqakaur3/f_eleven/wgsdata/Agravitropic/agravitropicinds.txt

#setting the sample from the job array
SAMPLE=$(cat ${SAMPLELIST} | tail -n +${PBS_ARRAY_INDEX} | head -1)

#copying the necessary files to the temporary job directory
cp /30days/uqakaur3/f_eleven/sorted_bams/Agravitropic/${SAMPLE}_sorted.bam ${TMPDIR}

#running samtools flagstat
samtools depth -a ${TMPDIR}/${SAMPLE}_sorted.bam | awk '{sum+=$3; sumsq+=$3*$3} END { print sum/NR,"\t", sqrt(sumsq/NR - (sum/NR)**2)}' > ${TMPDIR}/${SAMPLE}_bamdepth.txt

#copying the stats file from the job temporary directory back to the results directory
cp ${TMPDIR}/${SAMPLE}_bamdepth.txt /30days/uqakaur3/f_eleven/sorted_bams/Agravitropic/stats/coveragedepth/
