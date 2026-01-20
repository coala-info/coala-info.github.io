# Use Case: Gene Variant Analysis

## Overview

This use case demonstrates how to use Coala to perform a complete gene variant analysis workflow: retrieving gene coordinates from NCBI, extracting variants from ClinVar VCF files, filtering by clinical significance, and performing detailed variant annotation. We'll use the TP53 gene as an example, which is a critical tumor suppressor gene associated with many human cancers.

## Setup

### MCP Server Configuration

Create an MCP server with bioinformatics tools as shown in `examples/vcf_question.py`:

```python
from coala.mcp_api import mcp_api

mcp = mcp_api(host='0.0.0.0', port=8000)
mcp.add_tool('examples/ncbi_datasets_gene.cwl', 'ncbi_datasets_gene')
mcp.add_tool('examples/bcftools_view.cwl', 'bcftools_view', read_outs=False)
mcp.add_tool('examples/biothings_query.cwl', 'biothings_query')
mcp.serve()
```

This server exposes three tools:
- **`ncbi_datasets_gene`**: Retrieves comprehensive gene metadata from [NCBI Datasets](#ncbi-datasets)
- **`bcftools_view`**: Subsets and filters VCF/BCF files by genomic regions
- **`biothings_query`**: Queries biological databases (genes, variants, chemicals, diseases) via [BioThings](#biothings) APIs

### MCP Client Configuration

Configure your MCP client (e.g., in Cursor) to connect to the server:

```json
{
    "mcpServers": {
        "vcf": {
            "command": "python",
            "args": ["/path/to/examples/vcf/vcf_question.py"]
        }
    }
}
```

Note: Replace `/path/to/examples/vcf/vcf_question.py` with the actual path to the `vcf_question.py` file in your workspace.

## Use Case Workflow

### Step 1: Retrieve Gene Coordinates and Extract Variants

**User Query:**
> I am analyzing the TP53 gene for potential pathogenic variants. Please retrieve the latest gene coordinates from NCBI and extract all known variants for this region from the ClinVar VCF file. Save the vcf file to the working directory.

**Tool Invocation:**
```json
{
  "tool": "ncbi_datasets_gene",
  "parameters": {
    "gene": "TP53",
    "taxon": "human"
  }
}
```

**Tool Response:**
```json
{
  "json": "{\"reports\": [{\"gene\":{\"annotations\":[{\"annotation_name\":\"GCF_000001405.40-RS_2025_08\",\"genomic_locations\":[{\"genomic_accession_version\":\"NC_000017.11\",\"genomic_range\":{\"begin\":\"7668421\",\"end\":\"7687490\"},\"sequence_name\":\"17\"}]}],\"gene_id\":\"7157\",\"symbol\":\"TP53\",\"description\":\"tumor protein p53\"}]}",
  "tool_name": "ncbi_datasets_gene",
  "tool_version": "staphb/ncbi-datasets"
}
```

**Tool Invocation:**
```json
{
  "tool": "bcftools_view",
  "parameters": {
    "vcf": "https://ftp.ncbi.nlm.nih.gov/pub/clinvar/vcf_GRCh38/clinvar.vcf.gz",
    "region": "17:7668421-7687490",
    "fout": "tp53_clinvar_variants.vcf.gz",
    "otype": "z"
  }
}
```

**Tool Response:**
```json
{
  "Fout": {
    "basename": "tp53_clinvar_variants.vcf.gz",
    "size": 280748
  },
  "tool_name": "bcftools_view",
  "tool_version": "quay.io/biocontainers/bcftools:1.13--h3a49de5_0"
}
```

**Chat Response:**
> I've successfully retrieved the TP53 gene coordinates and extracted all variants from the ClinVar VCF file.
>
> **TP53 Gene Coordinates (GRCh38.p14):**
> - **Chromosome:** 17
> - **Genomic Range:** 7,668,421 - 7,687,490
> - **Gene ID:** 7157
> - **Gene Symbol:** TP53 (tumor protein p53)
>
> **Extracted Variants:**
> - **Source:** ClinVar VCF (GRCh38)
> - **File:** `tp53_clinvar_variants.vcf.gz`
> - **Location:** `/Users/lius/Desktop/coala-master/tp53_clinvar_variants.vcf.gz`
> - **File Size:** 274 KB (compressed)
> - **Number of Variants:** 3,763 variants
>
> The VCF file contains all ClinVar variants overlapping the TP53 gene region, including pathogenic, likely pathogenic, benign, likely benign, and variants of uncertain significance. The file is saved in compressed VCF format (gzipped) in your working directory.

### Step 2: Filter Pathogenic Variants

**User Query:**
> Please find all Pathogenic variants in the TP53 gene from that file.

**Tool Invocation:**
```json
{
  "tool": "bcftools_view",
  "parameters": {
    "vcf": "/Users/lius/Desktop/coala-master/tp53_clinvar_variants.vcf.gz",
    "include": "CLNSIG~\"Pathogenic\"",
    "fout": "tp53_pathogenic_variants.vcf.gz",
    "otype": "z"
  }
}
```

**Tool Response:**
```json
{
  "Fout": {
    "basename": "tp53_pathogenic_variants.vcf.gz",
    "size": 82178
  },
  "tool_name": "bcftools_view",
  "tool_version": "quay.io/biocontainers/bcftools:1.13--h3a49de5_0"
}
```

**Chat Response:**
> Successfully filtered pathogenic variants from the TP53 ClinVar VCF file.
>
> **Pathogenic Variants Summary:**
> - **File:** `tp53_pathogenic_variants.vcf.gz`
> - **Location:** `/Users/lius/Desktop/coala-master/tp53_pathogenic_variants.vcf.gz`
> - **File Size:** ~80 KB (compressed)
> - **Total Pathogenic Variants:** 901
>
> **Additional Information:**
> - **Likely Pathogenic Variants:** 377 (saved as `tp53_likely_pathogenic_variants.vcf.gz`)
>
> **Variant Types Found:**
> - Single nucleotide variants (SNVs)
> - Deletions
> - Insertions
> - Indels
> - Large deletions
>
> **Associated Conditions:**
> The pathogenic variants are associated with various hereditary cancer syndromes including:
> - Li-Fraumeni syndrome
> - Various hereditary cancers (breast, colorectal, stomach, hepatocellular carcinoma)
> - Adrenocortical carcinoma
> - Bone marrow failure syndrome
> - Other cancer-predisposing syndromes
>
> **Example Variants:**
> 1. Position 7669691 (C>T): Splice acceptor variant associated with Li-Fraumeni syndrome and multiple cancer types
> 2. Position 7669665 (AC>A): Frameshift deletion
> 3. Position 7670658 (T>A): Nonsense variant associated with Li-Fraumeni syndrome and lung adenocarcinoma
>
> The filtered VCF file contains all 901 pathogenic variants with ClinVar annotations, including clinical significance, disease associations, HGVS nomenclature, molecular consequences, and review status.

### Step 3: Detailed Variant Analysis

**User Query:**
> let's look into Position 7669691 (C>T)

**Tool Invocation:**
```json
{
  "tool": "biothings_query",
  "parameters": {
    "client": "variant",
    "get": "chr17:g.7669691C>T",
    "fields": "all",
    "assembly": "hg38",
    "pretty": true
  }
}
```

**Tool Response:**
```json
{
  "result": "{...comprehensive variant annotation data...}",
  "tool_name": "biothings_query",
  "tool_version": "hubentu/biothings:0.4.1"
}
```

**Chat Response:**

> **Detailed Analysis: chr17:g.7669691C>T (rs876658982)**
>
> **Basic Variant Information:**
> - **Genomic Coordinates:** Chromosome 17, Position 7,669,691 (GRCh38)
> - **Cytogenetic Location:** 17p13.1
> - **Reference Allele:** C
> - **Alternate Allele:** T
> - **dbSNP ID:** rs876658982
> - **ClinVar Variant ID:** 231146
> - **ClinGen CAID:** CA10580902
>
> **Variant Type and Molecular Consequence:**
> - **Type:** Single nucleotide variant (SNV)
> - **Molecular Consequence:** Splice acceptor variant (SO:0001574)
> - **Impact:** HIGH - affects 100% of TP53 transcripts
>
> **HGVS Nomenclature:**
> - **Genomic (GRCh38):** `NC_000017.11:g.7669691C>T`
> - **Genomic (GRCh37):** `NC_000017.10:g.7573009C>T`
> - **Coding (canonical):** `NM_000546.6:c.1101-1G>A`
>
> **Clinical Significance:**
> - **ClinVar Classification:** Pathogenic/Likely pathogenic
> - **Review Status:** Criteria provided, multiple submitters, no conflicts
> - **Multiple ClinVar records** confirming pathogenic classification
>
> **Associated Conditions:**
> This variant is associated with multiple hereditary cancer syndromes including:
> - Li-Fraumeni syndrome 1 (LFS) - OMIM:151623
> - Hereditary cancer-predisposing syndrome
> - Adrenocortical carcinoma, hereditary
> - Familial cancer of breast
> - Bone osteosarcoma
> - Glioma susceptibility 1
> - Nasopharyngeal carcinoma
> - Choroid plexus papilloma
> - Basal cell carcinoma, susceptibility to, 7
> - Familial pancreatic carcinoma
> - Hepatocellular carcinoma
> - Colorectal cancer
> - Bone marrow failure syndrome 5
>
> **Pathogenicity Predictions:**
> | Tool | Prediction | Score |
> |------|------------|-------|
> | CADD Phred | Highly deleterious | 29.1 |
> | BayesDel (with AF) | Deleterious | 0.625 (rank: 99.4%) |
> | MutationTaster | Disease-causing | 1.0 |
> | DANN | Deleterious | 0.995 (rank: 68.1%) |
> | Eigen | Deleterious | 13.77 Phred (rank: 95.6%) |
> | FATHMM-MKL | Deleterious | 0.897 |
>
> **Conservation Scores:**
> - **PhastCons (100-way vertebrate):** 1.0 (highly conserved)
> - **PhyloP (100-way vertebrate):** 3.383 (highly conserved)
> - **GERP++:** 5.31 (highly conserved)
>
> **Functional Impact:**
> This variant is located at the -1 position of a splice acceptor site, affecting splicing of multiple TP53 transcripts. It is predicted to cause aberrant splicing, potentially leading to exon skipping, intron retention, or altered protein structure/function.
>
> **Summary:** This is a well-documented pathogenic splice site mutation in TP53. The variant significantly increases cancer risk when present in the germline and is strongly associated with Li-Fraumeni syndrome and multiple cancer types. The variant should be considered pathogenic based on strong computational predictions, multiple ClinVar submissions with consistent classification, high conservation at this position, and known functional impact on splicing.

## Key Benefits

1. **Natural Language Interface**: Complex bioinformatics workflows are accessible through simple queries
2. **Automatic Tool Discovery**: The LLM automatically selects the appropriate tools based on the task
3. **Parameter Extraction**: Genomic coordinates are automatically extracted from gene metadata for downstream analysis
4. **Containerized Execution**: Tools run in isolated containers, ensuring reproducibility and avoiding dependency conflicts
5. **Seamless Integration**: Multiple tools work together in a single workflow without manual intervention
6. **Remote Data Access**: Direct access to remote VCF files without manual download
7. **Human-in-the-Loop Analysis**: Users maintain full control throughout the analysis process. You can specify different genes, adjust genomic regions, filter variants by clinical significance, change output formats, and query different VCF sources—all through natural language interaction without modifying code

## Technical Details

### Tool Execution

All tools execute in Docker containers as specified in their CWL definitions:
- **[NCBI Datasets](#ncbi-datasets)**: Queries NCBI's gene database API
- **[BCFtools](#bcftools)**: Uses bcftools 1.13 for VCF processing
- **[BioThings](#biothings)**: Queries BioThings APIs for variant annotations, including ClinVar, gnomAD, and pathogenicity predictions

### Data Flow

1. Gene metadata is retrieved as JSON from NCBI using `ncbi_datasets_gene`
2. Genomic coordinates are parsed from the metadata (chromosome 17: 7,668,421-7,687,490)
3. These coordinates are used to subset the ClinVar VCF file using `bcftools_view`
4. The subsetted VCF containing all variants (3,763 variants) is saved as a compressed file
5. Variants are filtered by clinical significance (e.g., Pathogenic) using `bcftools_view` with inclusion filters
6. Individual variants can be queried for detailed annotations using `biothings_query`, including clinical significance, population frequencies, pathogenicity predictions, and functional impact

### Output Files

The subsetted VCF file contains:
- All variants from ClinVar that overlap the TP53 gene region
- Standard VCF format with headers and variant records
- Compressed format for efficient storage

## Extending the Workflow

This use case can be extended to:
- Filter variants by clinical significance
- Annotate variants with additional databases
- Perform statistical analysis on variant frequencies
- Generate visualizations of variant distribution
- Compare variants across different populations

All of these extensions can be implemented by adding additional CWL tools to the MCP server and querying them through natural language.

## Reference

<a id="bcftools"></a>
BCFtools
https://github.com/samtools/bcftools

<a id="ncbi-datasets"></a>
NCBI Datasets (ncbi_datasets_gene)
https://github.com/ncbi/datasets

<a id="biothings"></a>
BioThings
https://biothings.io/

