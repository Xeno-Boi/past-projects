# LangGraph Project Management Assistant

## Introduction

A command-line project management assistant built with Python, LangGraph, and a local Ollama language model. Users can create, update, list and delete projects through natural-language requests, or display all stored projects with a terminal command.

LangGraph coordinates the conversation between the model and Python tools. Project records are loaded from `data/projects.json` at startup, and changes are saved to that file. Conversation history lasts for the current session.

Each project contains an ID, name, description, customer, start date, deadline, location, status, notes, and priority. The assistant's prompt requires a name, description, and customer when creating a project and asks how to handle optional fields.

## Dependencies

The supplied development environment uses **Python 3.13.9**. Use that version to match the environment, along with pip and a running Ollama installation. The four packages below are imported directly by the application; their versions come from the supplied environment package list.

- `langgraph` = `1.2.11`
    Builds and executes the state graph and conditional routing.

- `langchain-ollama` = `1.1.0`
    Provides `ChatOllama` for communicating with the local model.

- `langchain-core` = `1.6.2`
    Provides message types and the `@tool` decorator.

- `pydantic` = `2.12.4`
    Defines structured tool inputs and provides `model_dump()`.

`requirements.txt` pins the four direct dependencies.

The modules `json`, `datetime`, `dataclasses`, `pathlib`, and `typing` are part of Python's standard library and need no separate installation.

