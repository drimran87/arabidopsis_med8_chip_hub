# Arabidopsis TAIR10 Track Hub for Mediator ChIP-seq)
This repository documents how we created a public **UCSC Track Hub** for our Mediator ChIP-seq (anti-Med8) on *Arabidopsis thaliana*: wild-type **Col-0** and **med18** mutants under control conditions.

We use a custom TAIR10 genome with chromosome names **Chr1–Chr5, ChrC, ChrM**. Because those names can differ from UCSC’s stock assemblies, we built our **own hub** so the data render correctly.

*UCSC’s guide: Setting up your own tracks

*Our assembly key in this hub: tair10 (with Chr names)

## Overview
Following are some of the steps we have been through

**1. Format data for UCSC**: our signal tracks are bigWig files (compatible with the Genome Browser), so for us the formating stuff was straight-forward.

**2. Host large files**: The files need to be stored on internet accissible web or ftp server. We store bigWigs on Figshare (GitHub has size limits). You’ll need a direct download link for each file: in Figshare go to your item → Manage files → … (Actions) → copy the download URL (it should be https://ndownloader.figshare.com/files/<ID>; add ?private_link=<TOKEN> if the item is private).

**3. Create a GitHub repo** for the hub control files and any small annotation files. The minimal structure:
```plaintext
hubDirectory/
  ├─ hub.txt
  ├─ genomes.txt
  └─ tair10/
     ├─ trackDb.txt
     ├─ tair10.2bit
     ├─ tair10.chrom.sizes
     ├─ tair10.araport11.genes.bb            # built below
     └─ tair10.araport11.transcripts.bb      # built below
```
## Prerequisites, tools etc

We used a conda env for core UCSC tools but got into problems with some OpenSSL issues therefore, switched to Docker (BioContainers) for a few utilities that otherwise required legacy OpenSSL.

```bash
# create / use the working env
conda create -n ucsc -c bioconda -c conda-forge \
  ucsc-fatotwobit ucsc-twobitinfo ucsc-bedtobigbed ucsc-bigwiginfo
conda activate ucsc

```
If any UCSC binary complains about libssl.so.1.0.0, run that specific step **via Docker** 
## Build the genome files (Chr naming)
Our FASTA headers already use Chr1–Chr5, ChrC, ChrM: For compatibility with UCSC genome, we need to convert it into ```.2bit``` file see below

```bash
faToTwoBit TAIR10_chr.fa tair10/tair10.2bit
twoBitInfo  tair10/tair10.2bit stdout > tair10/tair10.chrom.sizes
```
## Build the Araport11 gene annotations (gene IDs)

We generate two helpful tracks:

*Genes (BED6) — one locus per AT gene (labels like AT1G01010).

*Transcripts (BED12) — exon structures per transcript (labels like AT1G01010.1).
### A) For the first one lets use ```awk``` as below
```bash
awk 'BEGIN{FS=OFS="\t"}
  $3=="gene" {
    match($9,/gene_id "([^"]+)"/,m); name=(m[1]?m[1]:".");
    print $1,$4-1,$5,name,0,$7
  }' Araport11_GTF_genes_transposons.Oct2023.gtf \
| sort -k1,1 -k2,2n > tair10/tair10.genes.bed

bedToBigBed -type=bed6 tair10/tair10.genes.bed \
  tair10/tair10.chrom.sizes tair10/tair10.araport11.genes.bb
```
### Transcript IDs (BED12)
We used *docker and pulled container immage for ```gtftogenepred```, ```genepredtobed```, and ```bedtobigbed``` to execute this step


```bash
# 1) GTF -> genePred
docker pull quay.io/biocontainers/ucsc-gtftogenepred:482--h0b57e2e_0
docker run --rm \
  -u $(id -u):$(id -g) \
  -v "$PWD":/work -w /work \
  quay.io/biocontainers/ucsc-gtftogenepred:482--h0b57e2e_0 \
  gtfToGenePred -genePredExt -ignoreGroupsWithoutExons \
  Araport11_GTF_genes_transposons.Oct2023.gtf araport11.gp

# 2) genePred -> BED12
docker pull quay.io/biocontainers/ucsc-genepredtobed:469--h664eb37_1
docker run --rm \
  -u $(id -u):$(id -g) \
  -v "$PWD":/work -w /work \
  quay.io/biocontainers/ucsc-genepredtobed:469--h664eb37_1 \
  genePredToBed araport11.gp araport11.tx.bed

# 3) sort & build bigBed
sort -k1,1 -k2,2n araport11.tx.bed > araport11.tx.sorted.bed

docker pull quay.io/biocontainers/ucsc-bedtobigbed:482--hdc0a859_0
docker run --rm \
  -u $(id -u):$(id -g) \
  -v "$PWD":/work -w /work \
  quay.io/biocontainers/ucsc-bedtobigbed:482--hdc0a859_0 \
  bedToBigBed -type=bed12+ araport11.tx.sorted.bed \
  tair10/tair10.chrom.sizes tair10/tair10.araport11.transcripts.bb
```
## Hub control files
```hub.txt```

