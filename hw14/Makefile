# Custom makefile settings
SHELL = bash
.ONESHELL:
.SHELLFLAGS = -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

usage:
	@echo "#"
	@echo "# Create RNA-seq count matrix"
	@echo "#"
	@echo "# Usage: make [target]"
	@echo "#"
	@echo "# Targets:"
	@echo "#  usage - Show the targets"
	@echo "#  count - Run the count pipeline"
	@echo "#  post-count - Run the post-count pipeline"
	@echo "#  diffexpr - Run the differential expression analysis"
	@echo "#  post-diffexpr - Run the post-differential expression pipeline"
	@echo "#  clean - Remove all files"
	@echo "#"

count:
	@echo "Running the RNA-seq count matrix pipeline..."
	# Download the data
	wget -nc  http://data.biostarhandbook.com/data/uhr-hbr.tar.gz
	
	# Unpack the data
	tar xzvf uhr-hbr.tar.gz
	
	# Index the genome
	make -f src/run/hisat2.mk index REF=refs/chr22.genome.fa
	
	# Run Hisat2
	cat design.csv | parallel -v --eta --lb --header : --colsep , \
				make -f src/run/hisat2.mk \
				REF=refs/chr22.genome.fa \
				R1=reads/{sample}_R1.fq  \
				BAM=bam/{sample}.bam \
				run
				
	# Count reads
	featureCounts -a refs/chr22.gtf -o counts.txt \
			bam/HBR_1.bam \
			bam/HBR_2.bam \
			bam/HBR_3.bam \
			bam/UHR_1.bam \
			bam/UHR_2.bam \
			bam/UHR_3.bam 

post-count: # Change to stats environment prior to running this target
	Rscript src/r/format_featurecounts.r -c counts.txt -o counts.csv 
	Rscript src/r/create_tx2gene.r -s > names.txt
	Rscript src/r/create_tx2gene.r -d hsapiens_gene_ensembl
	Rscript src/r/format_featurecounts.r -c counts.txt -t tx2gene.csv -o counts.csv

diffexpr:
	Rscript src/r/edger.r

post-diffexpr:
	src/r/plot_pca.r -c edger.csv
	src/r/plot_heatmap.r -c edger.csv
	Rscript plot_volcano.r

clean:
	@echo "Cleaning up files..."
	rm -f *.gz *.txt counts.csv *.summary *.pdf edger.csv tx2gene.csv *.png .Rhistory
	rm -rf reads refs bam

.PHONY: usage count post clean
