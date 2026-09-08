'''
Helper functions for the LangGraph Assignment application
Contains functions for adding, updating, deleting, and printing projects.
'''

# imports
from defs import DEBUG, ProjectResponse, ProjectUpdateResponse, Project, DATA_FILE_PATH
from state import projects

from dataclasses import asdict, fields
import json
from pathlib import Path


def add_project(project_response: ProjectResponse) -> bool:
    '''
    Adds a single project to the global projects list.

    Args:
    - project_response: ProjectResponse object to add to the global projects list.

    Returns:
    - bool: True if the project was added successfully, False otherwise.
    '''
    try:
        project_id = find_lowest_available_id()
        projects[project_id] = convert_response_to_project(project_response, project_id)
        
        save_projects(projects)
        return True
    except Exception as e:
        if DEBUG:
            print(f"Error adding project: {e}")
        return False
    
    
def update_project(update_response: ProjectUpdateResponse) -> bool:
    '''
    Updates a single project in the global projects list.

    Args:
    - update_response: ProjectUpdateResponse object to update in the projects list.

    Returns:
    - bool: True if the project was updated successfully, False otherwise.
    '''
    try:
        project_id = update_response.id
        
        # check if project id exist
        if not project_id or project_id not in projects:
            return False
        
        target_project = projects[project_id]
        
        # get all valid fields
        valid_fields = {
            field.name
            for field in fields(Project)
            if field.name != "id"
        }
        
        # check if request fields are valid
        for field_name in update_response.updates.keys():
            if field_name not in valid_fields:
                if DEBUG:
                    print(f"Invalid project field: {field_name}")
                return False
            
        # apply changes
        for field_name, new_value in update_response.updates.items():
            setattr(target_project, field_name, new_value)
        
        save_projects(projects)
        return True
    except Exception as e:
        if DEBUG:
            print(f"Error updating project: {e}")
        return False


def delete_project(project_id: int) -> bool:
    '''
    Deletes a single project from the global projects list.

    Args:
    - project_id: ID of the project to delete.

    Returns:
    - bool: True if the project was deleted successfully, False otherwise.
    '''    
    try:
        if project_id in projects:
            del projects[project_id]
            save_projects(projects)
            return True
        return False
    except Exception as e:
        if DEBUG:
            print(f"Error deleting project: {e}")
        return False


def convert_response_to_project(project_response: ProjectResponse, project_id: int | None = None) -> Project:
    '''
    Converts a ProjectResponse object to a Project object by assigning it a unique ID.

    Args:
    - project_response: ProjectResponse object to convert.
    - project_id: Optional ID to assign to the converted Project object. If None, a unique ID will be generated.

    Returns:
    - Project: The converted Project object with a unique ID.
    '''
    if project_id is None:
        project_id = find_lowest_available_id()
    return Project(id=project_id, **project_response.model_dump())


def print_projects(project_list: list[Project]):
    '''
    Takes a list of projects and print them out.

    Args:
    - project_list: list of Project objects to print.

    Returns:
    - None
    '''
    # print each project
    for project in project_list:
        print(json.dumps(asdict(project), indent=4))
        

def print_all_projects():
    '''
    Prints all projects in the global projects list.

    Args:
    - None

    Returns:
    - None
    '''
    if not projects:
        print("No projects to display.")
        return
    print("All projects:")
    for project_id, project in projects.items():
        print("id:", project_id)
        print(json.dumps(asdict(project), indent=4))
        

def find_lowest_available_id():
    '''
    Finds the lowest available unique project ID that is not currently used in the global projects list.

    Args:
    - None

    Returns:
    - int: the lowest available unique project ID.
    '''
    current_id = 1
    while current_id in projects:
        current_id += 1
    return current_id


def load_projects() -> dict[int,Project]:
    '''
    Retreives projects list.

    Returns:
    - dict[int,Project]: The dictionary of all projects if available, empty dictionary otherwise.
    '''
    file_path = Path(DATA_FILE_PATH)
    
    # create parent directories if they don't exist
    file_path.parent.mkdir(parents=True, exist_ok=True)

    # check if file exist
    if not file_path.exists():
        # create an empty JSON file if it doesn't exist
        with open(file_path, "w", encoding="utf-8") as file:
            json.dump({}, file)
    
    with open(file_path, "r", encoding="utf-8") as file:
        data = json.load(file)

    projects = {}

    for project_data in data.values():
        project = Project(**project_data)
        projects[project.id] = project
        
        if DEBUG:
            print("project: ", project)

    if DEBUG:
        print("Loaded projects: ", projects)
        
    return projects


def save_projects(projects: dict[int,Project]):
    '''
    Saves current projects to project storage.

    Args:
    - projects: Dictionary of projects to save.

    Returns:
    - None
    '''
    file_path = Path(DATA_FILE_PATH)
    
    # create parent directories if they don't exist
    file_path.parent.mkdir(parents=True, exist_ok=True)
    
    # Create data to store
    data = {project_id: asdict(project) for project_id, project in projects.items()}

    if DEBUG:
        print("Saving projects: ", json.dumps(data, indent=4))
    
    with open(file_path, "w", encoding="utf-8") as file:
        json.dump(data, file, indent=4)
    