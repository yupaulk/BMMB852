# The accession number at SRA
SRR=SRR10001256

# The accession number for the genome
ACC=GCF_008369605.1

# Genome short name
REF=refs/vibrio.fa

# The GFF file.
GFF=refs/vibrio.gff

# The first read file
R1=reads/${SRR}_1.fastq

# The first read file
R2=reads/${SRR}_2.fastq

# BAM file
BAM=bam/${SRR}_vibrio.bam

# The variant file.
VCF = vcf/${SRR}_vibrio.vcf.gz

# Additional bcf flags for pileup annotation.
PILE_FLAGS =  -d 100 --annotate 'INFO/AD,FORMAT/DP,FORMAT/AD,FORMAT/ADF,FORMAT/ADR,FORMAT/SP'

# Additional bcf flags for calling process.
CALL_FLAGS = --ploidy 2 --annotate 'FORMAT/GQ'

# The number of reads to download
N=5000

# Custom makefile settings
SHELL = bash
.ONESHELL:
.SHELLFLAGS = -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

usage:
	@echo "#"
	@echo "# SNP call pipeline"
	@echo "#"
	@echo "# ACC=${ACC}"
	@echo "# SRR=${SRR}"
	@echo "# SAMPLE=${SAMPLE}"
	@echo "# BAM=${BAM}"
	@echo "# VCF=${VCF}"
	@echo "#"
	@echo "# Usage: make [target]"
	@echo "#"
	@echo "# Targets:"
	@echo "#  usage - Show the targets"
	@echo "#  refs  - Download the reference genome"
	@echo "#  index - Index the reference genome"
	@echo "#  fastq - Download reads from SRA"
	@echo "#  align - Align the reads and convert to BAM"
	@echo "#  stats - Generate alignment statistics"
	@echo "#  vcf   - Call variants"
	@echo "#  all   - Run entire pipeline"
	@echo "#  clean - Remove all files"
	@echo "#"

# Obtain the reference genome
refs:
	# Download the Vibrio cholerae
	@echo "Downloading the Vibrio cholerae genome from NCBI..."
	mkdir -p refs
	datasets download genome accession ${ACC} --include gff3,genome

	# Unzip the genome, skip the README and md5sum files.
	@echo "Unpacking the data..."
	unzip -n ncbi_dataset.zip -x README.md md5sum.txt
	
	# Copy the genome to the reference file
	cp -f ncbi_dataset/data/${ACC}*/${ACC}*_genomic.fna ${REF}
	
	# Copy the GFF3 file to the reference file
	cp -f ncbi_dataset/data/${ACC}*/genomic.gff ${GFF}

# Index the reference genome
index:
	bwa index ${REF}

# Download a subset of reads from SRA
fastq:
	# Download 5000 read pairs with fastq-dump into the reads directory
	@echo "Downloading 5000 read pairs..."
	fastq-dump -X ${N} -F --outdir reads --split-files ${SRR}

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

	# Index the VCF file
	bcftools index -t -f ${VCF}

all: fastq align stats vcf

clean:
	@echo "Cleaning up files..."
	rm -f *.zip *.gz *.gz.csi
	rm -rf bam ncbi_dataset reads refs vcf

.PHONY: usage refs fastq index align stats vcf all clean