The configured model is [`qwen3:4b-instruct`](https://ollama.com/library/qwen3:4b-instruct). The app uses the [LangChain ChatOllama integration](https://docs.langchain.com/oss/python/integrations/chat/ollama) with tool calling.

## Instructions to Run

### 1. Open a terminal in the project folder

Run the following commands from the folder containing `main.py`. The data file path is relative to the current working directory.

### 2. Install dependencies

With Python 3.13.9 and pip installed, run:

```bash
pip install -r requirements.txt
```

### 3. Prepare Ollama

Install [Ollama](https://ollama.com/download), start it, and download the configured model:

```bash
ollama pull qwen3:4b-instruct
```

If the Ollama service is not already running, start it in a separate terminal and leave that terminal open:

```bash
ollama serve
```

### 4. Start the application

Windows PowerShell:

```powershell
python main.py
```

Enter requests at the `You:` prompt. For example:

```text
Create a project named Website Refresh for customer Alex. The description is redesigning the company website. Leave all optional fields empty.
Update the calculator project to high priority.
Delete all python projects.
List all projects.
```

Use IDs that exist in your project data. The following commands are handled directly by the terminal loop:

- `print all`
    Prints all projects without calling the model.
- `exit`
    Ends the application.

# LLM Model used

- Ollama
- qwen3:4b-instruct
    local model

## File Structure

```text
LangGraph Assignment/
├── README.md
├── main.py
├── defs.py
├── helpers.py
├── llm.py
├── prompt.py
├── state.py
├── tools.py
└── data/
    └── projects.json
```

The application only uses the file specified by `DATA_FILE_PATH`.

## Python File Descriptions

- `main.py`
    Entry point. Calls `load_projects()`, fills the shared project dictionary, and starts `mainloop()`.

- `defs.py`
    Contains model settings, the storage path, Pydantic input schemas (`ProjectResponse`, `ProjectUpdateResponse`, and `ProjectGetResponse`), and the `Project` dataclass used for stored records.

- `helpers.py`
    Implements project creation, updates, deletion, printing, ID allocation, and conversion from tool input to `Project` objects. Loads and saves JSON records.

- `llm.py`
    Configures `ChatOllama`, defines `GraphState`, implements both graph nodes and the conditional router, compiles the graph, and runs the interactive conversation loop.

- `prompt.py`
    Defines `PROMPT`, the system instructions for collecting project details, selecting records, changing fields, and formatting responses.

- `state.py`
    Holds the shared `projects: dict[int, Project]` dictionary used by the application. This project storage is separate from the graph's conversation state.

- `tools.py`
    Exposes `create_projects`, `update_projects`, `delete_projects`, and `get_today` as model-callable tools. Registers tools and dispatches calls through `run_tool()`, returning `ToolMessage` results.

## LangGraph WorkFlow

The graph in `llm.py` has two processing nodes: `llm_response` and `tool_call`. `START` and `END` are graph boundaries. The diagram below matches the nodes and edges registered in `build_graph()`.

```mermaid
flowchart:

                  ┌───────────────────────────────────────────────────────┐
                  v                                                       |
    START --> llm_response --> route_after_llm --(if request tools)--> tool_call
                                       |
                                       └─(otherwise)─> END
```

### Nodes

- llm_response
    Sends the conversation to the model with the system prompt and current projects. Appends the AI response to `messages` and sets `reply`.

- tool_call
    Executes each tool call in the latest reply through `run_tool()`. Appends tool results to `messages` and resets `reply` to `None`. Tool execution exceptions are returned as tool messages.


### Edges

- START --> llm_response
    Always, when the graph is invoked.

- llm_response --> tool_call
    `route_after_llm()` returns `"tools"` if the reply contains tool calls.

- llm_response --> END
    `route_after_llm()` returns `"end"` if there are no tool calls.

- tool_call --> llm_response
    Always, allows the model to read tool results and respond or request more tools.

`route_after_llm()` is the conditional routing function, not a separate graph node. 

Each normal user message invokes the graph; reaching `END` finishes that turn and prints the reply. The main loop then waits for the next user input.

## Graph State

- `messages`
    Contains full message history, including newest message.
    Accumulated using `add_messages`.

- `reply`
    Contains the LLM's lastest reply message.

Only the last `MESSAGE_SIZE` conversation messages plus a new system message containing the current project dictionary is sent to the model to ensure the model will not get overloaded.

The session's full message list remains in memory.

## Configuration and Storage

Settings are defined in `defs.py`:

- `MODEL_NAME` = `"qwen3:4b-instruct"`
    Ollama model used by the assistant.

- `MESSAGE_SIZE` = `100`
    Maximum number of recent conversation messages included in each model request.

- `DEBUG` = `False`
    Enables extra diagnostic output when set to `True`.

- `DATA_FILE_PATH` = `"data/projects.json"`
    JSON storage location, relative to the working directory.

JSON object keys are strings, while the in-memory project dictionary uses integer IDs. `load_projects()` iterates over the stored values, constructs `Project` objects, and uses each record's numeric `id` as its dictionary key. `save_projects()` converts the dataclasses to dictionaries and writes the full collection to JSON after create, update, or delete operations. JSON `null` values become Python `None`.

## Current Limitations

- Project records persist between runs; conversation history does not.

## Example Console Sessions

You: get all projects

Bot: ** Project **
- id: 1
- name: Python Calculator
- customer: John Doe
- description: A simple Python-based calculator application
- start_date: 2026-03-15
- deadline: 2026-03-30
- location: Office
- status: In Progress
- notes: Initial notes for the project
- priority: Low

** Project **
- id: 2
- name: Java 3D Game
- customer: Jane Smith
- description: A 3D game built using Java
- start_date: 2026-02-02
- deadline: 2026-02-10
- location: Office
- status: On Hold
- notes: On hold due to pending approvals
- priority: High

** Project **
- id: 3
- name: Python AI App
- customer: Alice Johnson
- description: An AI application built using Python
- start_date: 2026-04-01
- deadline: None
- location: Remote
- status: In Progress
- notes: Testing phase for the AI application
- priority: Medium

You: change the calculator project to be using Java. Change the name and description. Change the customer to be Alice, and set the priority to high. Move the deadline to 3 days earlier.

Bot: The project has been successfully updated.
** Project **
- id: 1
- name: Java Calculator
- customer: Alice
- description: A simple Java-based calculator application
- start_date: 2026-03-15
- deadline: 2026-03-27
- location: Office
- status: In Progress
- notes: Initial notes for the project
- priority: High

You: get me all java projects

Bot: ** Project **
- id: 1
- name: Java Calculator
- customer: Alice
- description: A simple Java-based calculator application
- start_date: 2026-03-15
- deadline: 2026-03-27
- location: Office
- status: In Progress
- notes: Initial notes for the project
- priority: High

You: create a project about building computers

Bot: To create a project about building computers, I need the following details:

- Name of the project  
- Customer name  
- Description of the project  

Could you please provide these? Additionally, if you'd like to include any of the optional fields (e.g., start date, deadline, location, status, notes, priority), let me know. For now, I'll ask for the mandatory fields.

You: please write the name and description for me. The customer is Peter. It starts today, no deadline. It is a home project, very important, in progress, no notes.

Bot: I have your requested details for the project:

- Name: Building Computers  
- Description: A project to design and build custom computers from scratch  
- Customer: Peter  
- Start date: Today (2026-09-07)  
- Deadline: None  
- Location: Home  
- Priority: High  
- Status: In Progress  
- Notes: None  

I will now create this project for you.

You: yes please

Bot: The project has been successfully created.  

** Project **
- id: 4
- name: Building Computers
- customer: Peter
- description: A project to design and build custom computers from scratch
- start_date: 2026-09-07
- deadline: None
- location: Home
- status: In Progress
- notes: None
- priority: High