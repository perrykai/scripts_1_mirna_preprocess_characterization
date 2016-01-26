#==============================================================================
#============================================
#  File:  8_write_fasta_for_expression_matrix.R
#  Directory Code:  /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/scripts/
#  Date:  1/9/15
#  Description:  This code creates a PCR-duplicate-removed fasta file using the frequency table 
#                created in the SeqDupInfo analysis. The output .fa file will be used for the eQTL analysis,
#                and for mapping and quantification steps.
#============================================
#  Input File Directory:  /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/7_sequence_duplication_table_output/

#  Input File(s):   xxxx_frqtbl.Robj (One output file from the PCR duplicate removal step for each sample)
 
#  Output File Directory: /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/8_collapsed_fasta_output_expression_matrix/

#  Output File(s): xxxx_express.fa (One output file for each sample)
#============================================
#  Example Output (If Applicable):

#  >seq_1_x54014
#  TGGAATGTAAAGAAGTATGTAT
#  >seq_2_x33188
#  TGGAATGTAAAGAAGTATGTAC
#  >seq_3_x29438
#  TGGAATGTAAGGAAGTGTGTGA
#  >seq_4_x23873
#  TGGAATGTAAAGAAGTATGTATT
#  >seq_5_x18417
#  TGGAATGTAAAGAAGTATGT

#============================================
#Softwares used: R/3.1.0; ShortRead package
#============================================
rm(list=ls())

setwd("/mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/7_sequence_duplication_table_output/")

library("ShortRead")

files<-list.files(pattern=".Robj")

for (i in 1:length(files)){
  setwd("/mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/7_sequence_duplication_table_output/")
  
  load(files[[i]])

  seq<-DNAStringSet(as.character(uniqfrq$seqnm), start=NA, end=NA, width=NA)   #Write the reads from the frequency table to a DNAstring object 
  
  nms<-paste("seq_", 1:length(uniqfrq$Freq), "_x", uniqfrq$Freq, sep="")       #Create the correct names for the BStringset object, including the expression data from the frequency table
  
  ids<-BStringSet(nms) #Create the BStringSet object with the correct read names and expression data
  
  fas<-ShortRead(sread=seq, id=ids)  #Write the Shortread object using the DNAstringSet and BStringSet objects
  
  setwd("/mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/8_collapsed_fasta_output_expression_matrix/") #Move to the output directory 
  
  fnm<-sub("_frqtbl.Robj", "_express.fa", files[[i]])  #Create the name for the fa file
  
  writeFasta(fas, fnm) #Create the fasta file from the created ShortRead Object
  
}
