#1/12/16
#mirdeep2_mapper_3files_test.sh
#Testing the mirdeep2 mapper with 3 files for use in testing the mirdeep2 mapper module
#UPDATE 1/21/16: Testing the files using miRDeep2/0.0.5 as a result of multiple errors being recieved from miRDeep2/0.0.7 core module. 

#!/bin/sh  -login
#PBS -l nodes=1:ppn=1:intel14,walltime=0:20:00,mem=3Gb
#PBS -N mapper_miRDeep2_3files_005_test
#PBS -j oe
#PBS -o /mnt/research/pigeqtl/analyses/microRNA/OutputsErrors
#PBS -m a
#PBS -M perrykai@msu.edu

cd /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/8_collapsed_fasta_output_expression_matrix/

module load miRDeep2/0.0.5

mapper.pl /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/8_collapsed_fasta_output_expression_matrix/config_for_mapper_3files.txt -d -c -p /mnt/research/pigeqtl/indexes/allDNA/Sus_scrofa10.2.79/bowtie1_index/ssc_10_2_79_bowtie1_ref -s /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/9_mirdeep2_genome_mapper_output/3_mirna_reads_processed_005_test.fa -t /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/9_mirdeep2_genome_mapper_output/3_mirna_reads_mapped_005_test.arf -m -n -v

qstat -f ${PBS_JOBID}

#New output file:
# desc   total   mapped  unmapped        %mapped %unmapped
# total: 4198305  3186774 1011531 0.759   0.241
# 001: 1210210    895792  314418  0.740   0.260
# 002: 1393661    1065545 328116  0.765   0.235
# 003: 1594434    1225437 368997  0.769   0.231

#Old output file:
#desc   total   mapped  unmapped        %mapped %unmapped
# total: 4198305  3186774 1011531 0.759   0.241
# 001: 1210210    895792  314418  0.740   0.260
# 002: 1393661    1065545 328116  0.765   0.235
# 003: 1594434    1225437 368997  0.769   0.231