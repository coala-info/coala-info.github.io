# Use Case: ATAC-Seq Analysis

## Overview

This use case demonstrates how to use Coala to perform query-driven ATAC-Seq analysis, including peak calling using ([MACS3](#macs3)), peak annotation using ([ChIPseeker](#chipseeker)), and peak visualization using ([pyGenomeTracks](#pygenometracks)). We'll use the GSE180599 dataset as an example, which contains ATAC-Seq data from BT549 triple-negative breast cancer cells in the presence of MUC1 protein.

<!-- 
We will start with a BAM file from BT-549 cell line (chr22 data); run MACS3 to call peaks using paired-end mode; adjust q-value cutoff to call a more stringent peak set; annotate peaks with genomic features using ChIPSeeker; and visualize peaks in a specific genomic region using pyGenomeTracks.

### About the Dataset
-->


## Setup

### MCP Server Configuration

Start an MCP server with ATAC-Seq analysis tools as shown in `examples/atac-seq/atac_question.py`:

```python
from coala.mcp_api import mcp_api
import os
base_dir = os.path.dirname(__file__)

mcp = mcp_api(host='0.0.0.0', port=8000)
mcp.add_tool(os.path.join(base_dir, 'macs3_callpeak.cwl'))
mcp.add_tool(os.path.join(base_dir, 'peakAnno.cwl'))
mcp.add_tool(os.path.join(base_dir, 'pygenometracks_peak.cwl'))
mcp.serve()
```

This server exposes three tools:
- **`macs3_callpeak`**: Calls peaks from ATAC-Seq data using ([MACS3](#macs3))
- **`ChIPSeeker`**: Annotates peaks with genomic features using ([ChIPseeker](#chipseeker))
- **`pygenometracks_peak`**: Visualizes peaks and coverage tracks alongside gene annotations using ([pyGenomeTracks](#pygenometracks))

### MCP Client Configuration

Configure your MCP client (e.g., Claude Desktop, Cursor) to connect to the MCP server:

```json
{
    "mcpServers": {
        "atacseq": {
            "command": "python",
            "args": ["/path/to/examples/atac-seq/atac_question.py"]
        }
    }
}
```

Note: Replace `/path/to/examples/atac-seq/atac_question.py` with the actual path to the `atac_question.py` file in your workspace.

## Use Case Workflow

For demo purposes, we utilize human ATAC-Seq data from the BT-549 human triple negative breast cancer cell line ([Bhattacharya and et al.](https://doi.org/10.1158/1541-7786.MCR-21-0672)), using only the reads mapped to chromosome 22. The alignment file is in BAM format for the paired-end ATAC-seq library.

### Step 1: Peak Calling

**User Query:**
> Here is a BAM file for the ATAC-seq data: BT549_Doxminus_chr22.bam. Call peaks for the BAM file using paired end mode, and summarize the number of peaks. Use genome size of 5e7 which is approximately the size for human chromosome 22. Keep all duplicate tags. Save extended fragment pileup and local lambda tracks at every bp into a bedGraph file. Do not call subpeak summits.

**Chat Response:**

> Peak calling completed successfully. Summary:
> 
> **Parameters used:**
> - **Input file**: BT549_Doxminus_chr22.bam
> - **Mode**: Paired-end (BAMPE)
> - **Genome size**: 5e7 (50,000,000 bp)
> - **Duplicate handling**: Keep all duplicates
> - **BedGraph output**: Enabled (extended fragment pileup and local lambda tracks)
> - **Subpeak summits**: Disabled
> 
> **Results:**
> - **Total number of peaks**: **815 peaks**
> 
> The output files include:
> - `BT549_Doxminus_chr22_peaks.narrowPeak` - Peak locations in BED6+4 format (815 peaks)
> - `BT549_Doxminus_chr22_treat_pileup.bdg` - Treatment bedGraph file with extended fragment pileup
> - `BT549_Doxminus_chr22_control_lambda.bdg` - Control bedGraph file with local lambda tracks
> - `BT549_Doxminus_chr22_peaks.xls` - Detailed peak information in tabular format
> 
> All peaks are on chromosome 22, as expected from the input BAM file.
>
> ```
> Tool Invocation Summary:
> tool_name: macs3_callpeak
> tool_version: quay.io/biocontainers/macs3:3.0.3--py39h0699b22_0
> ```

### Step 2: Call Peaks with Stringent Q-value Cutoff

**User Query:**
> Set a more stringent q value cutoff 0.001 and rerun peak calling, summarize the number of peaks.

**Chat Response:**

> Peak calling with q-value cutoff 0.001 completed. Summary:
> 
> **Parameters used:**
> - **Input file**: BT549_Doxminus_chr22.bam
> - **Mode**: Paired-end (BAMPE)
> - **Genome size**: 5e7 (50,000,000 bp)
> - **Duplicate handling**: Keep all duplicates
> - **Q-value cutoff**: 0.001 (more stringent)
> - **BedGraph output**: Enabled
> - **Subpeak summits**: Disabled
> 
> **Results:**
> - **Total number of peaks**: **559 peaks**
> 
> ## Comparison
> 
> - **Default q-value (0.05)**: 815 peaks
> - **Stringent q-value (0.001)**: 559 peaks
> - **Reduction**: 256 fewer peaks (31.4% reduction)
> 
> The more stringent cutoff (0.001) retains only peaks with higher statistical significance, reducing the count from 815 to 559.
>
> ```
> Tool Invocation Summary:
> tool_name: macs3_callpeak
> tool_version: quay.io/biocontainers/macs3:3.0.3--py39h0699b22_0
> ```

### Step 3: Annotate Peaks

**User Query:**
> Annotate the peak set from q-value cutoff 0.001.

**Chat Response:**

> Peak annotation completed. Summary:
> 
> **Input:** 559 peaks from BT549_Doxminus_chr22_q001_peaks.narrowPeak
> 
> ### Annotation Summary by Genomic Feature:
> 
> | Genomic Feature | Number of Peaks | Percentage |
> |----------------|-----------------|------------|
> | **Promoter regions** | **376** | **67.3%** |
> | - Promoter (≤1kb) | 332 | 59.4% |
> | - Promoter (1-2kb) | 25 | 4.5% |
> | - Promoter (2-3kb) | 19 | 3.4% |
> | **Distal Intergenic** | **85** | **15.2%** |
> | **Intron** | **73** | **13.1%** |
> | **Exon** | **13** | **2.3%** |
> | **3' UTR** | **10** | **1.8%** |
> | **5' UTR** | **1** | **0.2%** |
> | **Downstream (≤300bp)** | **1** | **0.2%** |
> | **Total** | **559** | **100%** |
> 
> ### Key Findings:
> - Most peaks (67.3%) are in promoter regions, which is consistent with ATAC-seq detecting open chromatin near transcription start sites.
> - 15.2% are in distal intergenic regions, likely representing enhancers or other regulatory elements.
> - 13.1% are in introns, possibly representing intronic enhancers.
> - A small fraction (2.3%) are in exons.
> 
> ### Output Files:
> - **Annotation CSV**: `BT549_Doxminus_chr22_q001_peaks.narrowPeak_peakAnno.csv` - Detailed annotation with gene IDs, transcript IDs, and distances to TSS
> - **Pie chart**: `BT549_Doxminus_chr22_q001_peaks.narrowPeak_AnnoPie.pdf` - Visual summary of peak distribution
>
> ```
> Tool Invocation Summary:
> tool_name: ChIPSeeker
> tool_version: hubentu/bioconductor-chipseeker:1.42.0
> ```

**Peak Annotation Visualization:**
![ATAC-Seq Peak Annotation](./BT549_Doxminus_chr22_q001_peaks.narrowPeak_AnnoPie.pdf)

*Figure: ChIPseeker pie chart showing the distribution of ATAC-Seq peaks across various genomic features. The chart displays the percentage of peaks falling into different genomic regions such as promoters, introns, exons, 5' UTR, 3' UTR, and intergenic regions, providing insight into where accessible chromatin regions are located relative to gene structures.*

### Step 4: Visualize Peaks

**User Query:**
> let's visualize the peak in the chr22:23,161,760-23,359,701 region in a genome browser view.

**Chat Response:**

> Genome browser visualization created successfully. Summary:
> 
> **Region visualized:** chr22:23,161,760-23,359,701  
> **Output file:** `BT549_Doxminus_chr22_region_visualization.pdf` (55 KB)
> 
> ### Visualization Tracks:
> 1. **Coverage track** - ATAC-seq signal (bedGraph) showing chromatin accessibility
> 2. **Peaks track** - MACS3-called peaks (narrowPeak format) from q-value 0.001
> 3. **Gene annotation track** - Gene annotations from chr22_gene.bed
> 
> ### Peaks in this Region:
> 4 peaks found in the visualized region:
> 
> | Peak ID | Start | End | Score | Signal Value | -log10(qvalue) |
> |---------|-------|-----|-------|--------------|----------------|
> | Peak 95 | 23,178,580 | 23,178,856 | 86 | 4.80 | 8.60 |
> | Peak 96 | 23,180,202 | 23,180,785 | 113 | 5.55 | 11.31 |
> | Peak 97 | 23,281,795 | 23,282,045 | 145 | 7.37 | 14.59 |
> | Peak 98 | 23,315,515 | 23,316,031 | 240 | 11.87 | 24.06 |
> 
> The visualization shows:
> - ATAC-seq coverage across the region
> - The 4 called peaks as boxes
> - Gene annotations for context
> 
> The PDF file is saved and ready for viewing.
>
> ```
> Tool Invocation Summary:
> tool_name: pygenometracks_peak
> tool_version: quay.io/biocontainers/pygenometracks:3.9--pyhdfd78af_0
> ```

**Generated Peak Visualization:**

![ATAC-Seq Peak Visualization](./BT549_Doxminus_chr22_region_visualization.pdf)

*Figure: pyGenomeTracks output showing the chr22:23,161,760-23,359,701 region. The plot displays ATAC-Seq read coverage (top track), called peaks (middle track), and the gene annotations (bottom track). Four peaks are visible in this region, corresponding to accessible chromatin regions identified by MACS3 with q-value cutoff of 0.001.*

## Key Benefits

1. **Natural Language Interface**: Complex peak calling accessible through simple queries
2. **Automatic Tool Chaining**: Results from peak calling are automatically used for annotation and visualization
3. **Reproducible Analysis**: All tools run in containerized environments with specified versions
4. **Human-in-the-Loop Analysis**: Users can adjust parameters like q-value thresholds and visualization regions through natural language

## Technical Details

### Tool Execution

All tools execute in Docker containers as specified in their CWL definitions:
- **macs3**: Model-based Analysis of ChIP-Seq (v3.0.3)
- **ChIPseeker**: ChIP peak annotation (v1.42.0)
- **pyGenomeTracks**: Genome browser track visualization (v3.9)

### MACS3 Parameters Explained

| Parameter | Value | Description |
|-----------|-------|-------------|
| `format` | BAMPE | Paired-end mode for ATAC-seq data |
| `gsize` | 5e7 | The effective size of human chromosome 22 |
| `keepdup` | all | Retains all duplicate reads |
| `bdg` | true | Outputs bedGraph files for visualization |
| `summits` | false | Do not call subpeak summits |
| `qvalue` | 0.001 | Minimum FDR threshold for peak calling (default: 0.05) |

### Data Flow

1. ATAC-Seq reads (BAM format) are processed by macs3 in paired-end mode
2. MACS3 identifies enriched regions (peaks) representing open chromatin
3. bedGraph coverage tracks are generated for visualization
4. q-value tweaking is demonstrated during peak calling to control false discovery rate
5. ChIPseeker annotates peaks with genomic features (promoters, introns, exons, intergenic) and nearest genes
6. pyGenomeTracks combines peaks, coverage, and gene annotations into a single plot

### Output Files

| Step | File | Description |
|------|------|-------------|
| 1 | `*_peaks.narrowPeak` | Peak locations (BED6+4 format) |
| 1 | `*_peaks.xls` | Detailed peak statistics |
| 1 | `*_treat_pileup.bdg` | Treatment coverage (bedGraph) |
| 1 | `*_control_lambda.bdg` | Local background estimate |
| 2 | `*_q001_peaks.narrowPeak` | Peaks filtered by q-value threshold (0.001) during calling |
| 2 | `*_q001_treat_pileup.bdg` | Treatment coverage for stringent peak set |
| 2 | `*_q001_control_lambda.bdg` | Control lambda tracks for stringent peak set |
| 3 | `*_peakAnno.csv` | Peak annotation with genomic features |
| 3 | `*_AnnoPie.pdf` | Pie chart of peak distribution by feature |
| 4 | `*_region_visualization.pdf` | Genome browser visualization |

## Extending the Workflow

This use case can be extended to:
- Compare peaks between conditions using differential peak analysis
- Perform motif analysis on peak sequences
- Integrate with RNA-Seq data for multi-omic analysis
- Generate signal heatmaps around transcription start sites
- Identify transcription factor footprints within peaks
- Export peaks to UCSC Genome Browser or IGV
- Filter peaks by additional criteria (fold enrichment, p-value, etc.)

All of these extensions can be implemented by adding additional CWL tools to the MCP server and querying them through natural language.

## Reference

<a id="MACS3"></a>
MACS3
https://github.com/macs3-project/MACS

<a id="chipseeker"></a>
ChIPseeker
https://www.bioconductor.org/packages/release/bioc/html/ChIPseeker.html

<a id="pygenometracks"></a>
pyGenomeTracks
https://github.com/deeptools/pyGenomeTracks

<!--
### What is ATAC-Seq?

In many eukaryotic organisms, such as humans, the genome is tightly packed and organized with the help of nucleosomes (chromatin). A nucleosome is a complex formed by eight histone proteins that is wrapped with ~147bp of DNA. When the DNA is being actively transcribed into RNA, the DNA will be opened and loosened from the nucleosome complex.

**A**ssay for **T**ransposase-**A**ccessible **C**hromatin using **seq**uencing (ATAC-Seq) is a method to investigate the accessibility of chromatin and thus a method to determine regulatory mechanisms of gene expression. The method can help identify:
- **Promoter regions**: DNA regions close to the transcription start site (TSS) containing binding sites for transcription factors
- **Enhancers**: DNA regions that can be located up to 1 Mb downstream or upstream of the promoter that increase transcription
- **Silencers**: DNA regions that decrease or inhibit gene expression

### How ATAC-Seq Works

With ATAC-Seq, to find accessible (open) chromatin regions, the genome is treated with a hyperactive derivative of the **Tn5 transposase**. During ATAC-Seq:

1. The modified Tn5 inserts DNA sequences corresponding to truncated Nextera adapters into open regions of the genome
2. Concurrently, the DNA is sheared by the transposase activity
3. The read library is then prepared for sequencing, including PCR amplification with full Nextera adapters

ATAC-Seq has become popular for identifying accessible regions of the genome as it's easier, faster, and requires fewer cells than alternative techniques such as FAIRE-Seq and DNase-Seq.
-->

