## Week 9: Filter a BAM file

The reference genome is a Vibrio cholerae whole genome sequence with Accession ID: GCF_008369605.1. The SRR is a Vibrio cholerae with SRR ID: SRR31137229. 

### Instructions:
Make sure you are in the bioinfo environment
```
conda activate bioinfo
```

Targets:
- usage - Show the targets
- refs  - Download the reference genome
- simulate - Simulate reads
- fastq - Download reads from SRA
- index - Index the reference genome
- align - Align the reads and convert to BAM
- stats - Generate alignment statistics
- all   - Run entire pipeline
- clean - Remove all files

To run a target
```
make [target]
```

To run entire pipeline
```
make all
```

Please clean files at the end of the run
```
make clean
```

We will be using the BAM file located in the bam directory
```
vibrio.bam
```

### Question 1: How many reads did not align with the reference genome?
```
samtools view -c -f 4 vibrio.bam
```
Output:
```
10990
```

### Question 2: How many primary, secondary, and supplementary alignments are in the BAM file?
Primary alignments:
Flag:
exclude 0x4     4       UNMAP
exclude 0x100   256     SECONDARY
```
samtools view -c -F 260 vibrio.bam
```
Output:
```
189983
```

Secondary alignments:
Flag: 
exclude 0x4     4       UNMAP
include 0x100   256     SECONDARY
```
samtools view -c -F 4 -f 256 vibrio.bam
```
Output:
```
0
```

Supplementary alignments:
Flag: 
exclude 0x4     4       UNMAP
include 0x800   2048    SUPPLEMENTARY
```
samtools view -c -F 4 -f 2048 vibrio.bam
```
Output:
```
973
```

### Question 3: How many properly-paired alignments on the reverse strand are formed by reads contained in the first pair?
Flag: 
exclude 0x4     4       UNMAP
include 0x52    82      PROPER_PAIR,REVERSE,READ1
```
samtools view -c -F 4 -f 82 vibrio.bam
```
Output:
```
46887
```

### Question 4: Make a new BAM file that contains only the properly paired primary alignments with a mapping quality of over 10
Flag:
exclude 0x4     4       UNMAP
exclude 0x100   256     SECONDARY
include 0x2     2       PROPER_PAIR

-q: as per samtools help page, quality is inclusive (>=), hence we choose 11 instead of 10.
-b: output as BAM

```
samtools view -b -q 11 -F 260 -f 2 vibrio.bam > filtered.bam
```

### Question 5: Compare the flagstats for your original and your filtered BAM file.
Original:
```
samtools flagstat vibrio.bam
```
Output:
```
200973 + 0 in total (QC-passed reads + QC-failed reads)
200000 + 0 primary
0 + 0 secondary
973 + 0 supplementary
0 + 0 duplicates
0 + 0 primary duplicates
189983 + 0 mapped (94.53% : N/A)
189010 + 0 primary mapped (94.51% : N/A)
200000 + 0 paired in sequencing
100000 + 0 read1
100000 + 0 read2
186464 + 0 properly paired (93.23% : N/A)
187788 + 0 with itself and mate mapped
1222 + 0 singletons (0.61% : N/A)
136 + 0 with mate mapped to a different chr
103 + 0 with mate mapped to a different chr (mapQ>=5)
```

Filtered:
```
samtools flagstat filtered.bam
```
Output:
```
183641 + 0 in total (QC-passed reads + QC-failed reads)
183107 + 0 primary
0 + 0 secondary
534 + 0 supplementary
0 + 0 duplicates
0 + 0 primary duplicates
183641 + 0 mapped (100.00% : N/A)
183107 + 0 primary mapped (100.00% : N/A)
183107 + 0 paired in sequencing
91570 + 0 read1
91537 + 0 read2
183107 + 0 properly paired (100.00% : N/A)
183107 + 0 with itself and mate mapped
0 + 0 singletons (0.00% : N/A)
0 + 0 with mate mapped to a different chr
0 + 0 with mate mapped to a different chr (mapQ>=5)
```
