#============================================
    #  File:  3_quality_summary_plot.R
    #  Directory Code:  /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/scripts/
    #  Date:  1/8/15
    #  Description:  This code creates one graph plotting the Q1, median, and Q3 Phred scores
    #                for each position of each read, for the full 174 samples.
    #============================================
    #  Input File Directory:  /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/3_trimfilter_statistics_output/2_trimmed_filtered_fastq_quality_assessment/
    
    #  Input File(s):  xxxx_posttrimqstats.txt (One output file from the preprocessing steps for each sample)
    
    #  Output File Directory: /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/3_quality_summary_plot_output/
    
    #  Output File(s): trimmed_filtered_quality_summary_plot.pdf
    
    #============================================
    #  Module Used: R/3.1.0
    #============================================
    #  Example Output (If Applicable):
    #============================================
    
    rm(list=ls())
    setwd("/mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/3_trimfilter_statistics_output/2_trimmed_filtered_fastq_quality_assessment/")
    
    files<-list.files(pattern="_posttrimqstats.txt")
    
    tb<-read.table(files[1],header=T)
    pdf("/mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/3_quality_summary_plot_output/trimmed_filtered_quality_summary_plot.pdf")
    plot(tb$column,tb$med,ylim=c(0,45),type="n",xlab="Read Position",ylab="Phred Score",main="Quality Scores 174 Libraries", cex.main=1.8,cex.lab=1.5,cex.axis=1.2)
    for (i in files){
      tb<-read.table(i,header=T)
      points(tb$column,tb$med,type="l",lwd=2,lty="dotted")
      points(tb$column,tb$Q1,type="l",lty="dashed",col="red")
      points(tb$column,tb$Q3,type="l",lty="dashed",col="blue")
      legend("bottomright", c("Median","Q1","Q3"), col=c("black","red","blue"),lty=c("dotted","dashed","dashed"),lwd=c(2,1,1))
    }
    dev.off()

