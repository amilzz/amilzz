#!  /usr/local/bin/Rscript

# Reads in a .geno formatted file and
# calculates the number and proportion of -1, missing 
# genotype calls
# By Mac Campbell 04202023 drmaccampbell@gmail.com
# usage
#  ./find-missing.R LCTxRBT_1pop.bamlist.PCA9.geno

args = commandArgs(trailingOnly=TRUE)

table<-read.table(args[1])
t2<-table[5:ncol(table)]
ninds<-ncol(t2);
t3<-t(t2)
t3<-as.data.frame(t3)

ninds<-nrow(t3);
ngenos<-ncol(t3);

t3$Missing <- rowSums(t3 == "-1")
t3$Proportion <- round(t3$Missing/ngenos,2)
t3$Individual <- paste0("Ind",seq(1, ninds, 1))
rownames(t3)<-NULL

t3[,c("Individual","Missing", "Proportion")]
