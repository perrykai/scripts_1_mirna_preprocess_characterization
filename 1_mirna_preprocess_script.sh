#============================================
#  File:  1_mirna_preprocess_script.sh
#  Directory Code:  /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/scripts/
#  Date:  1/7/16
#  Description:  This code completes all pre-processing steps for the merged samples of smallRNAseq data. The steps are as follows:
#                1. Load modules cutadapt and FASTX
#                2. Copy the raw data from the 0_merge_fastq_files_output directory to the TempStore directory and unzip the files
#                3. Move to the microRNA/1_preprocess_fastq_files directory to begin the analysis
#                4. Use cutadapt to trim the universal adaptor sequence and the length of the reads to between 26-38nt
#                   (This step creates multiple output files useful for further analysis; see output files below)
#                5. Use fastq_quality_filter to filter out the low-quality reads (reads with >50% of nts having Phred <30 are eliminated)
#                6. Use fastx_quality_stats to assess the quality of the samples following analysis
#                7. Use awk to extract the second line from each group of four lines (the sequence line in a .fastq file),
#                   then measure the length of the sequence corresponding to that line (read length), incrementing the array cell
#                   corresponding to that length. When all the lines have been read, it loops over the array to print its content.
#                   (Awk code obtained from Biostars: https://www.biostars.org/p/72433/)
#                8. Use fastx_collapser to collapse the adaptor trimmed and quality filtered .fastq files into .fa files,
#                   while combining duplicated reads into a unique sequence ID with an expression tag.
#                   It also creates a verbose output file containing information on number of input and output sequences
#                   and the number of reads represented. This code is used in the first step of investigating
#                   PCR Duplication in the smallRNA seq data sequenced 1/2015.
#                9. After submitting the job, go back to the TempStore directory and remove the unzipped raw data file.
#============================================
#  Input File Directory:  /mnt/research/pigeqtl/analyses/microRNA/TempStore/ (After each raw data file is copied to this folder and unzipped)

#  Input File(s):  One raw .fastq file for each sample.(From /mnt/research/pigeqtl/analyses/microRNA/0_merge_fastq_files_output directory)

#  Output File Directory: /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/1_cutadapt_adaptor_trim_size_filter_output/mirinfo/
#                         /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/1_cutadapt_adaptor_trim_size_filter_output/mirrest/
#                         /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/1_cutadapt_adaptor_trim_size_filter_output/mirtoolong/
#                         /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/1_cutadapt_adaptor_trim_size_filter_output/mirsummary/
#                         /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/1_cutadapt_adaptor_trim_size_filter_output/
#                         /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/2_fastx_quality_filter_output/
#                         /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/2_fastx_quality_filter_output/qualityreport/
#                         /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/3_trimfilter_statistics_output/1_raw_fastq_quality_assessment/
#                         /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/3_trimfilter_statistics_output/2_trimmed_filtered_fastq_quality_assessment/
#                         /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/4_readlength_distribution_output/
#                         /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/5_collapsed_fasta_output/
#                         /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/5_collapsed_fasta_output/verbose

#  Output File(s): xxxx_pretrimqstats.txt    (output of pre-trim fastx_quality_stats)
#                  xxxx_info                 (output from cutadapt, info file containing information about each read and its adaptor matches)
#                  xxxx_rest                 (output from cutadapt, when the adaptor matches in the middle of a read, the rest of the read is written here)
#                  xxxx_toolong              (output from cutadapt, when the read is too long (>38nt), it is written to this file)
#                  xxxx_cutadaptout.fastq    (output from cutadapt, output .fastq file of the remaining adaptor-trimmed reads meeting length requirements)
#                  xxxx_summary              (output from cutadapt, verbose output for each sample saved to individual files)
#                  xxxx_fastqfilterout.fastq (output from fastq_quality_filter)
#                  xxxx_report               (output from fastq_quality_filter, verbose output file for each sample)
#                  xxxx_posttrimqstats.txt   (output of post-trim and quality filter fastx_quality_stats)
#                  xxxx_readlengthdistfull.txt (One output file for each sample)
#                  xxxx_collapsed.fa         (One output file of collapsed reads for each sample)
#                  xxxx_verbose.txt          (A verbose output file for each collapsed sample)

#============================================
#  Example Output (If Applicable):

# cat 1776_readlengthdistfull.txt
#  26060 26
#  25430 27
#  56990 28
# 130639 29
# 901420 30
# 184506 31
#  45850 32
#  14974 33
#   9901 34
#   9433 35
#   7332 36
#   5944 37
#   6603 38

# head 1776_collapsed.fa
# >1-1333
# GTGCTGGAATGTAAAGAAGTATGTATCTTC
# >2-915
# GTGATGGAATGTAAAGAAGTATGTATCTTC
# >3-846
# GTAATGGAATGTAAAGAAGTATGTATCTTC

# cat 1776_verbose.txt
# Input: 1425082 sequences (representing 1425082 reads)
# Output: 678011 sequences (representing 1425082 reads)
#============================================

