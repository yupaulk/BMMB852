#!/usr/bin/env bash

# Set the trace to show the commands as executed
set -uex

# The URLs of the genome file
GENOME_URL="http://ftp.ensemblgenomes.org/pub/viruses/fasta/sars_cov_2/dna/Sars_cov_2.ASM985889v3.dna.toplevel.fa.gz"

# The URLs of the gff3 file
GFF_URL="http://ftp.ensemblgenomes.org/pub/viruses/gff3/sars_cov_2/Sars_cov_2.ASM985889v3.101.gff3.gz"

# The name of the genome file
GENOME="genome.fa"

# The name of the gff3 file
GFF="species.gff"

# The name of the genes file
GENES="genes.gff"

# The name of the custom annotation file
CUSTOM="custom.gff3"

# The name of the accession ID of the species
ACCESSION=MN908947.3

# ------ NO CHANGES NECESSARY BELOW THIS LINE ------

# Download and unzip the genome file if it doesn't exist
if [ ! -f ${GENOME} ]; then
    wget ${GENOME_URL} -O ${GENOME}.gz
    gunzip -k ${GENOME}.gz
fi

# Download and unzip the gff3 file if it doesn't exist
if [ ! -f ${GFF} ]; then
    wget ${GFF_URL} -O ${GFF}.gz
    gunzip -k ${GFF}.gz
fi

# Make a new GFF file with only the features of type gene
cat ${GFF} | awk '$3 == "gene"' > ${GENES}

# Print the number of genes
cat ${GENES} | wc -l

# Create a custom GFF3 file and add to IGV as a separate track. Save it as custom.gff3. 
echo "${ACCESSION}	custom	gene	300	15000	.	+	.	ID=custom_gene;Name=FooGene" > ${CUSTOM}

# Load custom.gff3 to the same IGV session
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

# Perform sequence ontology
# Make sure to install bio by typing: bio --download
bio explain gene
