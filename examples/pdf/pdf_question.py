from coala.mcp_api import mcp_api
import os
base_dir = os.path.dirname(__file__)

mcp = mcp_api(host='0.0.0.0', port=8000)
mcp.add_tool(os.path.join(base_dir, 'pdftk_cat.cwl'))
mcp.add_tool(os.path.join(base_dir, 'pdf2docx.cwl'))
mcp.serve()

# Question1: extract page 2 and 3 from examples/test_123.pdf to "test_23.pdf"
# Question2: combine test_23.pdf and examples/test_abc.pdf to test_23abc.pdf