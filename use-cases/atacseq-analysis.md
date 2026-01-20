# Use Case: ATAC-Seq Analysis

## Overview

This use case demonstrates how to use Coala to perform query-driven ATAC-Seq analysis, including peak calling using ([MACS3](#macs3)), peak annotation using ([ChIPseeker](#chipseeker)), and peak visualization using ([pyGenomeTracks](#pygenometracks)). 

<!-- 
This use case demonstrates how to use Coala to perform query-driven ATAC-Seq analysis, We'll use macs3 to identify open chromatin regions from ATAC-Seq data ([MACS3](#macs3)), ChIPseeker to annotate peaks with genomic features ([ChIPseeker](#chipseeker)), and pyGenomeTracks to visualize the peaks alongside gene annotations ([pyGenomeTracks](#pygenometracks)).

### About the Dataset
-->


## Setup

### MCP Server Configuration

Start an MCP server with ATAC-Seq analysis tools as shown in `examples/atac-seq/atacseq_query.py`:

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
- **`macs3_callpeak`**: Calls peaks from ATAC-Seq data using macs3
- **`ChIPSeeker`**: Annotates peaks with genomic features using ChIPseeker
- **`pygenometracks_peak`**: Visualizes peaks and coverage tracks alongside gene annotations using pyGenomeTracks

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

For demonstration purposes, we utilize human ATAC-Seq data from the GM12878 human lymphoblastoid cell line ([Buenrostro et al.](https://doi.org/10.1038/nmeth.2688)), using only the reads mapped to chromosome 22.

### Step 1: Call Peaks with macs3

**User Query:**
> Here is a bed file for the ATAC-seq data: SRR891268_chr22.bed. Call peaks for the bed file. To get the coverage centered on the 5’ extended 100bp each side, the extension size should be 200bp and shift size should be -100. Do not build the shifting model. Use genome size of 5e7 which is approximately the size for human chromosome 22. Keep all duplicate tags. Save extended fragment pileup and local lambda tracks at every bp into a bedGraph file. Do not call subpeak summits.
>
Reference: [Galaxy ATAC-seq tutorial](#galaxy-atac-seq-tutorial).

**Tool Invocation:**
```json
{
  "tool": "macs3_callpeak",
  "parameters": {
    "treatment": "/path/to/SRR891268_chr22.bed",
    "extsize": 200,
    "shift": -100,
    "nomodel": true,
    "gsize": "5e7",
    "keepdup": "all",
    "bdg": true,
    "summits": false,
    "name": "SRR891268_chr22",
    "qvalue":0.05
  }
}
```

**Tool Response:** (need revision)
```json
{
  "controlBdg": {
    "basename": "SRR891268_chr22_control_lambda.bdg",
    "size": 16683479
  },
  "narrowPeak": {
    "basename": "SRR891268_chr22_peaks.narrowPeak",
    "size": 18176
  },
  "summitsBed": {
    "basename": "SRR891268_chr22_summits.bed",
    "size": 12641
  },
  "teatBdg": {
    "basename": "SRR891268_chr22_treat_pileup.bdg",
    "size": 16653579
  },
  "xlsPeak": {
    "basename": "SRR891268_chr22_peaks.xls",
    "size": 20791
  },
  "tool_name": "macs3_callpeak",
  "tool_version": "quay.io/biocontainers/macs3:3.0.3--py39h0699b22_0"
}
```

**Chat Response:** (need revision)
> macs3 peak calling completed successfully. Here are the output files generated:
>
> | Output | File | Size |
> |--------|------|------|
> | **narrowPeak** | `SRR891268_chr22_peaks.narrowPeak` | 18.2 KB |
> | **Summits BED** | `SRR891268_chr22_summits.bed` | 12.6 KB |
> | **Peak XLS** | `SRR891268_chr22_peaks.xls` | 20.8 KB |
> | **Treatment bedGraph** | `SRR891268_chr22_treat_pileup.bdg` | 16.7 MB |
> | **Control lambda bedGraph** | `SRR891268_chr22_control_lambda.bdg` | 16.7 MB |
>
> All your specified parameters were applied:
> - Extension size: 200bp
> - Shift size: -100bp
> - No model building (`--nomodel`)
> - Keep all duplicate tags (`--keep-dup all`)
> - bedGraph output enabled (`--bdg`)
> - Subpeak summits detection enabled (`--call-summits`)
> ```
> Tool Invocation Summary:
> tool_name: macs3_callpeak
> tool_version: quay.io/biocontainers/macs3:3.0.3--py39h0699b22_0
> ```

### Step 2: Count Peaks

**User Query:**
> How many peaks did we get?

**Chat Response:**
> **183 peaks** were called. The `SRR891268_chr22_peaks.narrowPeak` file contains 183 peak entries (no header). The peaks are distributed across chromosomes, with most on chromosome 22, matching the input data.

### Step 3: Call a more stringent peak set by tweaking q-value

**User Query:**
> Set a more stringent q value cutoff 0.001 and rerun peak calling, summarize the number of peaks.

**Tool Invocation:**
```json
{
  "tool": "macs3_callpeak",
  "parameters": {
    "treatment": "/path/to/SRR891268_chr22.bed",
    "extsize": 200,
    "shift": -100,
    "nomodel": true,
    "gsize": "5e7",
    "keepdup": "all",
    "bdg": true,
    "summits": false,
    "qvalue": 0.001,
    "name": "SRR891268_chr22_q001"
  }
}
```

**Tool Response:**
```json
{
  "narrowPeak": {
    "basename": "SRR891268_chr22_q001_peaks.narrowPeak",
    "size": 11021
  },
  "summitsBed": {
    "basename": "SRR891268_chr22_q001_summits.bed",
    "size": 7813
  },
  "xlsPeak": {
    "basename": "SRR891268_chr22_q001_peaks.xls",
    "size": 13000
  },
  "teatBdg": {
    "basename": "SRR891268_chr22_q001_treat_pileup.bdg",
    "size": 16653579
  },
  "controlBdg": {
    "basename": "SRR891268_chr22_q001_control_lambda.bdg",
    "size": 16683479
  },
  "tool_name": "macs3_callpeak",
  "tool_version": "quay.io/biocontainers/macs3:3.0.3--py39h0699b22_0"
}
```

**Chat Response:**
> ## Peak calling summary
> 
> **Original run (q-value cutoff = 0.05):**
> - **183 peaks**
> 
> **Stringent run (q-value cutoff = 0.001):**
> - **118 peaks**
> 
> **Summary:**
> With the stricter q-value cutoff (0.001), the number of peaks decreased from 183 to 118 (a reduction of 65 peaks, ~35.5%). This filters out peaks with q-values between 0.001 and 0.05, keeping only the most statistically significant peaks.
> 
> The new output files are prefixed with `SRR891268_chr22_q001_`:
> - `SRR891268_chr22_q001_peaks.narrowPeak`
> - `SRR891268_chr22_q001_peaks.xls`
> - `SRR891268_chr22_q001_treat_pileup.bdg`
> - `SRR891268_chr22_q001_control_lambda.bdg`

### Step 4: Annotate Peaks with ChIPSeeker

**User Query:**
> Annotate the peak set from default q-value cutoff 0.05.

**Tool Invocation:**
```json
{
  "tool": "ChIPSeeker",
  "parameters": {
    "peak": "/path/to/SRR891268_chr22_peaks.narrowPeak"
  }
}
```

**Tool Response:**
```json
{
  "ann": {
    "basename": "SRR891268_chr22_peaks.narrowPeak_peakAnno.csv",
    "size": 42281
  },
  "pie": {
    "basename": "SRR891268_chr22_peaks.narrowPeak_AnnoPie.pdf",
    "size": 5813
  },
  "tool_name": "ChIPSeeker",
  "tool_version": "quay.io/biocontainers/bioconductor-chipseeker:1.42.0--r44hdfd78af_0"
}
```

**Chat Response:**
> Peak annotation completed successfully. Generated files:
>
> 1. **SRR891268_chr22_peaks.narrowPeak_peakAnno.csv** (42K) - Annotation results in CSV format with:
>    - Peak coordinates (seqnames, start, end, width)
>    - Peak metadata (V4-V10 from narrowPeak)
>    - Genomic annotation (annotation column: e.g., "Distal Intergenic", "Intron")
>    - Nearest gene information (geneId, transcriptId, distanceToTSS)
>    - Gene coordinates and strand
>
> 2. **SRR891268_chr22_peaks.narrowPeak_AnnoPie.pdf** (5.7K) - Pie chart showing the distribution of peaks across genomic features
>
> The annotation shows peaks are annotated with their genomic context, including whether they fall in promoters, introns, exons, or intergenic regions, along with the nearest gene and distance to the transcription start site (TSS).

**Peak Annotation Results Preview:**

The following table shows a preview of the peak annotation results:

| Peak ID | Chromosome | Start | End | Width | Annotation | Gene ID | Transcript ID | Distance to TSS |
|---------|------------|-------|-----|-------|------------|---------|---------------|-----------------|
| SRR891268_chr22_peak_1 | chr1 | 629839 | 630055 | 217 | Distal Intergenic | 729759 | uc010nxv.2 | -7805 |
| SRR891268_chr22_peak_2 | chr1 | 633891 | 634174 | 284 | Distal Intergenic | 729759 | uc010nxv.2 | -11857 |
| SRR891268_chr22_peak_3 | chr10 | 99659162 | 99659391 | 230 | Intron (uc001kot.2/55118, intron 6 of 11) | 55118 | uc001kot.2 | 36732 |
| SRR891268_chr22_peak_4 | chr11 | 4393681 | 4393880 | 200 | Distal Intergenic | 143496 | uc010qye.2 | -4065 |
| SRR891268_chr22_peak_5 | chr12 | 88142166 | 88142365 | 200 | Distal Intergenic | 400058 | uc021rbq.1 | 36123 |
| SRR891268_chr22_peak_6 | chr13 | 100674844 | 100675043 | 200 | Distal Intergenic | 7546 | uc001von.3 | 40818 |
| SRR891268_chr22_peak_7 | chr17 | 22521277 | 22521506 | 230 | Distal Intergenic | 100462977 | uc002gzb.2 | 498840 |
| SRR891268_chr22_peak_8 | chr20 | 63009184 | 63009383 | 200 | Distal Intergenic | 140849 | uc002yio.1 | 87446 |
| SRR891268_chr22_peak_9 | chr22 | 17084749 | 17085091 | 343 | Promoter (1-2kb) | 387590 | uc002zls.1 | 1948 |

**Peak Annotation Visualization:**
![ATAC-Seq Peak Annotation](./SRR891268_chr22_peaks.narrowPeak_AnnoPie.png)

*Figure: ChIPseeker pie chart showing the distribution of ATAC-Seq peaks across various genomic features. The chart displays the percentage of peaks falling into different genomic regions such as promoters, introns, exons, 5' UTR, 3' UTR, and intergenic regions, providing insight into where accessible chromatin regions are located relative to gene structures.*

### Step 5: Visualize Peaks with pyGenomeTracks

**User Query:**
> Next, we want to visualize the peak in the chr22:37,193,000-37,252,000 region in a genome browser view. Use the chr22_gene.bed file as the gene annotation. Use the treatment bedGraph as the ATAC-seq coverage track. Use the peak.ini file as the configuration file.

**Tool Invocation:**
```json
{
  "tool": "pygenometracks_peak",
  "parameters": {
    "peak": "/path/to/SRR891268_chr22_peaks.narrowPeak",
    "bedgraph": "/path/to/SRR891268_chr22_treat_pileup.bdg",
    "gene": "/path/to/chr22_gene.bed",
    "tracks": "/path/to/peak.ini",
    "region": "chr22:37,193,000-37,252,000",
    "outname": "SRR891268_chr22_region_37193000_37252000.png"
  }
}
```

**Tool Response:**
```json
{
  "trackplot": {
    "basename": "SRR891268_chr22_region_37193000_37252000.png",
    "size": 26927
  },
  "tool_name": "pygenometracks_peak",
  "tool_version": "quay.io/biocontainers/pygenometracks:3.9--pyhdfd78af_0"
}
```

**Chat Response:**
> Visualization generated successfully. The track plot for the region chr22:37,193,000-37,252,000 has been created and saved as:
>
> **SRR891268_chr22_region_37193000_37252000.png** (27K)
>
> The visualization includes:
> - **Coverage track**: Treatment bedGraph coverage from the peak calling results
> - **Peaks track**: Narrow peaks from MACS3 in box format
> - **Gene annotation track**: Gene annotations from chr22_gene.bed
>
> The plot uses the configuration from `peak.ini` and shows the genomic tracks for the specified region.


**Generated Peak Visualization:**

![ATAC-Seq Peak Visualization](./chr22_37193000_37252000_tracks_q0001.png)

**User Query:**
> Let's also visualize the peak set from the default q-value cutoff 0.05.

**Tool Response:**

**Chat Response:**

> ## Visualization summary
> 
> **Output file:** `chr22_37193000_37252000_tracks_q005.png` (149 KB)
> 
> **Region visualized:** chr22:37,193,000-37,252,000 (59 kb)
> 
> **Peaks in this region (q-value ≤ 0.05):**
> 1. Peak 98: chr22:37,199,304-37,199,646
> 2. Peak 99: chr22:37,218,815-37,219,147
> 3. Peak 100: chr22:37,242,510-37,242,798
> 4. Peak 101: chr22:37,244,205-37,244,412 (new peak compared to q-value 0.001)
> 
> **Comparison:**
> - **q-value 0.001 (stringent):** 3 peaks
> - **q-value 0.05 (default):** 4 peaks
> 
> The visualization shows ATAC-seq coverage, all called peaks (including the additional peak 101), and gene annotations. The image is saved at 300 DPI and ready for viewing.

**Generated Peak Visualization (q 0.05):**

![ATAC-Seq Peak Visualization](./chr22_37193000_37252000_tracks_q005.png)


*Figure: pyGenomeTracks output showing the chr22:37,193,000-37,252,000 region. The plot displays ATAC-Seq read coverage (top track), called peaks (middle track), and the gene annotations (bottom track). The peaks correspond to accessible chromatin regions identified by MACS3.*

## Key Benefits

1. **ATAC-Seq Optimized Parameters**: The workflow uses ATAC-Seq-specific parameters (shift -100, extsize 200) as recommended by standard tutorials
2. **Complete Output Files**: Generates all essential outputs including peaks, summits, and bedGraph files for downstream analysis
3. **Quality Control**: Easy filtering of peaks by q-value thresholds for downstream analysis
4. **Peak Annotation**: Automatic annotation of peaks with genomic features and nearest genes
5. **Integrated Visualization**: Seamlessly visualizes peaks with coverage and gene annotations
6. **Natural Language Interface**: Complex peak calling accessible through simple queries
7. **Automatic Tool Chaining**: Results from peak calling are automatically used for visualization and annotation
8. **Reproducible Analysis**: All tools run in containerized environments with specified versions
9. **Human-in-the-Loop Analysis**: Users can adjust parameters like extension size, shift, duplicate handling, q-value thresholds, and visualization regions through natural language

## Technical Details

### Tool Execution

All tools execute in Docker containers as specified in their CWL definitions:
- **macs3**: Model-based Analysis of ChIP-Seq (v3.0.3)
- **ChIPseeker**: ChIP peak annotation (v1.42.0)
- **pyGenomeTracks**: Genome browser track visualization (v3.9)

### macs3 Parameters Explained

| Parameter | Value | Description |
|-----------|-------|-------------|
| `extsize` | 200 | Extends reads to 200bp fragments |
| `shift` | -100 | Shifts reads by -100bp (centers on Tn5 cut site) |
| `nomodel` | true | Skips fragment size estimation |
| `gsize` | 5e7 | The effective size of human chromosome 22 |
| `keepdup` | all | Retains all duplicate reads |
| `bdg` | true | Outputs bedGraph files for visualization |
| `summits` | true | Identifies subpeak summits |
| `qvalue` | 0.001 | Minimum FDR threshold for peak calling (default: 0.05) |

### Data Flow

1. ATAC-Seq reads (BED format) are processed by macs3
2. macs3 identifies enriched regions (peaks) representing open chromatin
3. Peak summits are identified for precise accessibility positions
4. bedGraph coverage tracks are generated for visualization
5. q-value tweaking is demonstrated during peak calling to control false discovery rate
6. ChIPseeker annotates peaks with genomic features (promoters, introns, exons, intergenic) and nearest genes
7. pyGenomeTracks combines peaks, coverage, and gene annotations into a single plot

### Output Files

| Step | File | Description |
|------|------|-------------|
| 1 | `*_peaks.narrowPeak` | Peak locations (BED6+4 format) |
| 1 | `*_summits.bed` | Peak summit positions |
| 1 | `*_peaks.xls` | Detailed peak statistics |
| 1 | `*_treat_pileup.bdg` | Treatment coverage (bedGraph) |
| 1 | `*_control_lambda.bdg` | Local background estimate |
| 3 | `*_peaks.narrowPeak` | Peaks filtered by q-value threshold during calling |
| 4 | `*_peakAnno.csv` | Peak annotation with genomic features |
| 4 | `*_AnnoPie.pdf` | Pie chart of peak distribution by feature |
| 5 | `*.png` | Genome browser visualization |

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

<a id="galaxy-atac-seq-tutorial"></a>
Galaxy ATAC-seq tutorial
https://galaxyproject.github.io/training-material/topics/epigenetics/tutorials/atac-seq/tutorial.html

<a id="macs3"></a>
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

