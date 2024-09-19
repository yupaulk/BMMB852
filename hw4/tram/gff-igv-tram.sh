#!/usr/bin/env bash

# Set the trace to show the commands as executed
set -uex

# The URLs of the genome file
GENOME_URL="https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/146/045/GCF_000146045.2_R64/GCF_000146045.2_R64_genomic.fna.gz"

# The URLs of the gff3 file
GFF_URL="https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/146/045/GCF_000146045.2_R64/GCF_000146045.2_R64_genomic.gff.gz"

# The name of the genome file
GENOME="genome-tram.fa"

# The name of the gff3 file
GFF="species-tram.gff"

# The name of the genes file
GENES="genes-tram.gff"

# The name of the custom annotation file
CUSTOM="custom-tram.gff3"

# The name of the accession ID of the species
ACCESSION=NC_001133.9

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

# Load custom.gff3 to the same IGV session.
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
