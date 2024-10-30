# The first read file
R1=reads/read1.fq

# The second read file
R2=reads/read2.fq

# The accession number at SRA
SRR=SRR5790106

# The accession number for the genome
ACC=GCF_008369605.1

# Path to the genome file
GENOME_PATH="ncbi_dataset/data/${ACC}/${ACC}_ASM836960v1_genomic.fna"

# Genome short name
GENOME="vibrio.fa"

# The number of reads to simulate or download
N=100000

# Read length for fastq simulation
READ_LENGTH=150

# Seed for wgsim (do not change for reproducibility)
SEED=8552

# Trimmed read
T1=trimmed_reads/trimmed_${SRR}_1.fastq

.PHONY: usage genome simulate download trim all clean

usage:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  usage    - Show the targets"
	@echo "  genome   - Download the genome"
	@echo "  simulate - Simulate reads for the genome"
	@echo "  download - Download reads from SRA"
	@echo "  trim     - Trim reads"
	@echo "  all      - Run entire pipeline"
	@echo "  clean    - Remove all files"

genome:
	# Download the Vibrio cholerae
	@echo "Downloading the Vibrio cholerae genome from NCBI..."
	datasets download genome accession ${ACC}

	# Unpack the data
	@echo "Unpacking the data..."
	unzip -o ncbi_dataset.zip
	
	# Make a copy of the genome under a simpler name
	ln -sf ${GENOME_PATH} ${GENOME}

simulate:
	# Simulate fastq using wgsim
	@echo "Simulating fastq using wgsim..."
	mkdir -p reads
	wgsim -N ${N} -1 ${READ_LENGTH} -2 ${READ_LENGTH} -r 0 -R 0 -X 0 -S ${SEED} ${GENOME} ${R1} ${R2}

download:
	# Check metadata of ACCESSION
	@echo "Checking metadata..."
	bio search ${ACCESSION}

	# Download 100000 read pairs with fastq-dump into the reads directory
	@echo "Downloading 100000 read pairs..."
	fastq-dump -X ${N} -F --outdir reads --split-files ${SRR}

trim:
	@echo "Trimming 10 reads using fastp..."
	mkdir -p trimmed_reads
	fastp --in1 reads/${SRR}_1.fastq --out1 ${T1} --trim_front1 10

	@echo "Running fastqc..."
	fastqc ${T1}
	echo "Please open the html file manually."

all: genome simulate download trim

clean:
	@echo "Cleaning up files..."
	rm -f *.fa *.fq *.fastq *.txt *.zip *.html *.json README.md
	rm -rf ncbi_dataset
	rm -rf reads
	rm -rf trimmed_reads
