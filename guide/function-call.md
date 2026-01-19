# Function Call

Coala also supports function call integration with Large Language Models (LLMs) like Google's Gemini. This feature allows developers to convert standard CWL tool definitions into native Python functions that LLMs can understand and invoke.

## Creating an API

First, import the `tool_api` function to load your CWL tool definition. This step creates an interface that maps the command-line tool to an API structure.

To create an API, import the `tool_api` function from `coala.remote_api` and pass in the path to a CWL file and the name of the tool:

```python
from coala.remote_api import tool_api

# Initialize the tool API with a CWL file and a tool name
api = tool_api(cwl_file='tests/dockstore-tool-md5sum.cwl', tool_name='md5sum')

# Start as a REST Service
api.serve()
```
The `api.serve()` method will start a RESTful API as a service, allowing you to run the tool either locally or remotely (e.g., from the cloud).
  

## Creating a Tool Agent

Next, use the `tool_agent` to wrap the API instance into a callable function. This step generates the function schema (including arguments and docstrings) required by the LLM.

To create a tool agent, import the `tool_agent` function from `coala.agent` and pass in the API instance:

```python
from coala.agent import tool_agent

# Create the agentic tool and generate the callable function
ta = tool_agent(api)
md5 = ta.create_tool()

# You can now test the function directly in Python:
md5(input_file="tests/dockstore-tool-md5sum.cwl")
```

Function `md5` is created automatically based on the `api`.

## Function Call with Gemini

To integrate this tool with Google Gemini, pass the generated function (e.g., `md5`) into the `tools` parameter of the `GenerativeModel`:

```python
import google.generativeai as genai

# Configure your Google API key
genai.configure(api_key="******")

# Initialize the model with the agentic tool
model = genai.GenerativeModel(model_name='gemini-1.5-flash', tools=[md5])

# Start a chat with automatic function calling enabled
chat = model.start_chat(enable_automatic_function_calling=True)

# Send a natural language query that requires the tool
response = chat.send_message("what is md5 of tests/dockstore-tool-md5sum.cwl?")

# Print the model's response
response.text
```

Output:

```
'The md5sum of tests/dockstore-tool-md5sum.cwl is ad59d9e9ed6344f5c20ee7e0143c6c12. \n'
```

