    #============================================
    #  File:  6_librarysize_scatterplot.R
    #  Directory Code:  /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/scripts/
    #  Date:  1/9/15
    #  Description:  This code creates a scatterplot plotting the total processed library size of each pig
    #                Pig ID is on the X axis, and Library Size (Reads) is on the Y axis.
    #============================================
    #  Input File Directory:  /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/5_trimfilter_statistics_table_output

    #  Input File(s):  fastx_quality_filter_stats_table.txt (One output file from the preprocessing steps for each sample)
    
    #  Output File Directory: /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/6_librarysize_scatterplot_output
    
    #  Output File(s): librarysize_processedreads_scatterplot.pdf
    
    #============================================
    #  Module Used: R/3.1.0
    #============================================
    #  Example Output (If Applicable):
    #============================================
    setwd("/mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/5_trimfilter_statistics_table_output")
    getwd()
    #[1] "/mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/5_trimfilter_statistics_table_output"
    rm(list=ls())
    ls()
    #character(0)
    
    #Read in .csv
    qcstats<-read.csv("fastx_quality_filter_stats_table.txt", sep="", header=TRUE)
    head(qcstats)
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
    
    
    #The file names need to be a numeric to plot correctly
    #Additionally, trimming off the "_report:" from the file names.
    Filenamenum1<-as.numeric(sub("_report:", "", qcstats$FileName))
    
    #Then, attach the numeric file names as an additional column, ensuring correct order
    qcstats2<-cbind(qcstats,Filenamenum1)
    head(qcstats2)
    #           FileName   Input Discarded  Output PropReadsRemaining RawReadsCutadapt
    # 1 1034_report: 7073719     42078 7031641          0.9940515         16767484
    # 2 1036_report: 2787499      4283 2783216          0.9984635          6448459
    # 3 1041_report: 3389899      5289 3384610          0.9984398          6367233
    # 4 1049_report: 4251456      6412 4245044          0.9984918          5844520
    # 5 1058_report: 5978791     39465 5939326          0.9933992         15701994
    # 6 1060_report: 3995447      5866 3989581          0.9985318          6551187
    #   PropRawReadsCutadapt PropProcessedLibraryTotal Filenamenum1
    # 1            0.4193617               0.010976329         1034
    # 2            0.4316095               0.004344575         1036
    # 3            0.5315669               0.005283346         1041
    # 4            0.7263289               0.006626476         1049
    # 5            0.3782530               0.009271235         1058
    # 6            0.6089860               0.006227701         1060
    
    qcstats2$Filenamenum1==(sub("_report:", "", qcstats$FileName))
    #   [1] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
    #  [16] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
    #  [31] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
    #  [46] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
    #  [61] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
    #  [76] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
    #  [91] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
    # [106] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
    # [121] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
    # [136] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
    # [151] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
    # [166] TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE TRUE
    
    
    #Plot the size of each processed library: Output
    pdf("/mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/6_librarysize_scatterplot_output/librarysize_processedreads_scatterplot.pdf")

    plot(qcstats2$Filenamenum1, qcstats2$Output, xlim=c(1034,2317), ylim=c(0,9000000), 
         xlab="Pig ID", ylab ="Total Processed Reads", 
         main="Total Processed Reads per Pig",type="p", pch=19, col="blue",
         cex.main=1.8,cex.lab=1.5,cex.axis=1.2)
    dev.off()
