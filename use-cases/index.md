# Use Cases

This section contains use cases demonstrating how to use Coala in various scenarios.
<!--//## Available Use Cases-->

### [Gene Variant Analysis](./tp53-gene-analysis)

This use case demonstrates how to use Coala to perform query-dirven gene-variant analysis: retrieving gene coordinates from NCBI, extracting variants from ClinVar VCF files, filtering by clinical significance, and performing detailed variant annotation. 

### [RNA-Seq Analysis](./rnaseq-analysis)

This use case demonstrates how to use Coala to perform query-driven RNA-Seq analysis: downloading data from GEO, describing study design information, performing differential gene expression (DEG) analysis, downloading curated gene sets from MSigDB, running Gene Set Enrichment Analysis (GSEA) with canonical pathways, and generating enrichment plots for specified pathways.

### [ATAC-Seq Analysis](./atacseq-analysis)

This use case demonstrates how to use Coala to perform query-driven ATAC-Seq analysis, including peak calling using [`MACS3`](https://github.com/macs3-project/macs), peak annotation using [`ChIPseeker`](https://github.com/YuLab-SMU/ChIPseeker), and peak visualization using [`pyGenomeTracks`](https://github.com/deeptools/pyGenomeTracks).

### [Hi-C Analysis](./hi-c-analysis.md)

This use case demonstrates how to use Coala to perform query-driven Hi-C analysis and visualization. We use [`cooler`](https://open2c.github.io/cooler/) and [`cooltools`](https://cooltools.readthedocs.io/en/latest/) to visualize chromatin contact maps, compartmentalize chromosome into active (A) and inactive (B) regions, and indentify boundaries between topologically associating domains (TADs).  

<!--
### [PDF Page Extraction and Combination](./pdf-operations)

This use case demonstrates how to use the Tool Agent framework to perform PDF manipulation operations: extracting specific pages from a PDF file and combining multiple PDF files into one. These operations are commonly needed for document management, report generation, and file organization tasks.

## Key Benefits

- **Natural Language Interface**: Complex bioinformatics workflows are accessible through simple queries
- **Automatic Tool Discovery**: The LLM automatically selects the appropriate tools based on the task
- **Parameter Extraction**: Genomic coordinates are automatically extracted from gene metadata for downstream analysis
- **Containerized Execution**: Tools run in isolated containers, ensuring reproducibility and avoiding dependency conflicts
- **Seamless Integration**: Multiple tools work together in a single workflow without manual intervention
- **Human-in-the-Loop**: Review and refine tool inputs/outputs while keeping the workflow moving
-->
