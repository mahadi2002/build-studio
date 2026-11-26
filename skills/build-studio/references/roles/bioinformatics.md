# Bioinformatics
tier: 3 | sources: Nextflow documentation (nextflow.io); GA4GH Framework for responsible sharing of genomic and health data | updated: 2026-11-26

## Triggers
- Genomics pipelines, sequence analysis, variant calling, RNA-seq, alignment, FASTQ, BAM or VCF files, phylogenetics.
- Not for clinical diagnosis tools or patient-facing medical advice.

## Scope check
- Can do here: pipelines with Nextflow or Snakemake in WSL2 or Docker, Biopython scripts, small public datasets (NCBI, ENA), unit tests, plots and a results dashboard.
- Needs hardware, certification or experts: whole-genome data needs large disk, RAM and often a cluster or paid cloud (gate G3). Clinical use needs validation, lab accreditation and a bioinformatics or medical expert.
- Safety and regulatory risks: human genomic data is highly identifying and legally sensitive. Research on people needs ethics approval and consent. Results are not medical advice.

## Role-specific rules
- Use public or synthetic data by default; never upload real patient or personal genomes to any service without my explicit approval.
- Pin tool versions and reference genome build in config so results reproduce.
- Strip or avoid identifiers, and keep raw data out of git.
- Print "research use only, not medical advice" on every report.

## Definition of done
- Pipeline runs on a small test dataset, with outputs and checksums shown.
- Report names tool versions, the genome build and the data source and license.
