#!/bin/bash
#
#SBATCH --time=5-00:00:00
#SBATCH --mem=5G# Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --nodes=1
#SBATCH --partition=high # Partition to submit to
#SBATCH --output=slurmout/WS-%A-%a.out # File to which STDOUT will be written
#SBATCH --error=slurmout/WS-%A-%a.err # File to which STDERR will be written

#run it: sbatch prerun_wellsplit.sh

#  Make a list of the files we want to split out 

ls *R1*.fastq > listR1
ls *R3*.fastq > listR3
ls *_R1_* | sed 's/_R1[^=&]*//g' | paste listR1 listR3 - > flist

