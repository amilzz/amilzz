#!/usr/bin/perl
# counting allele frequency from geno file 
# Michael Miller, Ensieh Habibi
# Edited by Mac Campbell on 04/07/2023 to provide more comprehensive output and a
# filtering step was put in, conditional at line 100
# Usage
# ./count-genos-lct.pl 20 21 LCTxRBT_1pop.bamlist.PCA9.geno 

$pop1 = $ARGV[0];
$pop2 = $ARGV[1];
$geno = $ARGV[2];


open(FILE, "<$geno") or die;

print "Chromosome\tPosition\tMajor\tMinor\tFreq1\tFreq2\tDiff\tPropMissing1\tPropMissing2\n";

while (<FILE>) {
	$line = $_; chomp($line);
    @info = split(/\t/,$line);
    $len=$#info+1; # get how long the genotype file line is
	
    if ($pop1+$pop2+4 != $len) {
    		print "Sample sizes do not match genotype file!\nExpect $pop1 and $pop2 inds. Make sure your bamlist and expected individuals match.\n";
    		print "pop1 = $pop1\n";
    		print "pop2 = $pop2\n";
    		print "number of genos in line: ";
    		print $len-4;
    		print "\n";
    		die;
    	} else {
	#Printing NC_035077.1	44194	C	T
	#etc.
  #  print "$info[0]\t$info[1]\t$info[2]\t$info[3]\t"; 

	#Set up counters
	my $missing1=0;
	my $missing2=0;


  	$x=1;
  	
    	my $minor_allele=0;
        my $all_alleles=0;
 while ($x <= $pop1) {      #Starting to count pop1
         if ($info[$x+3]==0) { #+3 becuase the first four column of the geno files are not genotype call data,
                    $all_alleles=$all_alleles+2;    
             } elsif ($info[$x+3]==1) {
                  $all_alleles=$all_alleles+2;
                       $minor_allele++;
                } elsif ($info[$x+3]==2) {
                     $all_alleles=$all_alleles+2;
                  $minor_allele=$minor_allele+2;
             } elsif ($info[$x+3]==-1) {
                 $missing1++;
          }
          $x++;
      }
 #     print "$all_alleles\t$minor_allele\n";
      if ($all_alleles > 0) {
                $mafredband=$minor_allele/$all_alleles;
        } else {
                $mafredband="NA";
        }


     #  print "$mafredband\t";
	#print "$missing1\n";
       my $minor_allele1=0;
       my $all_alleles1=0;

 while ($x <= $pop1 + $pop2 ) { #number of individuals in group rainbowtrout
                if ($info[$x+3]==0) {
                        $all_alleles1=$all_alleles1+2;
                } elsif ($info[$x+3]==1) {
                        $all_alleles1=$all_alleles1+2;
                        $minor_allele1++;
                } elsif ($info[$x+3]==2) {
                        $all_alleles1=$all_alleles1+2;
                        $minor_allele1=$minor_allele1+2;
                } elsif ($info[$x+3]==-1) {
						$missing2++;
                }
                $x++;
        }
#        print "$all_alleles1\t$minor_allele1\n";
	
  if ($all_alleles1 > 0) {
            $mafrainbow=$minor_allele1/$all_alleles1;
      } else {
           $mafrainbow="NA";
   }
     #   print "$mafrainbow\t";
	 #print "$missing2\n";
        {        
 $minus=$mafredband-$mafrainbow;
        }
# Condition to remove missing data if desired
# 
if ($missing1/$pop1 <= 0.2 && $missing2/$pop2 <= 0.2  && abs($minus) > 0.9) {

	#Printing NC_035077.1	44194	C	T
	#etc.
	print "$info[0]\t$info[1]\t$info[2]\t$info[3]\t"; 
	print "$mafredband\t";
	print "$mafrainbow\t";
	print "$minus\t";
 	print $missing1/$pop1;
   	print "\t";
	print $missing2/$pop2;
   	print "\n";
   
#}	else {
#	print "Missing data\n";
	}
}

}

close FILE;