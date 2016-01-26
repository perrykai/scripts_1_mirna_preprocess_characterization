#====================================================================
#============================================
#  File:  run_8_write_fasta_for_expression_matrix.sh
#  Directory Code:  /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/scripts/
#  Date:  1/11/15
#  Description:  This code submits the 8_write_fasta_for_expression_matrix.R code to the HPC
#============================================

#!/bin/sh  -login
#PBS -l nodes=1:ppn=1:intel14,walltime=1:00:00,mem=2Gb
#PBS -N 8_write_fasta_for_expression_matrix
#PBS -j oe
#PBS -o /mnt/research/pigeqtl/analyses/microRNA/OutputsErrors/
#PBS -m a
#PBS -M perrykai@msu.edu

cd /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/scripts/

R CMD BATCH 8_write_fasta_for_expression_matrix.R

