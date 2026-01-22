cwlVersion: v1.2
class: CommandLineTool
label: pdf2docx convert
doc: "Convert PDF files to DOCX format."

requirements:
  InlineJavascriptRequirement: {}
  DockerRequirement:
    dockerPull: hubentu/pdf2docx

baseCommand: [pdf2docx, convert]

inputs:
  pdf_file:
    type: File
    doc: "PDF filename to read from."
    inputBinding:
      position: 1

  docx_filename:
    type: string
    doc: "docx filename to write to."
    inputBinding:
      prefix: --docx_file
      position: 2

  start_page:
    type: int?
    inputBinding:
      prefix: --start

  end_page:
    type: int?
    inputBinding:
      prefix: --end

  pages:
    type: int[]?
    doc: "Specific pages to process (e.g., 1,3,5)."
    inputBinding:
      prefix: --pages
      itemSeparator: ","

  password:
    type: string?
    inputBinding:
      prefix: --password

outputs:
  docx_file:
    type: File
    outputBinding:
      glob: $(inputs.docx_filename)