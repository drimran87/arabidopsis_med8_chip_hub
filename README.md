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
hubDirectory/
  ├─ hub.txt
  ├─ genomes.txt
  └─ tair10/
     ├─ trackDb.txt
     ├─ tair10.2bit
     ├─ tair10.chrom.sizes
     ├─ tair10.araport11.genes.bb            # built below
     └─ tair10.araport11.transcripts.bb      # built below
