## Overview

Coala, implemented as a Python package, is a standards-based framework for turning command-line tools into reproducible, agent-accessible toolsets that support natural-language interaction.

## How the Framework Works

Coala integrates the [Common Workflow Language (CWL)](https://www.commonwl.org/specification/) with the [Model Context Protocol (MCP)](https://modelcontextprotocol.io/docs/getting-started/intro) to standardize tool execution. This approach allows Large Language Model (LLM) agents to discover and run tools through structured interfaces, while strictly enforcing the containerized environments and deterministic results necessary for reproducible science.

### Core Components

- **Client Layer:** Any MCP-compliant client application (e.g., Claude Desktop, Cursor, or custom interfaces) that utilizes LLMs (such as Gemini, GPT-5, or Claude) to enable natural language interaction.
- **Bridge Layer:** A local, generic MCP server that acts as a schema translator. Unlike standard MCP servers that require custom Python wrappers for each tool, the bridge layer automatically parses CWL definitions and exposes the CWL-described command-line tools as executable MCP utilities.
- **Execution Layer:** A standard CWL runner that executes the underlying binaries within containerized environments (Docker). This ensures that analyses are reproducible and isolated from the host system's dependencies.

### Quick Start

1. **Initialize:** Create a local MCP server instance using `mcp_api()`.
2. **Register:** Load your domain-specific tools described in CWL via `add_tool()` (supports local files or repositories).
3. **Serve:** Start the MCP server using `mcp.serve()`. 

### The Workflow

- **Interact:** The user sends a natural language query to the MCP Client (e.g., Claude Desktop).
- **Discover & Select:** The Client retrieves the tool list from the MCP server. The LLM selects the appropriate tool and sends a structured request for the analysis.
- **Execute:** Coala translates this selection into a CWL job and executes it within a container (Docker), ensuring reproducibility.
- **Respond:** The execution logs and results are returned to the LLM, which interprets them and presents the final answer to the user.


<!-- This text is a hidden note and will not be displayed in the rendered index.

# Overview

Tool Agent is a Python package that converts any command-line tool into a Large Language Model (LLM) agent. This allows you to interact with the tool using natural language, making it easier to use and integrate with other applications.

## How the Framework Works

Tool Agent leverages the Model Context Protocol (MCP) to bridge command-line tools and Large Language Models (LLMs). The framework works by converting CWL (Common Workflow Language) tool definitions into MCP-compatible agents that can be discovered and invoked by LLMs through natural language queries.

Here's how it works:

1. You create an MCP server instance using `mcp_api`
2. Register your domain-specific tools by providing their CWL definitions via `add_tool()`
3. Start the server
4. The MCP server exposes these tools as discoverable agents that any MCP-compatible client (like Cursor) can query and invoke

When an LLM needs to use a tool, it:
- Queries the MCP server for available tools
- Selects the appropriate one
- Invokes it with the necessary parameters
- The tool executes within a containerized environment (as specified in the CWL)
- Processes the request and returns results back through the MCP protocol to the LLM
- Presents the answer to the user in natural language

## Advantages

- **Local Data Handling**: Run professional tools on local data securely, without uploading sensitive files to the cloud.
- **Universal CMD Tool Integration**: Easily convert any command-line tool into an MCP-based agent with minimal effort.
- **CWL Ecosystem**: Leverage the vast, open-source CWL community—especially strong in bioinformatics—for tool definitions and interoperability.
- **Flexible Integration**: Works with any LLM or client that supports MCP, enabling vendor-agnostic, modular workflows.
- **User-Friendly**: No need for users to install or configure complex tools; everything is managed by the agent and containers.
- **No Prior Knowledge Required**: Users can access advanced tools and workflows through natural language, lowering the barrier to entry.
- **Reproducibility**: CWL ensures that tool execution is standardized and reproducible across environments.
- **Scalability**: Easily add new tools or scale up by running multiple agents or servers.
- **Security**: Keep data within your infrastructure, reducing exposure to external threats.
- **Extensibility**: Add new tools, workflows, or integrations as your needs evolve.

-->
