#!/usr/bin/env bash

# Set the trace to show the commands as executed
set -uex

# Download E. coli WGS
# See https://www.ebi.ac.uk/ena/browser/view/SRR957824 for details
ACCESSION="SRR5790106"

# ------ NO CHANGES NECESSARY BELOW THIS LINE ------

# Check metadata of ACCESSION
echo "Checking metadata..."
bio search ${ACCESSION}

# Download 1000 read pairs with fastq-dump into the reads directory
echo "Downloading 1000 read pairs..."
fastq-dump -X 1000 -F --outdir reads --split-files ${ACCESSION}

echo "Checking if download successful..."
if [ -d "reads" ]; then
  cd reads

  echo "Checking if fastqc is installed..."
  if ! command -v fastqc &> /dev/null
  then
    echo "fastqc could not be found. Please install bc or make sure it is in your PATH. To install:"
    echo "conda install bioconda::fastqc"
    exit
  fi

  fastqc *.fastq
  
  if ! command -v explorer.exe &> /dev/null
  then
    echo "Please open the html file manually."
    exit
  fi

  explorer.exe *.html

else
  echo "Folder 'reads' does not exist."
  exit
fi
