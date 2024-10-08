## 1. Tell us a bit about the organism

In GFF3, the #! specifies information about the species being annotated. We can get the accession ID, which is GCA_000280705.1.
With a quick google search on the accession ID, we can access the emsembl information about it. Here is the [link](https://useast.ensembl.org/Jaculus_jaculus/Info/Annotation)
The Lesser Egyptian jerboa is a small rodent native to Africa and the Middle East. It primarily feeds on seeds and grasses and requires minimal water to survive.

### Steps:

a. Go to home directory:
```
cd ~
```

b. Create a hw2 folder
```
mkdir hw2
```

c. Go to hw2 folder
```
cd hw2
```

d. Download Jaculus jaculus GFF3 gzip file
```
wget https://ftp.ensembl.org/pub/current_gff3/jaculus_jaculus/Jaculus_jaculus.JacJac1.0.112.gff3.gz
```
e. Unzip the GFF3 file
```
gunzip Jaculus_jaculus.JacJac1.0.112.gff3.gz
```

f. Get extra information
```
cat Jaculus_jaculus.JacJac1.0.112.gff3 | grep '#!'
```

Output:
```
#!genome-build  JacJac1.0
#!genome-version JacJac1.0
#!genome-date 2012-07
#!genome-build-accession GCA_000280705.1
#!genebuild-last-updated 2020-03
```

## 2. How many features does the file contain?

GFF3 format consists of one feature per line. The file contains 891,850 features.

### Steps:

Follow steps a-e in Item 1, then

f. Count the number of lines of the file
```
cat Jaculus_jaculus.JacJac1.0.112.gff3 | wc -l
```

Output:
```
891850
```

## 3. How many sequence regions (chromosomes) does the file contain?

By counting the lines containing the word 'sequence-regions' uniquely, we found that there are 10,898 of them.

### Steps:

Follow steps a-e in Item 1, then

f. Count the number of lines containing the word 'sequence-region' uniquely
```
cat Jaculus_jaculus.JacJac1.0.112.gff3 | grep 'sequence-region' | uniq |  wc -l
```

Output:
```
10898
```

## 4. How many genes are listed for this organism?

By counting the lines containing the word 'gene' uniquely, we found that there are 10,898 of them.

### Steps:

Follow steps a-e in Item 1, then

f. Count the number of lines containing the word 'gene' uniquely
```
cat Jaculus_jaculus.JacJac1.0.112.gff3 | grep 'gene' | uniq |  wc -l
```

Output:
```
10898
```

## 5. What are the top-ten most annotated feature types (column 3) across the genome?

The top 10 msot annotated feature types are: 
(1) transcript, (2) three_prime_UTR, (3) tRNA, (4) snoRNA, (5) snRNA, (6) scaffold, (7) scRNA, (8) rRNA, (9) pseudogenic_transcript, (10) pseudogene

### Steps:

Follow steps a-e in Item 1, then

f. Remove lines with '#' directive, get the third column, then sort descending the top 10 unique feature types.
```
cat Jaculus_jaculus.JacJac1.0.112.gff3 | grep -v '#' | cut -f 3 | sort -rn | uniq | head -10
```

Output:
```
transcript
three_prime_UTR
tRNA
snoRNA
snRNA
scaffold
scRNA
rRNA
pseudogenic_transcript
pseudogene
```
        
## 6. Having analyzed this GFF file, does it seem like a complete and well-annotated organism?

I think this is an incomplete annotation. The only feature types are shown in the output below. 
We are missing features such as enhancers, promoters, SNPs, repeats, transposable elements.

### Steps:

Follow steps a-e in Item 1, then

f. List all feature types and their counts
```
cat Jaculus_jaculus.JacJac1.0.112.gff3 | grep -v '#' | cut -f 3 | sort-uniq-count-rank
```

Output:
```
279269  exon
266999  CDS
215695  biological_region
25180   mRNA
17845   gene
10898   scaffold
9209    five_prime_UTR
7344    three_prime_UTR
6267    ncRNA_gene
2500    snRNA
1287    snoRNA
1250    transcript
832     rRNA
321     pseudogene
321     pseudogenic_transcript
309     miRNA
46      scRNA
22      tRNA
21      lnc_RNA
```
