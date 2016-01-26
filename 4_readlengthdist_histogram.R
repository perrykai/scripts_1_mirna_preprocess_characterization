    #============================================
    #  File:  4_readlengthdist_histogram.R
    #  Directory Code:  /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/scripts/
    #  Date:  1/8/15
    #  Description:  This code creates a histogram of the read length distributions of the 174 smallRNA libraries.
    #                
    #============================================
    #  Input File Directory:  /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/4_readlength_distribution_output/
    
    #  Input File(s):  xxxx_readlengthdistfull.txt
    
    #  Output File Directory: /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/4_readlengthdist_histogram_output/
    
    #  Output File(s): read_length_distribution_histogram.pdf (visual plot of read length distribution)

    #============================================    
    
    rm(list=ls())
    
    setwd("/mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/1_preprocess_fastq_files_output/4_readlength_distribution_output/")
    
    filelist<-grep("readlengthdistfull.txt",list.files(),value=T)
    head(filelist)
    # [1] "1034_readlengthdistfull.txt" "1036_readlengthdistfull.txt"
    # [3] "1041_readlengthdistfull.txt" "1049_readlengthdistfull.txt"
    # [5] "1058_readlengthdistfull.txt" "1060_readlengthdistfull.txt"    
    
    #Create the empty vector
    counts<-rep(0,50)
    
    #Create a for loop to run all 152 files
    for (i in filelist){
      cnt<-read.table(i)
      id<-cnt[,2]-8
      fr<-cnt[,1]
      counts[id]<-counts[id]+fr
    }
    
    
    #Now, counts is the total frequency of each read length for the 176 files.
    counts
    #  [1]         0         0         0         0         0         0         0
    #  [8]         0         0         0         0         0         0         0
    # [15]         0         0         0  11981591  11675268  25762618  57623298
    # [22] 408975445  79515268  19926883   6911303   4536366   4446056   3456254
    # [29]   2625039   3183244         0         0         0         0         0
    # [36]         0         0         0         0         0         0         0
    # [43]         0         0         0         0         0         0         0
    # [50]         0    

    counts2<-counts/sum(counts)
    counts2 
    #  [1] 0.000000000 0.000000000 0.000000000 0.000000000 0.000000000 0.000000000
    #  [7] 0.000000000 0.000000000 0.000000000 0.000000000 0.000000000 0.000000000
    # [13] 0.000000000 0.000000000 0.000000000 0.000000000 0.000000000 0.018703157
    # [19] 0.018224990 0.040215218 0.089949457 0.638407040 0.124122628 0.031105687
    # [25] 0.010788483 0.007081227 0.006940254 0.005395182 0.004097663 0.004969016
    # [31] 0.000000000 0.000000000 0.000000000 0.000000000 0.000000000 0.000000000
    # [37] 0.000000000 0.000000000 0.000000000 0.000000000 0.000000000 0.000000000
    # [43] 0.000000000 0.000000000 0.000000000 0.000000000 0.000000000 0.000000000
    # [49] 0.000000000 0.000000000    

    
    #Then, use barplot to visually represent the distribution of read lengths in this complete dataset.
    pdf("/mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/4_readlengthdist_histogram_output/read_length_distribution_histogram.pdf")
    par(oma=c(2,2,2,2))
    barplot(counts2[17:31],names.arg=17:31,space=0,axes=T,
            main="Read Length Distribution 174 Libraries",
            xlab="Read Length (nt)",ylab="Proportional Frequency", ylim=c(0,0.7),
            col="deepskyblue",border=TRUE,
            cex.main=1.8,cex.lab=1.5,cex.axis=1.2)
    dev.off()
