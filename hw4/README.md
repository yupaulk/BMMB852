## Instructions:
To run the Shell script, go to the location of gff-igv.sh, then execute the following:
```
bash gff-igv.sh
```

## Report:
### Replication of Tram Ha's week3 run
Go to tram directory
```
cd tram
```

Execute the following:
```
bash gff-igv-tram.sh
```

I tweaked a bit to use wget instead of datasets command that she used. I used the following configurations:
```
GENOME_URL="https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/146/045/GCF_000146045.2_R64/GCF_000146045.2_R64_genomic.fna.gz"
GFF_URL="https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/146/045/GCF_000146045.2_R64/GCF_000146045.2_R64_genomic.gff.gz"
GENOME="genome-tram.fa"
GFF="species-tram.gff"
GENES="genes-tram.gff"
CUSTOM="custom-tram.gff3"
ACCESSION="NC_001133.9"
```

It worked perfectly!

### Replication of Hahn Tran's week3 run
Go to hahn directory
```
cd hahn
```

Execute the following:
```
bash gff-igv-hahn.sh
```

Coincidentally, we both used the same species (SARS-COV2), so the URL I used are similar to mine. I used the following configurations:
```
GENOME_URL="http://ftp.ensemblgenomes.org/pub/viruses/fasta/sars_cov_2/dna/Sars_cov_2.ASM985889v3.dna.toplevel.fa.gz"
GFF_URL="http://ftp.ensemblgenomes.org/pub/viruses/gff3/sars_cov_2/Sars_cov_2.ASM985889v3.101.gff3.gz"
GENOME="genome-hahn.fa"
GFF="species-hahn.gff"
GENES="genes-hahn.gff"
CUSTOM="custom-hahn.gff3"
ACCESSION=MN908947.3
```

It worked perfectly!
