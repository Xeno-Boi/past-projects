'''
Definitions for the LangGraph Assignment application

Includes model parameters, project data structure and llm response structure
'''

# imports
from pydantic import BaseModel, Field
from dataclasses import dataclass

# Model Parameters
MODEL_NAME = "qwen3:4b-instruct"    # Name of the model to be used for the LLM
MESSAGE_SIZE = 100      # Maximum number of messages to retain in the conversation history
DEBUG = False   # Flag to enable or disable debug mode
DATA_FILE_PATH = "data/projects.json"   # Path to the JSON file storing project data


# Project structure to be used for responses from the LLM
class ProjectResponse(BaseModel):
    name: str = Field(
        description="Name of the project"
    )
    description: str = Field(
        description="Description of the project"
    )
    customer: str = Field(
        description="Name of customer who the project belongs to"
    )
    start_date: str | None = Field(
        description="Start date of the project or None"
    )
    deadline: str | None = Field(
        description="Deadline of the project or None"
    )
    location: str | None = Field(
        description="Location of the project or None"
    )
    status: str | None = Field(
        description="Status of the project, can be 'In Progress', 'Completed', 'On Hold' or None"
    )
    notes: str | None = Field(
        description="Additional notes for the project or None"
    )
    priority: str | None = Field(
        description="Priority of the project, can be 'High', 'Medium', 'Low' or None"
    )


# Response structure to be used for updating from the LLM
class ProjectUpdateResponse(BaseModel):
    id: int = Field(
        description="Unique identifier of the project to be updated"
    )
    updates: dict[str, str | None] = Field(
        description="Dictionary containing the fields to update and their new values"
    )
    

# Define the response structure to be used for getting projects from the LLM
class ProjectGetResponse(BaseModel):
    id: int = Field(
        description="Unique identifier of the project to retrieve"
    )


# Project structure for internal storage with an ID
@dataclass
class Project:
    id: int     # Unique identifier of the project
    name: str    # Name of the project
    description: str    # Description of the project
    customer: str    # Name of the customer who the project belongs to
    start_date: str | None = None    # Start date of the project or None
    deadline: str | None = None    # Deadline of the project or None
    location: str | None = None    # Location of the project or None
    status: str | None = None    # Status of the project, can be 'In Progress', 'Completed', 'On Hold' or None
    notes: str | None = None    # Additional notes for the project or None
    priority: str | None = None    # Priority of the project, can be 'High', 'Medium', 'Low' or None