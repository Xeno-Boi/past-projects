'''
Stores the global state for the LangGraph Assignment application
Contains the global list of projects used throughout the application.
'''

# imports
from defs import Project


# global state
projects: dict[int, Project] = {}    # Global variable to store the list of projects
