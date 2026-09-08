'''
Helper tools for the LangGraph Assignment application
Contains functions for creating, updating, deleting projects, and getting the current date.
'''

# imports
from defs import *
from helpers import *

import json
import datetime


from langchain_core.tools import tool
from langchain_core.messages import ToolMessage


@tool
def create_projects(project_list: list[ProjectResponse]) -> dict:
    '''
    Takes a list of projects and adds to projects list
    
    Args:
    - project_list: list of project JSON objects to add to the global projects list.

    Returns:
    - dict: A dictionary containing a boolean indicating success, and a list of the Project objects failed to be added.
    '''
    if DEBUG:
        print("Creating projects with the following data:")
        for project in project_list:
            print(project.model_dump())
            
    # append each project to project dictionary
    failed_projects = []
    for project in project_list:
        success = add_project(project)
        if not success:
            failed_projects.append(project.model_dump())
        
    return {
        "success": (len(failed_projects) == 0),
        "failed_projects": failed_projects
    }


@tool
def update_projects(update_list: list[ProjectUpdateResponse]) -> dict:
    '''
    Takes a list of projects and updates the projects list
    
    Args:
    - update_list: list of ProjectUpdateResponse objects to update in the projects list.

    Returns:
    - dict: A dictionary containing a boolean indicating if all updates were successful, and a list of the ProjectUpdateResponse objects that failed to be updated.
    '''
    if DEBUG:
        print("Updating projects with the following data:")
        for project in update_list:
            print(project.model_dump())
    
    # update each project in the global projects dictionary using its name as the key
    failed_updates = []
    for project in update_list:
        success = update_project(project)
        if not success:
            failed_updates.append(project.model_dump())
    return {
        "success": (len(failed_updates) == 0),
        "failed_updates": failed_updates
    }


@tool
def delete_projects(project_list: list[ProjectGetResponse]) -> dict:
    '''
    Takes a list of projects and deletes them from the projects list.

    Args:
    - project_list: list of ProjectGetResponse objects to delete from the projects list.

    Returns:
    - dict: A dictionary indicating the success of the deletion operation.
    '''
    if DEBUG:
        print("Deleting projects with the following data:")
        for project in project_list:
            print(project.model_dump())
    
    failed_deletions = []
    for project in project_list:
        project_id = project.id
        success = delete_project(project_id)
        if not success:
            failed_deletions.append(project_id)
    return {
        "success": (len(failed_deletions) == 0),
        "failed_deletions": failed_deletions
    }
    
    
@tool
def get_today() -> str:
    '''
    Returns the current date as a string in the format YYYY-MM-DD.

    Args:
    - None

    Returns:
    - str: The current date in the format YYYY-MM-DD.
    '''
    return datetime.date.today().isoformat()


# Stores all tools available for the llm
tool_list = [create_projects, update_projects, delete_projects, get_today]

# Tool dictionary mapping tool names to their functions
tool_dict = {tool.name: tool for tool in tool_list}


# Function to run a single tool call
def run_tool(tool_call: dict) -> ToolMessage:
    '''
    Executes a single tool call based on the provided tool call dictionary.

    Args:
    - tool_call (dict): A dictionary containing the tool name, arguments, and a unique tool call ID.

    Returns:
    - ToolMessage: A message object containing the result of the tool execution and the tool call ID.
    '''
    
    tool_name = tool_call["name"]
    tool_args = tool_call["args"]
    tool_id = tool_call["id"]
    
    if DEBUG:
        print(f"Running tool: {tool_name} with args: {tool_args}")
    
    if tool_name in tool_dict:
        result = tool_dict[tool_name].invoke(tool_args)
        message = ToolMessage(
            content=json.dumps(result),
            tool_call_id=tool_id
        )
        return message
    else:
        raise ValueError(f"Tool '{tool_name}' not found.")