f1=(`ls /mnt/research/pigeqtl/analyses/microRNA/0_merge_fastq_files/0_merge_fastq_files_output/ -1|grep gz`)
f2=(`ls /mnt/research/pigeqtl/analyses/microRNA/0_merge_fastq_files/0_merge_fastq_files_output/ -1|grep fastq|cut -f1 -d_`)

cd /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/scripts
  
  for (( i = 0 ; i < ${#f1[@]} ; i++ )) do
    echo '#!/bin/sh  -login' > base_preprocessfastq.sh
    echo '#PBS -l nodes=1:ppn=1:intel14,walltime=2:00:00,mem=2Gb'  >> base_preprocessfastq.sh
    echo '#PBS -N preprocess_'${f2[$i]}  >> base_preprocessfastq.sh
    echo '#PBS -j oe'  >> base_preprocessfastq.sh
    echo '#PBS -o /mnt/research/pigeqtl/analyses/microRNA/OutputsErrors/1_preprocess_fastq_files/'  >> base_preprocessfastq.sh
    echo '#PBS -m a'  >> base_preprocessfastq.sh
    echo '#PBS -M perrykai@msu.edu'  >> base_preprocessfastq.sh
    
    echo 'module load cutadapt/1.4.1'  >> base_preprocessfastq.sh
    echo 'module load FASTX/0.0.14'  >> base_preprocessfastq.sh
    
    echo 'cd /mnt/research/pigeqtl/analyses/microRNA/0_merge_fastq_files/0_merge_fastq_files_output/'  >> base_preprocessfastq.sh
    echo 'cp' ${f1[$i]} '/mnt/research/pigeqtl/analyses/microRNA/TempStore/'  >> base_preprocessfastq.sh
    echo 'cd /mnt/research/pigeqtl/analyses/microRNA/TempStore/'  >> base_preprocessfastq.sh
    echo 'gunzip' ${f1[$i]} >> base_preprocessfastq.sh
    
    echo 'cd /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/'  >> base_preprocessfastq.sh
    
    echo 'fastx_quality_stats -i /mnt/research/pigeqtl/analyses/microRNA/TempStore/'`echo ${f1[$i]}|cut -d. -f1,2` '-o /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/3_trimfilter_statistics_output/1_raw_fastq_quality_assessment/'${f2[$i]}'_pretrimqstats.txt -Q33'  >> base_preprocessfastq.sh
    
    echo 'cutadapt -a TGGAATTCTCGGGTGCCAAGGAACTCCAGTCAC -m 26  -M 38 --info-file=/mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/1_cutadapt_adaptor_trim_size_filter_output/mirinfo/'${f2[$i]}'_info --rest-file=/mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/1_cutadapt_adaptor_trim_size_filter_output/mirrest/'${f2[$i]}'_rest --too-long-output=/mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/1_cutadapt_adaptor_trim_size_filter_output/mirtoolong/'${f2[$i]}'_toolong /mnt/research/pigeqtl/analyses/microRNA/TempStore/'`echo ${f1[$i]}|cut -d. -f1,2` '-o /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/1_cutadapt_adaptor_trim_size_filter_output/'${f2[$i]}'_cutadaptout.fastq > /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/1_cutadapt_adaptor_trim_size_filter_output/mirsummary/'${f2[$i]}'_summary'  >> base_preprocessfastq.sh
    
    echo 'fastq_quality_filter -q 30 -p 50 -i /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/1_cutadapt_adaptor_trim_size_filter_output/'${f2[$i]}'_cutadaptout.fastq -o /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/2_fastx_quality_filter_output/'${f2[$i]}'_fastqfilterout.fastq -v > /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/2_fastx_quality_filter_output/qualityreport/'${f2[$i]}'_report -Q33'  >> base_preprocessfastq.sh
    
    echo 'fastx_quality_stats -i /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/2_fastx_quality_filter_output/'${f2[$i]}'_fastqfilterout.fastq -o /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/3_trimfilter_statistics_output/2_trimmed_filtered_fastq_quality_assessment/'${f2[$i]}'_posttrimqstats.txt -Q33'  >> base_preprocessfastq.sh
    
    echo 'cat /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/2_fastx_quality_filter_output/'${f2[$i]}'_fastqfilterout.fastq | awk '"'{if(NR%4==2) print length("'$1'")}'"' | sort -n | uniq -c > /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/4_readlength_distribution_output/'${f2[$i]}'_readlengthdistfull.txt' >> base_preprocessfastq.sh
    
    echo 'fastx_collapser -Q33 -i /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/2_fastx_quality_filter_output/'${f2[$i]}'_fastqfilterout.fastq -o /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/5_collapsed_fasta_output/'${f2[$i]}'_collapsed.fa -v > /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/5_collapsed_fasta_output/verbose/'${f2[$i]}'_verbose.txt' >> base_preprocessfastq.sh
    
    echo 'qstat -f ${PBS_JOBID}'  >> base_preprocessfastq.sh
    
    echo 'cd /mnt/research/pigeqtl/analyses/microRNA/TempStore/' >> base_preprocessfastq.sh
    echo 'rm' `echo ${f1[$i]}|cut -d. -f1,2`  >> base_preprocessfastq.sh
    
    qsub base_preprocessfastq.sh
    
    done
