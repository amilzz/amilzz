#!/bin/bash -l
#
#SBATCH --time=5-00:00:00
#SBATCH --mem=5G# Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --nodes=1
#SBATCH --ntasks=5
#SBATCH --partition=high # Partition to submit to
#SBATCH --output=slurmout/WS-%A-%a.out # File to which STDOUT will be written
#SBATCH --error=slurmout/WS-%A-%a.err # File to which STDERR will be written

# these two scripts  should be in the current directory: BarcodeSplitListBestRadPairedEnd.pl; run_BestRadSplit.sh for sbfI or  run_BestRadSplit_PstI.sh for PstI
# run it: sbatch run_wellsplit.sh flist

# the script must be run with flist file 
list=flist

wc=$(wc -l ${list} | awk '{print $1}')

x=1
while [ $x -le $wc ] 
do
	string="sed -n ${x}p ${list}" 
	str=$($string)

	var=$(echo $str | awk -F"\t" '{print $1, $2, $3}')   
	set -- $var
	c1=$1
	c2=$2
	c3=$3

	sh run_BestRadSplit.sh $c1 $c2 $c3  # use run_BestRadSplit_PstI.sh script instead

	x=$(( $x + 1 ))

done


