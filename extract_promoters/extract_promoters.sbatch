#!/usr/bin/env bash


#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=06:00:00
#SBATCH --partition=shas

module load R/4.0.4
set -eu -o pipefail


# Dependencies: samtools,bedtools, R (if is not loaded as a module in HPC)
# Reading required data 
echo These are the vars:


var=300
var1=/projects/diegogc@colostate.edu/talvez/iwgsc_refseqv2.1_assembly.fa
var2=/projects/diegogc@colostate.edu/talvez/iwgsc_HC.gff3


# Extract information for genes from input gff file
awk '/gene/' $var2 > genes.gff

# Run R script to convert gff to bed format
Rscript gff2bed.r

#Generate index for fasta file, details are here: http://www.htslib.org/doc/samtools.html
samtools faidx $var1

#Create a table (from index file) that contains contig/chromosome sizes
cut -f1-2 ${var1}.fai > sizes.chr

#Create bed file that contains locations of promoters
bedtools flank -i genes.bed -g sizes.chr -l $var -r 0 -s > promoters.bed

#Extract promoter regions from fasta file with contigs/chromosomes using bed file
bedtools getfasta -s -fi $var1 -bed promoters.bed -fo promoters.fa -name

echo Results are in promoters.fa file

#Count promoters
result=$(grep -c '^>' promoters.fa)

echo Number of obtained promoters: $result
