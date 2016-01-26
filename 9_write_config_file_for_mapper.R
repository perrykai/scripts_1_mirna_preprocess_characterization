#============================================
#  File: 9_write_config_file_for_mapper.R
#  Directory Code:  /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/scripts/
#  Date:  1/12/16
#  Description:  This code writes the config file for the 174 samples being analyzed by miRDeep2 mapper and core modules
#============================================
#  Input File Directory:  /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/8_collapsed_fasta_output_expression_matrix/

#  Input File(s):  xxxx_express.fa file for each sample

#  Output File Directory: /mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/8_collapsed_fasta_output_expression_matrix/

#  Output File(s): config_for_mapper.txt
#============================================
#  Module used: R/3.1.0
#============================================
setwd("/mnt/research/pigeqtl/analyses/microRNA/1_preprocess_fastq_files/8_collapsed_fasta_output_expression_matrix/")
fn<-as.vector(list.files(pattern="_express.fa"))               #create a vector of the file names

head(fn)
# [1] "1034_express.fa" "1036_express.fa" "1041_express.fa" "1049_express.fa"
# [5] "1058_express.fa" "1060_express.fa"

length(fn)
# [1] 174

numf<-seq(1,length(fn),1)           #create a vector of numbers the same length as the number of file names
head(numf)
#[1] 1 2 3 4 5 6

dig<-sprintf("%03d",numf)           #sprintf function allows for the creation of a 3-digit numeric identifier
head(dig)
#[1] "001" "002" "003" "004" "005" "006"

config<-cbind(fn,dig)               #bind the two columns together
head(config)
#      fn                dig
# [1,] "1034_express.fa" "001"
# [2,] "1036_express.fa" "002"
# [3,] "1041_express.fa" "003"
# [4,] "1049_express.fa" "004"
# [5,] "1058_express.fa" "005"
# [6,] "1060_express.fa" "006"

write.table(config, file = "config_for_mapper.txt", quote = FALSE, sep = " ", row.names = FALSE, col.names = FALSE) #write the config object to a text file

