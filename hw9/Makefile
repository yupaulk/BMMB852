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

# BAM file
SIMBAM=bam/sim_vibrio.bam

# The number of reads to simulate or download
N=100000

# Read length for fastq simulation
READ_LENGTH=150

# Seed for wgsim (do not change for reproducibility)
SEED=8552

# The first read file
SIM1=sim_reads/${SRR}_1.fastq

# The first read file
SIM2=sim_reads/${SRR}_2.fastq

.PHONY: usage refs simulate fastq index align stats all clean

usage:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  usage - Show the targets"
	@echo "  refs  - Download the reference genome"
	@echo "  simulate - Simulate reads"
	@echo "  fastq - Download reads from SRA"
	@echo "  index - Index the reference genome"
	@echo "  align - Align the reads and convert to BAM"
	@echo "  stats - Generate alignment statistics"
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
	
	# Copy the genome to the reference file.
	cp -f ncbi_dataset/data/${ACC}*/${ACC}*_genomic.fna ${REF}

# Simulate reads
simulate:
	# Simulate fastq using wgsim
	@echo "Simulating fastq using wgsim..."
	mkdir -p sim_reads
	wgsim -N ${N} -1 ${READ_LENGTH} -2 ${READ_LENGTH} -r 0 -R 0 -X 0 -S ${SEED} ${REF} ${SIM1} ${SIM2}

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
	bwa mem -t 4 ${REF} ${SIM1} ${SIM2} | samtools sort > ${SIMBAM}

	# Index the BAM file
	samtools index ${BAM}
	samtools index ${SIMBAM}

# Generate alignment statistics
stats:
	samtools flagstat ${BAM}
	samtools flagstat ${SIMBAM}

all: refs simulate fastq index align stats

clean:
	@echo "Cleaning up files..."
	rm -f *.zip
	rm -rf bam ncbi_dataset reads refs sim_reads
