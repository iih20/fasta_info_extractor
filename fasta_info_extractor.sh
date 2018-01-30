################### Author: Ian Hu, Department of Biochemistry, University of Cambridge ###################
# This program produces a tab-delimited file with wanted features from a long fasta file
#
# USAGE: ./fasta_info_extractor fasta_location separator_in_quote_mark features_separated_by_comma[,] 
# outfile_name output_with_sequence(yes/no)
#
# example: ./fasta_info_extractor genome.fasta "|" 1,5,6 output.fasta yes
#
# expeected input:
# >TGME49_258550-t26_1   | Toxoplasma gondii ME49 | SAG-related sequence SRS28 | 
# protein  | length=291 | FPrate:0.001 | OMEGA:S-267
# [protein sequence]
#
# expected output: 
# >TGME49_258550-t26_1	length=291	FPrate:0.001
# [protein sequence]
#
# The author claims no copyright for this. however if you wish to buy the author a beer or have any problems, 
# contact the author at iih20@cam.ac.uk
# FEEL FREE TO CITE ME
##############################################################################################################
errormessage=" USAGE: ./fasta_info_extractor fasta_location separator_in_quote_mark features_separated_by_comma[,] outfile_name output_with_sequence(yes/no)\n ex: ./fasta_info_extractor genome.fasta \"|\" 1,5,6 output.fasta yes" 

OUTPUT=$4

if (("$#" == 0));
then head -21 fasta_info_extractor
exit
fi

if (("$#" != 5)) ;
then echo -e $errormessage
exit
fi

#passing the arguments to awk by the $* at the end of the script
gawk  '
BEGIN {
	error="USAGE: ./fasta_info_extractor fasta_location separator_in_bracket features_separated_by_comma[,] outfile_name output_with_sequence(yes/no)\n ex: ./fasta_info_extractor genome.fasta \"|\" 3,5 output.fasta yes"

	###determining field and record separator###
	RS=">"
	FS=ARGV[2]
	output=ARGV[4]
	choice=ARGV[5]
	OFS="\t"
	ORS="\t"

	#### checking input files ####
	if (system("test -r " ARGV[1]) ) {
			print ARGV[1] " file error - either no file or no reading permission" 
			print error
			exit
		}

	#### read features ####
	n=split(ARGV[3], array, ",")
	delete ARGV[2]
	delete ARGV[3]
	delete ARGV[4]
	delete ARGV[5]

}

####MAIN find sequence for each feature ####
{	
	sequence_start = match($0, "\n[A-Z]+")
	sequence= substr($0, sequence_start)
	$1="\n>"$1
	for (each in array) {
		print $array[each] 
	}
	if (choice == "yes") {
		print sequence 
	}

	next
} 


' $* | sed '/^[[:space:]]*$/d' | sed 1d > $OUTPUT
