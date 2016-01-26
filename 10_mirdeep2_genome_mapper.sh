#============================================
#  File: 10_mirdeep2_genome_mapper.sh
#  Directory Code:  /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/scripts/
#  Date:  1/21/16 #UPDATE: Using miRDeep2/0.0.5 due to errors received when trying to run miRDeep2/0.0.7
#  Description:  This code maps the 174 smallRNA libraries to the sus scrofa reference genome 10.2.79 using miRDeep2 mapper module.
#                1. Uses config file to feed all 174 libraries to mapper module
#                2. Uses bowtie-index of reference genome to map reads using: bowtie –f –n 0 –e 80 –l 18 –a –m 5 –best –strata
#                3. Outputs a file of processed reads, and an .arf format alignment file for use with miRDeep2 core module
#============================================
#  Input File Directory:  /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/8_collapsed_fasta_output_expression_matrix/
#                         /mnt/research/pigeqtl/indexes/allDNA/Sus_scrofa10.2.79/bowtie1_index/

#  Input File(s):   config_for_mapper.txt
#                   (6) genome index files, each using the prefix ssc_10_2_79_bowtie1_ref

#  Output File Directory: /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/8_collapsed_fasta_output_expression_matrix/
#                         /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/9_mirdeep2_genome_mapper_output/

#  Output File(s): 8_collapsed_fasta_output_expression_matrix/mapper.log
#                  8_collapsed_fasta_output_expression_matrix/bowtie.log
#                  9_mirdeep2_genome_mapper_output/174_library_reads_processed.fa
#                  9_mirdeep2_genome_mapper_output/174_library_reads_mapped.arf

#============================================
#  Module used: miRDeep2/0.0.7
#============================================

#!/bin/sh  -login
#PBS -l nodes=1:ppn=1:intel14,walltime=2:00:00,mem=3Gb
#PBS -N 10_174_library_miRDeep2_genome_mapper
#PBS -j oe
#PBS -o /mnt/research/pigeqtl/analyses/microRNA/OutputsErrors
#PBS -m a
#PBS -M perrykai@msu.edu

cd /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/8_collapsed_fasta_output_expression_matrix/

module load miRDeep2/0.0.5

mapper.pl /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/8_collapsed_fasta_output_expression_matrix/config_for_mapper.txt -d -c -p /mnt/research/pigeqtl/indexes/allDNA/Sus_scrofa10.2.79/bowtie1_index/ssc_10_2_79_bowtie1_ref -s /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/9_mirdeep2_genome_mapper_output/174_library_reads_processed.fa -t /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/9_mirdeep2_genome_mapper_output/174_library_reads_mapped.arf -m -n -v

qstat -f ${PBS_JOBID}

