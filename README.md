# small RNAseq Data Analysis Pipeline

**Author:** Kaitlyn Perry

**Date:** 22 Jan 2016

##Table of Contents
1. [Introduction] (#introduction)
2. [Sequencing Overview] (#sequencing-overview)
3. [Bioinformatic Softwares and Parameters Used] (#bioinformatic-softwares-and-parameters-used)
4. [Merging the Raw Fastq Files] (#merging-the-raw-fastq-files) 
5. [Adaptor Trimming, Size- and Quality- Filtering with Cutadapt] (#adaptor-trimming,-size-and-quality-filtering-with-cutadapt)
6. [PCR Duplicate Removal] (#pcr-duplicate-removal)
7. [Mapping Reads to Reference Genome with miRDeep2] (#mapping-reads-to-reference-genome-with-mirdeep2)
8. [Quantification of Known Pig miRNAs, and Prediction of Pig-Novel miRNAs with miRDeep2] (#quantification-of-known-pig-mirnas,-and-prediction-of-pig-novel-mirnas-with-mirdeep2)

##Introduction

This analysis conducts the pre-processing, mapping, and quantification steps for the 174 merged fastq libraries of small RNA sequencing data obtained from total RNA extracted from _Longissimus dorsi_ skeletal muscle tissue from 174 F2 MSU Pig Resource Population pigs. The objectives of this analysis are to a) characterize the small RNAs expressed in the MSU PRP F2s, b) quantify known and predicted pig-novel miRNA for inclusion in a miRNA eQTL analysis. 


##Sequencing Overview

Total RNA was extracted from 176 samples of _Longissimus dorsi_ skeletal muscle from the F2 generation of the MSU PRP using the QIAGEN miRNeasy Mini Kit. Library preparation and sequencing was conducted at the MSU RTSF Genomics Core utilizing the Bioo Scientific NEXTflex Small RNA Sequencing Kit v2. Sequencing was conducted in multiple batches, with the first sequencing data returned in January 2015 and the second in October/November 2015. 

The first batch (Jan 2015) of sequencing contained 152 libraries sequenced in 1x50bp format on the Illumina HiSeq 2500 Platform, with one pool of 38 libraries sequenced on each of four lanes of an Illumina HiSeq 2500 Rapid Run flow cell using Rapid SBS reagents. The first run of sequencing output fewer reads than expected for reasons unknown to the RTSF staff, so these same libraries were re-run with increased concentration of library loaded on the flow cells. The two runs combined returned acceptable total output. Here, three libraries did not produce significant reads: 1491, 1811, and 1831. Libraries 1811 and 1831 had actually failed library preparation the first time through, and after not prouducing significant reads after two runs of sequencing were removed from the experiment. 

The second batch (Oct/Nov 2015) of sequencing contained 27 libraries; 24 of which were previously sequenced in June of 2013 using the Illumina TruSeq Small RNA Sample Preparation Kit, and three libraries that were chosen for re-sequencing from the previous batch of sequencing (1449, 1491, and 2231). These libraries were prepared for sequencing as before, using the Bioo Scientific NEXTflex Small RNA Preparation Kit v2. The 27 libraries were pooled and sequenced on one lane of an Illumina HiSeq 2500 Rapid Run flow cell in a 1x50bp single-read format using Rapid SBS reagents. Preliminary examination of this data revealed that a substantial fraction of the reads were adapter dimers (65 - 85% per library), for reasons unknown to the MSU RTSF staff. The same pool of 27 libraries was re-run the same as before, but this time on one lane of an Illumina HiSeq 2500 High Output flow cell (v4). The total number of reads from this run was ~2x higher than before, but there remained a significant amount of adapter dimers (45 - 75% per library). A preliminary pre-processing analysis (adaptor trimming, size- and quality- filtering) was conducted on this data to assess the quality of sequencing, and it was determined that a sufficient amount of quality reads was obtained from the combined sequencing runs for the 27 libraries. 

Combined, there are a total of 174 libraries of quality small RNA sequencing data for use in miRNA characterizaiton and eQTL analyses. 


##Bioinformatic Softwares and Parameters Used


|Software Used           | Parameters Used         | Function       |
|:----------------       | :------------------     | :--------------|
|[Fastx Toolkit/0.0.14](http://hannonlab.cshl.edu/fastx_toolkit/commandline.html): `fastx_quality_stats`   | `-i [input] -o [output] -Q33` | Pre- and post- trimming/filtering quality statistics
|[Cutadapt/1.4.1](http://cutadapt.readthedocs.org/en/stable/guide.html): `cutadapt`| `-a [adaptor seq] -m 26 -M 38 --info-file --rest-file --too-long-output -o` | Adaptor trimming, size filtering reads
|Fastx Toolkit/0.0.14: `fastq_quality_filter`  | `-q 30 -p 50 -i [input] -o [output] -v > [verbose] -Q33` | Filter reads for low quality |
|Fastx Toolkit/0.0.14: `fastx_collapser`| `-Q33 -i [input] -o [output] -v [verbose]` | Collapse adaptor-trimmed, quality- and size-filtered reads to obtain unique sequences with sequence ID and read count tag
| [miRDeep2/0.0.5](https://www.mdc-berlin.de/36105849/en/research/research_teams/systems_biology_of_gene_regulatory_elements/projects/miRDeep/documentation): `mapper.pl` | `[input] -d -c -p [ref_genome] -s [processed.fa] -t [mapped.arf] -m -n -v`| Map the small RNA sequencing reads to the Sus scrofa reference genome (v 10.2.79) |
| miRDeep2/0.0.5: `mirdeep2.pl` | `[processed.fa] [ref_genome] [mapped.arf] [ssc_mature_miR.fa] [hsa_mature_miR.fa] [ssc_hairpin2.fa] 2> [report.log]` | Quantify known, predict pig-novel miRNA |


##Merging the Raw Fastq Files

The scripts used for this portion of the analysis are located in the directory `/mnt/research/pigeqtl/analyses/microRNA/0_merge_fastq_files/scripts`. An example of one of these scripts is shown below. These scripts merge the two fastq files output from sequencing for each library into one large fastq file. The procedure is as follows:

1. Move into the raw data directory for each run of sequencing
2. Copy the raw data from the datasets directory to their respective TempStore directory and unzip the files
3. Move to the 0_merge_fastq_files/0_merge_fastq_files_output/ directory to begin the analysis
4. Use cat to print the first file and the second file, and merge the fastq files into one large, merged fastq file
5. Use gzip to zip the now merged fastq file (xxxx_merge.fastq)
6. Go back into each respective TempStore directory and remove the unzipped fastq file

```
f1=(`ls /mnt/research/pigeqtl/datasets/20150113_A_smRNA/raw/ -1|grep gz`)
f2=(`ls /mnt/research/pigeqtl/datasets/20150113_A_smRNA/raw/ -1|grep fastq|cut -f1 -d_`)

cd /mnt/research/pigeqtl/analyses/microRNA/0_merge_fastq_files/scripts/

echo '
#!/bin/sh  -login
#PBS -l nodes=1:ppn=1:intel14,walltime=4:00:00,mem=4Gb
#PBS -N merge_A
#PBS -j oe
#PBS -o /mnt/research/pigeqtl/analyses/microRNA/OutputsErrors/merge_A/
#PBS -m a
#PBS -M perrykai@msu.edu

cd /mnt/research/pigeqtl/analyses/microRNA/0_merge_fastq_files/0_merge_fastq_files_output/' > basemerge_A.sh

for ((i=0; i<${#f1[@]} ; i++ )) do
echo '
cd /mnt/research/pigeqtl/datasets/20150113_A_smRNA/raw/
cp '${f1[$i]}' /mnt/research/pigeqtl/analyses/microRNA/TempStore/20150113_A/
cd /mnt/research/pigeqtl/analyses/microRNA/TempStore/20150113_A/
gunzip '${f1[$i]}'

cd /mnt/research/pigeqtl/datasets/20150130_A_smRNA/raw/
cp '${f1[$i]}' /mnt/research/pigeqtl/analyses/microRNA/TempStore/20150130_A/
cd /mnt/research/pigeqtl/analyses/microRNA/TempStore/20150130_A/
gunzip '${f1[$i]}'

cd /mnt/research/pigeqtl/analyses/microRNA/0_merge_fastq_files/0_merge_fastq_files_output/
cat /mnt/research/pigeqtl/analyses/microRNA/TempStore/20150113_A/'`echo ${f1[$i]}|cut -d. -f1,2`' /mnt/research/pigeqtl/analyses/microRNA/TempStore/20150130_A/'`echo ${f1[$i]}|cut -d. -f1,2`' > /mnt/research/pigeqtl/analyses/microRNA/0_merge_fastq_files/0_merge_fastq_files_output/'${f2[$i]}'_merge.fastq

gzip '${f2[$i]}'_merge.fastq

cd /mnt/research/pigeqtl/analyses/microRNA/TempStore/20150113_A/
rm '`echo ${f1[$i]}|cut -d. -f1,2`'

cd /mnt/research/pigeqtl/analyses/microRNA/TempStore/20150130_A/
rm '`echo ${f1[$i]}|cut -d. -f1,2`'
```

The output from these scripts is one fastq file containing the 'raw' reads output from sequencing conducted by the MSU RTSF staff. In total, there are 174 libraries of quality sequencing reads. Each output file is formatted as `xxxx_merge.fastq`, with the `xxxx` indicating the library ID, which corresponds to the MSU PRP F2 pig ID. 




