'''
Main entry point for the LangGraph Assignment application
Handles initialization of the application state and starts the main loop.
'''

# imports
from defs import *
from helpers import *
import state
from llm import mainloop


if __name__ == "__main__":
    # load projects from storage into the state
    loaded_projects = load_projects()

    state.projects.clear()
    state.projects.update(loaded_projects)
    
    mainloop()