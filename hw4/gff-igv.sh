# Constants
GENOME="genome.fa"
CUSTOM="custom-annot.gff3"

# ----- NOTHING NEEDS TO BE CHANGED BELOW THIS LINE -----

# Pipeline:

# a. In the Terminal, download and unzip SARS-COV2 genome
wget http://ftp.ensemblgenomes.org/pub/viruses/fasta/sars_cov_2/dna/Sars_cov_2.ASM985889v3.dna.toplevel.fa.gz
gunzip Sars_cov_2.ASM985889v3.dna.toplevel.fa.gz

# b. Download unzip SARS-COV2 GFF3 annotation
wget http://ftp.ensemblgenomes.org/pub/viruses/gff3/sars_cov_2/Sars_cov_2.ASM985889v3.101.gff3.gz
gunzip Sars_cov_2.ASM985889v3.101.gff3.gz

# c. Rename the files for ease-of-use
mv Sars_cov_2.ASM985889v3.dna.toplevel.fa genome.fa
mv Sars_cov_2.ASM985889v3.101.gff3 annotation.gff3

# d. In the Terminal, in the gff3 file find "gene" on the third column and save them to gene-annot.gff3.
cat annotation.gff3 | awk '$3 == "gene"'> gene-annot.gff3

# f. Create own custom GFF3 file and add to IGV as a separate track. Save it as custom-annot.gff3. 
# 	The contents are as shown below:
#		MN908947.3	custom	gene	300	1500	.	+	.	ID=custom_gene;Name=FooGene

echo "MN908947.3	custom	gene	300	1500	.	+	.	ID=custom_gene;Name=FooGene" >> ${CUSTOM}

# g. Load custom-annot.gff3 to the same IGV session.
# 	We can see the FooGene annotation on a separate track. It is forward-stranded and at the 300 to 1500 interval.
# 	The screenshot can be accessed [here](https://github.com/yupaulk/BMMB852/blob/main/week3/images/igv-foogene-track.png).

# Check if IGV is installed and executable
if ! command -v igv &> /dev/null
then
    echo "IGV could not be found. Please install IGV or make sure it is in your PATH."
    exit
fi

# Launch IGV and load the genome and custom annotation file
igv -g ${GENOME} ${CUSTOM} &

# Print message indicating that IGV is starting
echo "Launching IGV with genome ${GENOME} and annotation ${CUSTOM}"
