# Use Cases

This section contains use cases demonstrating how to use Coala in various scenarios.
<!--//## Available Use Cases-->

### [Gene Variant Analysis](./Gene-Variant.md)

This use case demonstrates how to use Coala to perform query-dirven gene-variant analysis: retrieving gene coordinates from NCBI, extracting variants from ClinVar VCF files, filtering by clinical significance, and performing detailed variant annotation. 

### [RNA-Seq Analysis](./RNA-Seq.md)

This use case demonstrates how to use Coala to perform query-driven RNA-Seq analysis: downloading data from GEO, describing study design information, performing differential gene expression (DEG) analysis, downloading curated gene sets from MSigDB, running Gene Set Enrichment Analysis (GSEA) with canonical pathways, and generating enrichment plots for specified pathways.

### [ATAC-Seq Analysis](./ATAC-Seq.md)

This use case demonstrates how to use Coala to perform query-driven ATAC-Seq analysis, including peak calling using [`MACS3`](https://github.com/macs3-project/macs), peak annotation using [`ChIPseeker`](https://github.com/YuLab-SMU/ChIPseeker), and peak visualization using [`pyGenomeTracks`](https://github.com/deeptools/pyGenomeTracks).

### [Hi-C Analysis](./Hi-C.md)

This use case demonstrates how to use Coala to perform query-driven Hi-C analysis and visualization. We use [`cooler`](https://open2c.github.io/cooler/) and [`cooltools`](https://cooltools.readthedocs.io/en/latest/) to visualize chromatin contact maps, compartmentalize chromosome into active (A) and inactive (B) regions, and indentify boundaries between topologically associating domains (TADs).  

