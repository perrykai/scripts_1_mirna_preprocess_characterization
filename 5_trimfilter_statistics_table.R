#============================================
    #  File:  5_trimfilter_statistics_table.R
    #  Directory Code:  /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/scripts/
    #  Date:  1/9/15
    #  Description:  Building a table of summary statistics from QC data obtained from cutadapt and fastq_quality_filter output.
    #                This analysis is for the 174 merged fastq files.
    #                First, create a data.frame from the cutadapt adaptor trim step.
    #                Columns: FileName         RawReads        TooShort        TooLong         Remaining       PropRemaining   PropRawLibraryTotal     PropRemainingLibraryTotal
    #                All can be obtained from the Cutadapt Summary (mirsummary), and the remaining and proportions can be calculated in R.
    #                Then, create a data.frame from the Fastq_qual_filter report (qualreport).
    #                Columns: FileName         Input   Discarded       Output  PropReadsRemaining      RawReadsCutadapt        PropRawReadsCutadapt    PropProcessedLibraryTotal
    #                Where PropReadsRemaining is the proportion of Output compared to Input reads
    #                PropRawReadsCutadapt is the proportion of reads reamining versus the raw reads (before adaptor trimming)
    #                and PropProcessedLibraryTotal is the Proportion of Processed Reads per Library vs Total Processed Reads
    
    #============================================
    #  Input File Directory:  /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/1_cutadapt_adaptor_trim_size_filter_output/mirsummary/
    #                         /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/2_fastx_quality_filter_output/qualityreport/
    
    #  Input File(s):  One mirsummary report for each input .fastq file
    #                  One qualreport file for each input .fastq file
    
    #  Output File Directory: /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/5_trimfilter_statistics_table_output
    
    #  Output File(s): cutadapt_adaptor_trim_stats_table.txt
    #                  fastx_quality_filter_stats_table.txt
    
    #============================================
    #  Module used: R/3.1.0
    #============================================
    #  Example Output (If Applicable):
    #     CutadaptStats20150113_A.txt:
    #          FileName        RawReads        TooShort        TooLong         Remaining       Prop                    PropTotal
    # 1        1036_summary:   2780459         1548287         35367           1196805         0.430434327569657       0.0145192839116218
    # 2        1041_summary:   2740692         1225785         60525           1454382         0.530662329076014       0.0143116245419589
    #     FastxqfStats20150113_A.txt:
    #          FileName        Input      Discarded     Output         PropInput               RawReadsCA      PropRaw                 PropProcess
    # 1        1036_report:    1196805         1497    1195308         0.998749169664231       2780459         0.429895927255176       0.00934567652843302
    # 2        1041_report:    1454382         1887    1452495         0.998702541698123       2740692         0.529973816831661       0.011356527714335
    
    #============================================
    
    #To extract the Raw Reads, use the processed reads from cutadapt report (mirsummary):
    cd /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/1_cutadapt_adaptor_trim_size_filter_output/mirsummary/
      grep "Processed reads" *> processed_reads.txt
    
    #Extract the TooShort Reads:
      grep "Too short reads" * > tooshort_reads.txt
    
    #Extract the TooLong Reads:
      grep "Too long reads" * > toolong_reads.txt
    
    #All the above files saved in the directory /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/1_cutadapt_adaptor_trim_size_filter_output/mirsummary/
    
    #====================================================================
    #Create a data.frame of summary statistics for Cutadapt output:
    #====================================================================
    #Now, in R, reading the data in as data.frames to compile into one large data.frame.
    R
    rm(list=ls())
    setwd("/mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/1_cutadapt_adaptor_trim_size_filter_output/mirsummary/")
    input <- read.table("processed_reads.txt")
    head(input)
    #              V1        V2     V3       V4
    # 1 1034_summary: Processed reads: 16767484
    # 2 1036_summary: Processed reads:  6448459
    # 3 1041_summary: Processed reads:  6367233
    # 4 1049_summary: Processed reads:  5844520
    # 5 1058_summary: Processed reads: 15701994
    # 6 1060_summary: Processed reads:  6551187

    tooshort <- read.table("tooshort_reads.txt")
    head(tooshort)
    #              V1  V2    V3     V4      V5     V6 V7        V8     V9
    # 1 1034_summary: Too short reads: 9523967 (56.8% of processed reads)
    # 2 1036_summary: Too short reads: 3576629 (55.5% of processed reads)
    # 3 1041_summary: Too short reads: 2833824 (44.5% of processed reads)
    # 4 1049_summary: Too short reads: 1359873 (23.3% of processed reads)
    # 5 1058_summary: Too short reads: 9537721 (60.7% of processed reads)
    # 6 1060_summary: Too short reads: 2261263 (34.5% of processed reads)

    toolong <- read.table("toolong_reads.txt")
    head(toolong)
    #              V1  V2   V3     V4     V5    V6 V7        V8     V9
    # 1 1034_summary: Too long reads: 169798 (1.0% of processed reads)
    # 2 1036_summary: Too long reads:  84331 (1.3% of processed reads)
    # 3 1041_summary: Too long reads: 143510 (2.3% of processed reads)
    # 4 1049_summary: Too long reads: 233191 (4.0% of processed reads)
    # 5 1058_summary: Too long reads: 185482 (1.2% of processed reads)
    # 6 1060_summary: Too long reads: 294477 (4.5% of processed reads)
  
    #Extract correct columns from data.frame:
    input2<-input[,c("V1","V4")]
    head(input2)
    #              V1       V4
    # 1 1034_summary: 16767484
    # 2 1036_summary:  6448459
    # 3 1041_summary:  6367233
    # 4 1049_summary:  5844520
    # 5 1058_summary: 15701994
    # 6 1060_summary:  6551187

    #Rename columns of data.frame:
    colnames(input2)<- c("FileName","RawReads")
    head(input2)
    #        FileName RawReads
    # 1 1034_summary: 16767484
    # 2 1036_summary:  6448459
    # 3 1041_summary:  6367233
    # 4 1049_summary:  5844520
    # 5 1058_summary: 15701994
    # 6 1060_summary:  6551187

    #Now, if I set up the other two data.frames similarly, I can merge them all together,
    #Double checking that the order of the files remains the same throughout.
    #Preparing TooShort data.frame:
    tooshort2<-tooshort[,c("V1","V5")]
    head(tooshort2)
    #              V1      V5
    # 1 1034_summary: 9523967
    # 2 1036_summary: 3576629
    # 3 1041_summary: 2833824
    # 4 1049_summary: 1359873
    # 5 1058_summary: 9537721
    # 6 1060_summary: 2261263

    colnames(tooshort2)<- c("FileName","TooShort")
    head(tooshort2)
    #        FileName TooShort
    # 1 1034_summary:  9523967
    # 2 1036_summary:  3576629
    # 3 1041_summary:  2833824
    # 4 1049_summary:  1359873
    # 5 1058_summary:  9537721
    # 6 1060_summary:  2261263
    
    #Preparing TooLong data.frame:
    toolong2<-toolong[,c("V1","V5")]
    head(toolong2)
    #              V1     V5
    # 1 1034_summary: 169798
    # 2 1036_summary:  84331
    # 3 1041_summary: 143510
    # 4 1049_summary: 233191
    # 5 1058_summary: 185482
    # 6 1060_summary: 294477

    colnames(toolong2)<- c("FileName","TooLong")
    head(toolong2)
    #        FileName TooLong
    # 1 1034_summary:  169798
    # 2 1036_summary:   84331
    # 3 1041_summary:  143510
    # 4 1049_summary:  233191
    # 5 1058_summary:  185482
    # 6 1060_summary:  294477
    
    #Now, merge the three data.frames, ensuring the file names stay in the correct order
    merge1<-merge(input2,tooshort2,by="FileName")
    head(merge1)
    #        FileName RawReads TooShort
    # 1 1034_summary: 16767484  9523967
    # 2 1036_summary:  6448459  3576629
    # 3 1041_summary:  6367233  2833824
    # 4 1049_summary:  5844520  1359873
    # 5 1058_summary: 15701994  9537721
    # 6 1060_summary:  6551187  2261263
    
    merge2<-merge(merge1,toolong2,by="FileName")
    head(merge2)
    #        FileName RawReads TooShort TooLong
    # 1 1034_summary: 16767484  9523967  169798
    # 2 1036_summary:  6448459  3576629   84331
    # 3 1041_summary:  6367233  2833824  143510
    # 4 1049_summary:  5844520  1359873  233191
    # 5 1058_summary: 15701994  9537721  185482
    # 6 1060_summary:  6551187  2261263  294477

    #Then, calculate the Remaining reads (RawReads - TooShort - TooLong) column
    merge2$Remaining<-(merge2$RawReads-merge2$TooShort-merge2$TooLong)
    head(merge2)
    #       FileName RawReads TooShort TooLong Remaining
    # 1 1034_summary: 16767484  9523967  169798   7073719
    # 2 1036_summary:  6448459  3576629   84331   2787499
    # 3 1041_summary:  6367233  2833824  143510   3389899
    # 4 1049_summary:  5844520  1359873  233191   4251456
    # 5 1058_summary: 15701994  9537721  185482   5978791
    # 6 1060_summary:  6551187  2261263  294477   3995447    

    #Now, calculate the proportion of RemainingReads compared to RawReads (Remaining/RawReads)
    merge2$PropRemaining<-(merge2$Remaining/merge2$RawReads)
    head(merge2)
    #        FileName RawReads TooShort TooLong Remaining PropRemaining
    # 1 1034_summary: 16767484  9523967  169798   7073719     0.4218712
    # 2 1036_summary:  6448459  3576629   84331   2787499     0.4322737
    # 3 1041_summary:  6367233  2833824  143510   3389899     0.5323975
    # 4 1049_summary:  5844520  1359873  233191   4251456     0.7274260
    # 5 1058_summary: 15701994  9537721  185482   5978791     0.3807664
    # 6 1060_summary:  6551187  2261263  294477   3995447     0.6098814      
    
    #Range of proportion of reads kept after Adaptor Trimming:
    range(merge2$PropRemaining)
    #[1] 0.1439923 0.8822987
    
    mean(merge2$PropRemaining)
    #[1] 0.5945497
    
    sd(merge2$PropRemaining)
    #[1] 0.163726
    
    #==========================================================
    #Creating a column of the proportion of each library vs total number of reads
    #This column will be added to both CutadaptStats and FastxqfStats
    #Fastxqfstats having a column of Proportion of Processed Reads vs Total Processed Reads
    #==========================================================
    
    #In the summary report, also want the proportion of raw reads in each library/total raw reads!
    sum(merge2$RawReads)
    # [1] 1206713706    
    
    sum(merge2$Remaining)
    # [1] 642117942

    merge2$PropRawLibraryTotal<-(merge2$RawReads/(sum(merge2$RawReads)))
    head(merge2)
    #        FileName RawReads TooShort TooLong Remaining PropRemaining
    # 1 1034_summary: 16767484  9523967  169798   7073719     0.4218712
    # 2 1036_summary:  6448459  3576629   84331   2787499     0.4322737
    # 3 1041_summary:  6367233  2833824  143510   3389899     0.5323975
    # 4 1049_summary:  5844520  1359873  233191   4251456     0.7274260
    # 5 1058_summary: 15701994  9537721  185482   5978791     0.3807664
    # 6 1060_summary:  6551187  2261263  294477   3995447     0.6098814   
    #   PropRawLibraryTotal
    # 1         0.013895163
    # 2         0.005343818
    # 3         0.005276507
    # 4         0.004843336
    # 5         0.013012195
    # 6         0.005428949 
    
    merge2$PropRemainingLibraryTotal<-(merge2$Remaining/(sum(merge2$Remaining)))
    head(merge2)
    #        FileName RawReads TooShort TooLong Remaining PropRemaining
    # 1 1034_summary: 16767484  9523967  169798   7073719     0.4218712
    # 2 1036_summary:  6448459  3576629   84331   2787499     0.4322737
    # 3 1041_summary:  6367233  2833824  143510   3389899     0.5323975
    # 4 1049_summary:  5844520  1359873  233191   4251456     0.7274260
    # 5 1058_summary: 15701994  9537721  185482   5978791     0.3807664
    # 6 1060_summary:  6551187  2261263  294477   3995447     0.6098814
    #   PropRawLibraryTotal PropRemainingLibraryTotal
    # 1         0.013895163               0.011016230
    # 2         0.005343818               0.004341101
    # 3         0.005276507               0.005279247
    # 4         0.004843336               0.006620989
    # 5         0.013012195               0.009311048
    # 6         0.005428949               0.006222295    

    #Save this file:
    write.table(merge2, file = "/mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/5_trimfilter_statistics_table_output/cutadapt_adaptor_trim_stats_table.txt", quote = FALSE, sep = "\t ", col.names = TRUE)

    #This .txt file saved to /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/5_trimfilter_statistics_table_output/
    
    q()
    
    #====================================================================
    #Create a summary statistics table for Fastq_qual_Filter Data:
    #====================================================================
    cd /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/2_fastx_quality_filter_output/qualityreport/
    
    #Now, to follow the same procedure with the Fastq_qual_filter report to obtain the statistics there:
    grep Output * >output_reads_fastx_quality_filter.txt
    grep Input * >input_reads_fastx_quality_filter.txt
    grep discarded * >discarded_reads_fastx_quality_filter.txt
    
    #Now, build the table in R:
    #Input/Read files:
    R
    rm(list=ls())
    setwd("/mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/2_fastx_quality_filter_output/qualityreport/")
    
    inputqf<-read.table("input_reads_fastx_quality_filter.txt")
    head(inputqf)
    #                   V1      V2     V3
    # 1 1034_report:Input: 7073719 reads.
    # 2 1036_report:Input: 2787499 reads.
    # 3 1041_report:Input: 3389899 reads.
    # 4 1049_report:Input: 4251456 reads.
    # 5 1058_report:Input: 5978791 reads.
    # 6 1060_report:Input: 3995447 reads.

    discardqf<-read.table("discarded_reads_fastx_quality_filter.txt")
    head(discardqf)
    #                      V1    V2   V3          V4     V5
    # 1 1034_report:discarded 42078 (0%) low-quality reads.
    # 2 1036_report:discarded  4283 (0%) low-quality reads.
    # 3 1041_report:discarded  5289 (0%) low-quality reads.
    # 4 1049_report:discarded  6412 (0%) low-quality reads.
    # 5 1058_report:discarded 39465 (0%) low-quality reads.
    # 6 1060_report:discarded  5866 (0%) low-quality reads.

    outputqf<-read.table("output_reads_fastx_quality_filter.txt")
    head(outputqf)
    #                    V1      V2     V3
    # 1 1034_report:Output: 7031641 reads.
    # 2 1036_report:Output: 2783216 reads.
    # 3 1041_report:Output: 3384610 reads.
    # 4 1049_report:Output: 4245044 reads.
    # 5 1058_report:Output: 5939326 reads.
    # 6 1060_report:Output: 3989581 reads.

    #Trim needed columns and names of files for merging:
    
    #For this analysis, I only need $V1 and $V2 from each file. The rest can be discarded.
    #Input file:
    inputqf2<-inputqf[,c("V1","V2")]
    head(inputqf2)
    #                   V1      V2
    # 1 1034_report:Input: 7073719
    # 2 1036_report:Input: 2787499
    # 3 1041_report:Input: 3389899
    # 4 1049_report:Input: 4251456
    # 5 1058_report:Input: 5978791
    # 6 1060_report:Input: 3995447

    colnames(inputqf2)<- c("FileName","Input")
    head(inputqf2)
    #             FileName   Input
    # 1 1034_report:Input: 7073719
    # 2 1036_report:Input: 2787499
    # 3 1041_report:Input: 3389899
    # 4 1049_report:Input: 4251456
    # 5 1058_report:Input: 5978791
    # 6 1060_report:Input: 3995447
    
    #Discard File:
    discardqf2<-discardqf[,c("V1","V2")]
    head(discardqf2)
    #                      V1    V2
    # 1 1034_report:discarded 42078
    # 2 1036_report:discarded  4283
    # 3 1041_report:discarded  5289
    # 4 1049_report:discarded  6412
    # 5 1058_report:discarded 39465
    # 6 1060_report:discarded  5866

    colnames(discardqf2)<- c("FileName","Discarded")
    head(discardqf2)
    #                FileName Discarded
    # 1 1034_report:discarded     42078
    # 2 1036_report:discarded      4283
    # 3 1041_report:discarded      5289
    # 4 1049_report:discarded      6412
    # 5 1058_report:discarded     39465
    # 6 1060_report:discarded      5866
    
    #Output File:
    outputqf2<-outputqf[,c("V1","V2")]
    head(outputqf2)
    #                    V1      V2
    # 1 1034_report:Output: 7031641
    # 2 1036_report:Output: 2783216
    # 3 1041_report:Output: 3384610
    # 4 1049_report:Output: 4245044
    # 5 1058_report:Output: 5939326
    # 6 1060_report:Output: 3989581

    colnames(outputqf2)<- c("FileName","Output")
    head(outputqf2)
    #              FileName  Output
    # 1 1034_report:Output: 7031641
    # 2 1036_report:Output: 2783216
    # 3 1041_report:Output: 3384610
    # 4 1049_report:Output: 4245044
    # 5 1058_report:Output: 5939326
    # 6 1060_report:Output: 3989581

    #Now I need to trim the text in the file name after "_report:" to merge the files
    #Example using outputqf2 file:
    outputqf3<-as.data.frame(sapply(outputqf2,gsub,pattern="Output:",replacement=""))
    head(outputqf3)
    #       FileName  Output
    # 1 1034_report: 7031641
    # 2 1036_report: 2783216
    # 3 1041_report: 3384610
    # 4 1049_report: 4245044
    # 5 1058_report: 5939326
    # 6 1060_report: 3989581

    #Repeat this step with the other two files:
    inputqf3<-as.data.frame(sapply(inputqf2,gsub,pattern="Input:",replacement=""))
    head(inputqf3)
    #       FileName   Input
    # 1 1034_report: 7073719
    # 2 1036_report: 2787499
    # 3 1041_report: 3389899
    # 4 1049_report: 4251456
    # 5 1058_report: 5978791
    # 6 1060_report: 3995447

    discardqf3<-as.data.frame(sapply(discardqf2,gsub,pattern="discarded",replacement=""))
    head(discardqf3)
    #       FileName Discarded
    # 1 1034_report:     42078
    # 2 1036_report:      4283
    # 3 1041_report:      5289
    # 4 1049_report:      6412
    # 5 1058_report:     39465
    # 6 1060_report:      5866

    #Merge the files to create one data.frame:
    #Now that the FileNames match, I can merge the three files into one data.frame
    mergeqf1<-merge(inputqf3,discardqf3,by="FileName")
    head(mergeqf1)
    #       FileName   Input Discarded
    # 1 1034_report: 7073719     42078
    # 2 1036_report: 2787499      4283
    # 3 1041_report: 3389899      5289
    # 4 1049_report: 4251456      6412
    # 5 1058_report: 5978791     39465
    # 6 1060_report: 3995447      5866

    mergeqf2<-merge(mergeqf1,outputqf3,by="FileName")
    head(mergeqf2)
    #       FileName   Input Discarded  Output
    # 1 1034_report: 7073719     42078 7031641
    # 2 1036_report: 2787499      4283 2783216
    # 3 1041_report: 3389899      5289 3384610
    # 4 1049_report: 4251456      6412 4245044
    # 5 1058_report: 5978791     39465 5939326
    # 6 1060_report: 3995447      5866 3989581

    #Add additional columns of information (Proportions):
    #Next, add a column of PropInput, the Proportion of the Output compared to the Proportion of Reads Input
    #Need to convert columns 2-4 to numeric, by first converting to character
    mergeqf2[,2]<-as.numeric(as.character(mergeqf2[,2]))
    mergeqf2[,3]<-as.numeric(as.character(mergeqf2[,3]))
    mergeqf2[,4]<-as.numeric(as.character(mergeqf2[,4]))
    head(mergeqf2)
    #       FileName   Input Discarded  Output
    # 1 1034_report: 7073719     42078 7031641
    # 2 1036_report: 2787499      4283 2783216
    # 3 1041_report: 3389899      5289 3384610
    # 4 1049_report: 4251456      6412 4245044
    # 5 1058_report: 5978791     39465 5939326
    # 6 1060_report: 3995447      5866 3989581

    mergeqf2$PropReadsRemaining<-(mergeqf2$Output/mergeqf2$Input)
    head(mergeqf2)
    #       FileName   Input Discarded  Output PropReadsRemaining
    # 1 1034_report: 7073719     42078 7031641          0.9940515
    # 2 1036_report: 2787499      4283 2783216          0.9984635
    # 3 1041_report: 3389899      5289 3384610          0.9984398
    # 4 1049_report: 4251456      6412 4245044          0.9984918
    # 5 1058_report: 5978791     39465 5939326          0.9933992
    # 6 1060_report: 3995447      5866 3989581          0.9985318
    
    mean(mergeqf2$Output)
    # [1] 3681716
    range(mergeqf2$Output)
    # [1] 1144305 8155450

    #I believe I can then calculate the Proportion of Raw Reads
    #By dividing Output here by "RawReads" column from CutadaptStats.txt
    cutadaptstats<-read.table("/mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/5_trimfilter_statistics_table_output/cutadapt_adaptor_trim_stats_table.txt")
    head(cutadaptstats)
    #       FileName RawReads TooShort TooLong Remaining PropRemaining
    # 1 1034_summary: 16767484  9523967  169798   7073719     0.4218712
    # 2 1036_summary:  6448459  3576629   84331   2787499     0.4322737
    # 3 1041_summary:  6367233  2833824  143510   3389899     0.5323975
    # 4 1049_summary:  5844520  1359873  233191   4251456     0.7274260
    # 5 1058_summary: 15701994  9537721  185482   5978791     0.3807664
    # 6 1060_summary:  6551187  2261263  294477   3995447     0.6098814
    #   PropRawLibraryTotal PropRemainingLibraryTotal
    # 1         0.013895163               0.011016230
    # 2         0.005343818               0.004341101
    # 3         0.005276507               0.005279247
    # 4         0.004843336               0.006620989
    # 5         0.013012195               0.009311048
    # 6         0.005428949               0.006222295
    
    #I could include a column of RawReadsCutadapt after the PropReadsRemaining, merging the files to ensure the files match correctly.
    mergeqf2$RawReadsCutadapt<-cutadaptstats$RawReads
    head(mergeqf2)

    #Calculate the proportion of reads remaining versus the raw reads input (before adaptor trimming)
    mergeqf2$PropRawReadsCutadapt<-(mergeqf2$Output/mergeqf2$RawReadsCutadapt)
    head(mergeqf2)
    #       FileName   Input Discarded  Output PropReadsRemaining RawReadsCutadapt
    # 1 1034_report: 7073719     42078 7031641          0.9940515         16767484
    # 2 1036_report: 2787499      4283 2783216          0.9984635          6448459
    # 3 1041_report: 3389899      5289 3384610          0.9984398          6367233
    # 4 1049_report: 4251456      6412 4245044          0.9984918          5844520
    # 5 1058_report: 5978791     39465 5939326          0.9933992         15701994
    # 6 1060_report: 3995447      5866 3989581          0.9985318          6551187
    #   PropRawReadsCutadapt
    # 1            0.4193617
    # 2            0.4316095
    # 3            0.5315669
    # 4            0.7263289
    # 5            0.3782530
    # 6            0.6089860

    #Can also check that "Remaining" from CutadaptStats.txt matches "Input" in this data.frame
    (mergeqf2$Input-cutadaptstats$Remaining)
    #   [1] 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    #  [38] 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    #  [75] 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    # [112] 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    # [149] 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0

    #Range of proportion of reads kept after both processing steps:
    range(mergeqf2$PropRawReadsCutadapt)
    #[1] 0.1428810 0.8812606
    mean(mergeqf2$PropRawReadsCutadapt)
    #[1] 0.5935062
    sd(mergeqf2$PropRawReadsCutadapt)
    #[1] 0.1639302
    
    
    #Proportion of Processed Reads per Library vs Total Processed Reads:
    #Sum of reads output from fastq_quality_filter step
    sum(mergeqf2$Output)
    # [1] 640618633

    mergeqf2$PropProcessedLibraryTotal<-(mergeqf2$Output/(sum(mergeqf2$Output)))
    head(mergeqf2)
    #       FileName   Input Discarded  Output PropReadsRemaining RawReadsCutadapt
    # 1 1034_report: 7073719     42078 7031641          0.9940515         16767484
    # 2 1036_report: 2787499      4283 2783216          0.9984635          6448459
    # 3 1041_report: 3389899      5289 3384610          0.9984398          6367233
    # 4 1049_report: 4251456      6412 4245044          0.9984918          5844520
    # 5 1058_report: 5978791     39465 5939326          0.9933992         15701994
    # 6 1060_report: 3995447      5866 3989581          0.9985318          6551187
    #   PropRawReadsCutadapt PropProcessedLibraryTotal
    # 1            0.4193617               0.010976329
    # 2            0.4316095               0.004344575
    # 3            0.5315669               0.005283346
    # 4            0.7263289               0.006626476
    # 5            0.3782530               0.009271235
    # 6            0.6089860               0.006227701
    
    #Save this file:
    getwd()
    # [1] "/mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/2_fastx_quality_filter_output/qualityreport" 
    write.table(mergeqf2, file = "/mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/5_trimfilter_statistics_table_output/fastx_quality_filter_stats_table.txt", quote = FALSE, sep = "\t ", col.names = TRUE)
    
    range(mergeqf2$PropProcessedLibraryTotal)
    # [1] 0.00178625 0.01273059
    mean(mergeqf2$PropProcessedLibraryTotal)
    # [1] 0.005747126
    sd(mergeqf2$PropProcessedLibraryTotal)
    # [1] 0.002019102
    q()
