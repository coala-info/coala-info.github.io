---
layout: home

hero:
  name: "Coala"
  text: "Command-line LLM-agent Adapter"
  tagline: A standard-based framework for converting command-line tools into agentic toolsets
  image:
    src: /Coala.svg
    alt: Coala
    size: large
  actions:
    - theme: brand
      text: Get Started
      link: /guide/
    - theme: alt
      text: View on GitHub
      link: https://github.com/coala-info

features:
  - icon: 🔌
    title: Universal Integration
    details: Convert any command-line tool into an MCP-compliant agentic toolset through a standards-based framework.
  - icon: 🌐
    title: CWL Ecosystem
    details: Leverage the vast, open-source CWL community for command-line tool definitions.
  - icon: ⚡
    title: Low Maintenance Burden
    details: Treat tool definitions as data rather than code. No need to write custom Python wrappers for every individual tool.
  - icon: 🐳
    title: Reproducible by Design
    details: Tools run in Docker containers, ensuring scientific reproducibility and preventing local dependency conflicts.
  - icon: 🤖
    title: Natural Language Interaction
    details: Access command-line tools tools interactively through natural language queries.
  - icon: 🔒
    title: Local Data Handling
    details: Run command-line tools on local data, without the need to upload sensitive files to the external servers.

---

## Overview

Coala (Command-line LLM-agent Adapter) is a standards-based framework that converts command-line tools into agentic toolsets by bridging the Model Context Protocol (MCP) and Common Workflow Language (CWL). Coala treats tool definitions as data rather than hard-coded logic, allowing Large Language Models (LLMs) to discover and execute reproducible analyses without the need to write custom wrappers for every individual tool.

- MCP acts as a "USB-C port", standardizing how LLMs connect to tools and data, regardless of the underlying infrastructure or vendor.
- CWL acts as the "Blueprint," providing an open standard for describing command-line tools with validated schemas and containerized environments.


## How It Works

The Coala framework, implemented in a Python package, operates on a three-tier architecture to translate natural-language queries into reproducible tool execution.

- **Client Layer**: Any MCP-compliant client application (e.g., Claude Desktop, Cursor, or custom interfaces) that utilizes LLMs (such as Gemini, GPT-5, or Claude) to enable natural language interaction.
- **Bridge Layer**: A local, generic MCP server that acts as a schema translator. Unlike standard MCP servers that require custom Python wrappers for each tool, the bridge layer automatically parses CWL definitions and exposes the CWL-described command-line tools as executable MCP utilities.
- **Execution Layer**: A standard CWL runner that executes the underlying binaries within containerized environments (Docker). This ensures that analyses are reproducible and isolated from the host system's dependencies.

The user sends a natural language query to the MCP Client (e.g., Claude Desktop). The Client retrieves the tool list from the MCP server. The LLM selects the appropriate tool and sends a structured request for the analysis. Coala translates this selection into a CWL job and executes it within a container (Docker), ensuring reproducibility. The execution logs and results are returned to the LLM, which interprets them and presents the final answer to the user.

