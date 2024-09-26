#!/usr/bin/env bash

# Set the trace to show the commands as executed
set -uex

# Accession ID of Vibrio cholerae
ACCESSION="GCF_008369605.1"

# Path to the genome file
GENOME_PATH="ncbi_dataset/data/GCF_008369605.1/GCF_008369605.1_ASM836960v1_genomic.fna"

# Genome short name
GENOME="vibrio.fa"

# Read length for fastq simulation
READ_LENGTH=150

# Seed for wgsim (do not change for reproducibility)
SEED=8552

# Simulated fastq reads 1 and 2
R1="read1.fq"
R2="read2.fq"

# ------ NO CHANGES NECESSARY BELOW THIS LINE ------

# Download the Vibrio cholerae
echo "Downloading the Vibrio cholerae genome from NCBI..."
datasets download genome accession ${ACCESSION}

# Unpack the data
echo "Unpacking the data..."
unzip -o ncbi_dataset.zip

# Make a copy of the genome under a simpler name
ln -sf ${GENOME_PATH} ${GENOME}

# Check the file size of the genome
echo "Size of the file:"
stat --format="%s" ${GENOME_PATH}

# Check the total size of the genome
echo "Total size of the genome:"
genome_size=$(grep -v "^>" ${GENOME} | wc -c)
echo ${genome_size}

# Check the number of chromosomes (including plasmid) in the genome
echo "Number of chromosomes (including plasmid) in the genome:"
grep -c "^>" ${GENOME}

# Check the name (id) and length of each chromosome in the genome
echo "Name (id) and length of each chromosome or plasmid in the genome:"
awk '/^>/ { if (seq) { print id, length(seq) } id = $1; seq = ""; next } { seq = seq $0 } END { if (seq) { print id, length(seq) } }' vibrio.fa | sed 's/^>//'

# Generate a simulated FASTQ output for a sequencing instrument of your choice.
#   Set the parameters so that your target coverage is 10x.

# Check if bc (Basic Calculator) is installed and executable
echo "Check if bc (Basic Calculator) is installed and executable..."
if ! command -v bc &> /dev/null
then
    echo "bc (Basic Calculator) could not be found. Please install bc or make sure it is in your PATH. To install:"
    echo "sudo apt install bc"
    exit
fi

# Calculate total reads from genome size and read length
echo "Total reads:"
total_reads=$(echo "(${genome_size} * 10) / ${READ_LENGTH}" | bc)
echo $total_reads

# Simulate fastq using wgsim
echo "Simulating fastq using wgsim..."
wgsim -N ${total_reads} -1 ${READ_LENGTH} -2 ${READ_LENGTH} -r 0 -R 0 -X 0 -S ${SEED} ${GENOME} ${R1} ${R2}

# Check file size of the read 1 fastq file
echo "File size of read 1 fastq:"
r1_size=$(stat --format="%s" ${R1})
echo ${r1_size}

# Check file size of the read 2 fastq file
echo "File size of read 2 fastq:"
r2_size=$(stat --format="%s" ${R2})
echo ${r2_size}

# Compress read 1 fastq file
echo "Compressing read 1 fastq..."
gzip -c ${R1} > ${R1}.gz

# Compress read 2 fastq file
echo "Compressing read 2 fastq..."
gzip -c ${R2} > ${R2}.gz

# Check file size of the compressed read 1 fastq file
echo "File size of compressed read 1 fastq:"
r1_gz_size=$(stat --format="%s" ${R1}.gz)
echo ${r1_gz_size}

# Check file size of the compressed read 2 fastq file
echo "File size of compressed read 2 fastq:"
r2_gz_size=$(stat --format="%s" ${R2}.gz)
echo ${r2_gz_size}

# How much space it saves for read 1?
echo "Hooray! You saved this much space for compressing read 1:"
echo "${r1_size} - ${r1_gz_size}" | bc

# How much space it saves for read 2?
echo "Hooray! You saved this much space for compressing read 2:"
echo "${r2_size} - ${r2_gz_size}" | bc
