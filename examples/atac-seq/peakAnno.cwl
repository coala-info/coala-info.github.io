cwlVersion: v1.0
class: CommandLineTool
baseCommand: Rscript
requirements:
- class: InitialWorkDirRequirement
  listing:
  - entryname: ChiPSeeker.R
    entry: "suppressPackageStartupMessages(library(R.utils))\nargs
      <- commandArgs(trailingOnly = TRUE, asValues = TRUE)\nChiPSeeker <-\nfunction(peak){\n
      \   library(ChIPseeker)\n    fn <- basename(peak)\n    peakAnno <- annotatePeak(peak)\n
      \   write.csv(data.frame(peakAnno), paste0(fn, \"_peakAnno.csv\"))\n    \n    pdf(paste0(fn,
      \"_AnnoPie.pdf\"))\n    plotAnnoPie(peakAnno)\n    dev.off()\n}\ndo.call(ChiPSeeker,
      args)"
    writable: false
- class: DockerRequirement
  dockerPull: quay.io/biocontainers/bioconductor-chipseeker:1.42.0--r44hdfd78af_0
arguments:
- ChiPSeeker.R
id: ChiPSeeker
label: ChIP peak Annotation
doc: 'ChIPseeker: an R package for ChIP peak Annotation, Comparison and Visualization'
inputs:
  peak:
    label: peak
    doc: Bed format peak file, e.g. bed file or narrowPeak from macs
    type: File
    inputBinding:
      separate: true
outputs:
  ann:
    label: annotation
    doc: csv format peak annotatiion output
    type: File
    outputBinding:
      glob: '*peakAnno.csv'
  pie:
    label: pie
    doc: pie plot to show the percentages of gemomic features based on the peak annotation
    type: File
    outputBinding:
      glob: '*.pdf'
