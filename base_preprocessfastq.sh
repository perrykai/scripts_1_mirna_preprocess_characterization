#!/bin/sh  -login
#PBS -l nodes=1:ppn=1:intel14,walltime=2:00:00,mem=2Gb
#PBS -N preprocess_2317
#PBS -j oe
#PBS -o /mnt/research/pigeqtl/analyses/microRNA/OutputsErrors/1_preprocess_fastq_files/
#PBS -m a
#PBS -M perrykai@msu.edu
module load cutadapt/1.4.1
module load FASTX/0.0.14
cd /mnt/research/pigeqtl/analyses/microRNA/0_merge_fastq_files/0_merge_fastq_files_output/
cp 2317_merge.fastq.gz /mnt/research/pigeqtl/analyses/microRNA/TempStore/
cd /mnt/research/pigeqtl/analyses/microRNA/TempStore/
gunzip 2317_merge.fastq.gz
cd /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/
fastx_quality_stats -i /mnt/research/pigeqtl/analyses/microRNA/TempStore/2317_merge.fastq -o /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/3_trimfilter_statistics_output/1_raw_fastq_quality_assessment/2317_pretrimqstats.txt -Q33
cutadapt -a TGGAATTCTCGGGTGCCAAGGAACTCCAGTCAC -m 26  -M 38 --info-file=/mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/1_cutadapt_adaptor_trim_size_filter_output/mirinfo/2317_info --rest-file=/mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/1_cutadapt_adaptor_trim_size_filter_output/mirrest/2317_rest --too-long-output=/mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/1_cutadapt_adaptor_trim_size_filter_output/mirtoolong/2317_toolong /mnt/research/pigeqtl/analyses/microRNA/TempStore/2317_merge.fastq -o /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/1_cutadapt_adaptor_trim_size_filter_output/2317_cutadaptout.fastq > /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/1_cutadapt_adaptor_trim_size_filter_output/mirsummary/2317_summary
fastq_quality_filter -q 30 -p 50 -i /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/1_cutadapt_adaptor_trim_size_filter_output/2317_cutadaptout.fastq -o /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/2_fastx_quality_filter_output/2317_fastqfilterout.fastq -v > /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/2_fastx_quality_filter_output/qualityreport/2317_report -Q33
fastx_quality_stats -i /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/2_fastx_quality_filter_output/2317_fastqfilterout.fastq -o /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/3_trimfilter_statistics_output/2_trimmed_filtered_fastq_quality_assessment/2317_posttrimqstats.txt -Q33
cat /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/2_fastx_quality_filter_output/2317_fastqfilterout.fastq | awk '{if(NR%4==2) print length($1)}' | sort -n | uniq -c > /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/4_readlength_distribution_output/2317_readlengthdistfull.txt
fastx_collapser -Q33 -i /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/2_fastx_quality_filter_output/2317_fastqfilterout.fastq -o /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/5_collapsed_fasta_output/2317_collapsed.fa -v > /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/5_collapsed_fasta_output/verbose/2317_verbose.txt
qstat -f ${PBS_JOBID}
cd /mnt/research/pigeqtl/analyses/microRNA/TempStore/
rm 2317_merge.fastq
