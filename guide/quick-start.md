# Quick Start


1. **Initialize:** Create a local MCP server instance.
2. **Register:** Load your CWL-described tools (supports local files or repositories).
3. **Connect:** Start the MCP server and link it to your MCP client.
4. **Use** Chat with the LLM agent to execute the task. 

## Basic Setup

The framework allows you to set up MCP servers with domain-specific tools described in CWL. The following example demonstrates how to create a server for PDF processing:

```python

from coala.mcp_api import mcp_api
import os
base_dir = os.path.dirname(__file__)

mcp = mcp_api(host='0.0.0.0', port=8000)
mcp.add_tool(os.path.join(base_dir, 'pdftk_cat.cwl'))
mcp.add_tool(os.path.join(base_dir, 'pdf2docx.cwl'))
mcp.serve()

```

This creates an MCP server that exposes two command-line tools for PDF processing operations:
- `pdftk_cat`: The core command in the command-line tool [PDFtk](https://www.pdflabs.com/docs/pdftk-man-page/)
- `pdf2docx`: The core command in the command-line tool [pdf2docx](https://pypi.org/project/pdf2docx/)


You can configure your MCP client (e.g., Cursor, Claude Code, Codex, Gemini CLI) to connect to the MCP server using one of two methods:

### Option 1: Automatic Execution (Recommended)

In this mode, the MCP client launches the server automatically when it starts. This is generally the easiest method for local use.

```json
{
    "mcpServers": {
        "PDF Processing": {
            "command": "python",
            "args": ["/path/to/examples/PDF/PDF-operation_mcp.py"]
        }
    }
}
```

### Option 2: Connect to Running Server

Start the server by running the following command in your terminal:

```bash
python examples/PDF/PDF-operation_mcp.py
```

Once the server is running, you can connect your client through the following configuration:

```json
{
    "mcpServers": {
        "PDF Processing": {
            "url": "http://localhost:8000/mcp",
            "transport": "streamable-http"
        }
    }
}
```

## Start Using

With this setup, you can send natural language queries to the MCP Client (e.g., Cursor, Claude Code, Codex, Gemini CLI):

- "extract specified pages from xxx.pdf"
- "combine all the uploaded files into a single PDF document"
- "split the document at page xxx and save them as separate files"
- "convert all/specified pages of xxx.pdf into docx file"

The Client retrieves the tool list from the MCP server. The LLM selects the appropriate tool and sends a structured request for the analysis. Coala translates this selection into a CWL job and executes it within a container. The execution logs and results are returned to the LLM, which interprets them and presents the final answer to you.

<!-- The LLM will automatically discover the available tools, understand their parameters, invoke the appropriate tool with the correct arguments, and present the results in a user-friendly format. -->

## Next Steps

- Check out [use cases](/use-cases/)

<!-- 
- Learn more about [MCP Server setup](/guide/mcp-server)
- Explore [Function Call integration](/guide/function-call)
-->

