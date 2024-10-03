#!/usr/bin/env bash

# Set the trace to show the commands as executed
set -uex

# Download Burkholderia thailandensis RNA-Seq
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
    echo "fastqc could not be found. Please install fastqc or make sure it is in your PATH. To install:"
    echo "conda install bioconda::fastqc"
    exit
  fi

  echo "Running fastqc..."
  fastqc ${ACCESSION}_1.fastq
  echo "Please open the html file manually."

  # Use fastp to cut the first 10 bases
  echo "Checking if fastp is installed..."
  if ! command -v fastp &> /dev/null
  then
    echo "fastp could not be found. Please install fastp or make sure it is in your PATH. To install:"
    echo "conda install bioconda::fastp"
    exit
  fi

  echo "Trimming 10 reads using fastp..."
  fastp --in1 "${ACCESSION}_1.fastq" --out1 "trimmed_${ACCESSION}_1.fastq" --trim_front1 10

  echo "Running fastqc..."
  fastqc trimmed_${ACCESSION}_1.fastq
  echo "Please open the html file manually."

  #explorer.exe trimmed_${ACCESSION}_1_fastqc.html

else
  echo "Folder 'reads' does not exist."
  exit
fi
