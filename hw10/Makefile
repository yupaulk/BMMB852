# The accession number at SRA
SRR=SRR31137229

# The accession number for the genome
ACC=GCF_008369605.1

# Genome short name
REF=refs/vibrio.fa

# The first read file
R1=reads/${SRR}_1.fastq

# The first read file
R2=reads/${SRR}_2.fastq

# BAM file
BAM=bam/vibrio.bam

# The variant file.
VCF = vcf/vibrio.vcf.gz

# Additional bcf flags for pileup annotation.
PILE_FLAGS =  -d 100 --annotate 'INFO/AD,FORMAT/DP,FORMAT/AD,FORMAT/ADF,FORMAT/ADR,FORMAT/SP'

# Additional bcf flags for calling process.
CALL_FLAGS = --ploidy 2 --annotate 'FORMAT/GQ'

# The number of reads to download
N=100000

# Read length for fastq simulation
READ_LENGTH=150

# Seed for wgsim (do not change for reproducibility)
SEED=852

# Custom makefile settings
SHELL = bash
.ONESHELL:
.SHELLFLAGS = -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.PHONY: usage refs simulate fastq index align stats vcf all clean

usage:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  usage - Show the targets"
	@echo "  refs  - Download the reference genome"
	@echo "  fastq - Download reads from SRA"
	@echo "  index - Index the reference genome"
	@echo "  align - Align the reads and convert to BAM"
	@echo "  stats - Generate alignment statistics"
	@echo "  vcf   - Call variants"
	@echo "  all   - Run entire pipeline"
	@echo "  clean - Remove all files"

# Obtain the reference genome
refs:
	# Download the Vibrio cholerae
	@echo "Downloading the Vibrio cholerae genome from NCBI..."
	mkdir -p refs
	datasets download genome accession ${ACC}

	# Unzip the genome, skip the README and md5sum files.
	@echo "Unpacking the data..."
	unzip -n ncbi_dataset.zip -x README.md md5sum.txt
	
	# Copy the genome to the reference file
	cp -f ncbi_dataset/data/${ACC}*/${ACC}*_genomic.fna ${REF}

# Download a subset of reads from SRA
fastq:
	# Download 100000 read pairs with fastq-dump into the reads directory
	@echo "Downloading 100000 read pairs..."
	fastq-dump -X ${N} -F --outdir reads --split-files ${SRR}

# Index the reference genome
index:
	bwa index ${REF}

# Align the reads and convert to BAM. Use 4 threads
align:
	# Make the BAM directory
	mkdir -p $(dir ${BAM})

	# Align the reads
	bwa mem -t 4 ${REF} ${R1} ${R2} | samtools sort > ${BAM}

	# Index the BAM file
	samtools index ${BAM}

# Generate alignment statistics
stats:
	samtools flagstat ${BAM}

vcf:
	# Make the VCF directory
	mkdir -p vcf
	bcftools mpileup ${PILE_FLAGS} -O u -f ${REF} ${BAM} | \
		bcftools call ${CALL_FLAGS} -mv -O u | \
		bcftools norm -f ${REF} -d all -O u | \
		bcftools sort -O z > ${VCF}

all: refs simulate fastq index align stats vcf

clean:
	@echo "Cleaning up files..."
	rm -f *.zip
	rm -rf bam ncbi_dataset reads refs vcf
