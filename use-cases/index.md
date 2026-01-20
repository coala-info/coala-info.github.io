# Use Cases

This section contains use cases demonstrating how to use Coala in various scenarios.
<!--//## Available Use Cases-->

### [Gene Variant Analysis](./tp53-gene-analysis)

This use case demonstrates how to use Coala to perform gene-variant analysis: retrieving gene coordinates from NCBI, extracting variants from ClinVar VCF files, filtering by clinical significance, and performing detailed variant annotation. 

### [RNA-Seq Analysis](./rnaseq-analysis)

This use case demonstrates how to use Coala to perform RNA-Seq analysis: downloading data from GEO, describing study design information, performing differential gene expression (DEG) analysis, downloading curated gene sets from MSigDB, running Gene Set Enrichment Analysis (GSEA) with canonical pathways, and generating enrichment plots for specified pathways.

### [ATAC-Seq Peak Calling and Visualization](./atacseq-analysis)

This use case demonstrates how to use the Tool Agent framework to perform ATAC-Seq peak calling and visualization. We use MACS3 to identify open chromatin regions from ATAC-Seq data with ATAC-specific parameters (paired end mode), ChIPSeeker to annotate peaks, and pyGenomeTracks to visualize peaks alongside gene annotations. The workflow shows how to chain peak calling with genome browser visualization through natural language.

### [PDF Page Extraction and Combination](./pdf-operations)

This use case demonstrates how to use the Tool Agent framework to perform PDF manipulation operations: extracting specific pages from a PDF file and combining multiple PDF files into one. These operations are commonly needed for document management, report generation, and file organization tasks.
<!--
## Key Benefits

- **Natural Language Interface**: Complex bioinformatics workflows are accessible through simple queries
- **Automatic Tool Discovery**: The LLM automatically selects the appropriate tools based on the task
- **Parameter Extraction**: Genomic coordinates are automatically extracted from gene metadata for downstream analysis
- **Containerized Execution**: Tools run in isolated containers, ensuring reproducibility and avoiding dependency conflicts
- **Seamless Integration**: Multiple tools work together in a single workflow without manual intervention
- **Human-in-the-Loop**: Review and refine tool inputs/outputs while keeping the workflow moving
-->
