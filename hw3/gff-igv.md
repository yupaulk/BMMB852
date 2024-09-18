## 1. Reformat your previous assignment

Check the discussion thread: List of student repositories and verify that your repository passes the requirements.

Rewrite your previous homework as a Markdown file. Commit the file next to the current file. 

Here is the [link](https://github.com/yupaulk/BMMB852/blob/main/week2/gff3-data-analysis.md) to the newly added Markdown file.

## 2. Visualize the GFF file of your choice.

Using a resource of your choice, download the genome and annotation files for an organism of your choice.

(We recommend a smaller genome to make things go faster and to look at a simpler GFF file)

Use IGV to visualize the annotations relative to the genome.
Separate intervals of type "gene" into a different file. If you don't have genes, pick another feature.
Using your editor create a GFF that represents a intervals in your genome. Load that GFF as a separate track in IGV.
Report your findings in text, and provide a few relevant screenshots.

You can attach the screenshots to CANVAS the assignment or even put them into the repository and link them to your markdown report.

Your submission needs to list the link to the markdown file in your repository so that reviews can access it.

### Steps:

a. In the Terminal, download and unzip SARS-COV2 genome
```
wget http://ftp.ensemblgenomes.org/pub/viruses/fasta/sars_cov_2/dna/Sars_cov_2.ASM985889v3.dna.toplevel.fa.gz
gunzip Sars_cov_2.ASM985889v3.dna.toplevel.fa.gz
```

b. Download unzip SARS-COV2 GFF3 annotation
```
wget http://ftp.ensemblgenomes.org/pub/viruses/gff3/sars_cov_2/Sars_cov_2.ASM985889v3.101.gff3.gz
gunzip Sars_cov_2.ASM985889v3.101.gff3.gz
```

c. Rename the files for ease-of-use
```
mv Sars_cov_2.ASM985889v3.dna.toplevel.fa genome.fa
mv Sars_cov_2.ASM985889v3.101.gff3 annotation.gff3
```

d. Open IGV and load the genome.fa and annotation.gff3 files.

e. In the Terminal, in the gff3 file find "gene" on the third column and save them to gene-annot.gff3.
```
cat annotation.gff3 | awk '$3 == "gene"'> gene-annot.gff3
```

f. Create own custom GFF3 file and add to IGV as a separate track. Save it as custom-annot.gff3. 

The contents are as shown below:
```
MN908947.3	custom	gene	300	1500	.	+	.	ID=custom_gene;Name=FooGene
```

g. Load custom-annot.gff3 to the same IGV session.

We can see the FooGene annotation on a separate track. It is forward-stranded and at the 300 to 1500 interval.
The screenshot is as shown below:

![here](https://github.com/yupaulk/BMMB852/blob/main/week3/images/igv-foogene-track.png).
