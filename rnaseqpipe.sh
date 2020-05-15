!#/bin/bash

# letting shell know where the programs are
#pipeline for RNAseq analysis

source /etc/profile.d/markcbm.sh

cp -R /home/manager/linux/ ~/Desktop/.
cd ~/Desktop/linux/advanced/rnaseq/

fastqc fastq/*.fastq

#building the index
cd index/
bowtie-build mm9_chr1.fa mm9_chr1

#align the sequences
cd ..
tophat2 -G mm9_chr1.gtf -o tophat_wt/ index/mm9_chr1 fastq/myoblast_wt.fastq
tophat2 -G mm9_chr1.gtf -o tophat_del/ index/mm9_chr1 fastq/myoblast_del.fastq

#check for appropriate outputs
ls
ls tophat_wt/
ls tophat_del/
cat tophat_wt/align_summary.txt 
cat tophat_del/align_summary.txt

#index = sorts the data so that the data is handled more efficiently, like the index section of a textbook to make things more efficient
#bam indexing    
#if samtools doesn't work, run the source line again to refresh where the programs are found
samtools19 index tophat_wt/accepted_hits.bam
samtools19 index tophat_del/accepted_hits.bam

#calculate the differential expression between the wt and the del samples
#-L wt,del this option states to label the wt as first and the del mutant as second so the denominator and the numerator are correctly selected.
cuffdiff --no-update-check -o cuffdiff_out -L wt,del mm9_chr1.gtf tophat_wt/accepted_hits.bam tophat_del/accepted_hits.bam

#check the cutdiff_out directory to ensure that output files from the previous command are there
#we want the file gene_exp.diff
ls -lh cuffdiff_out


#run the pipeline
echo "the RNA seq pipeline is complete"














