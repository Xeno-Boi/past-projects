'''
define file
stores all the type definitions and constants
'''

# imports
from enum import Enum
import numpy as np
import pygame

# game  ------------------------------------------------------------------------

# constants
VISION_SIZE = 5  # the size of the player's vision (in tiles)
MAX_STEPS = 10000  # maximum steps before loosing
FPS = 6000  # frames per second for rendering

# defines the different states a cell in the maze can be in
class MAZE_CONTENT(Enum):
    WALL = 0
    EMPTY = 1
    START = 2
    GOAL = 3
    DOOR = 4
    KEY = 5
    TRAP = 6


# defines control options for the player
class CONTROLS(Enum):
    UP = "up"
    DOWN = "down"
    LEFT = "left"
    RIGHT = "right"
    STAY = "stay"
    HUMAN = "human" # for human player input

N_ACTION = 4  # number of possible actions
    

# definds the action from the control
CONTROL_ACTIONS = {
    CONTROLS.UP: np.array([0, -1]),
    CONTROLS.DOWN: np.array([0, 1]),
    CONTROLS.LEFT: np.array([-1, 0]),
    CONTROLS.RIGHT: np.array([1, 0]),
    CONTROLS.STAY: np.array([0, 0])}


# type definitions

Position = np.ndarray[np.int_]  # (x, y) coordinates for calculations


class StateInfo:
    '''
    Info that gets passed to the agent at each step
    '''
    def __init__(self, view: np.ndarray, player_position: Position, keys: int, steps_taken: int, visited_view: np.ndarray):
        self.view: np.ndarray = view  # matrix of player's view
        self.player_position: Position = player_position  # player's current position
        self.keys: int = keys           # number of keys the player has
        self.steps_taken: int = steps_taken  # number of steps taken by the player
        self.visited_view: np.ndarray = visited_view  # matrix of visited cells in the player's view

# ai --------------------------------------------------------------------------

# type definitions


class Player:
    '''
    Player base class
    '''
    
    def takeAction(self, state_info: StateInfo) -> CONTROLS:
        '''
        chooses an action to play
            state_info: state information at the current step
        '''
        return CONTROLS.STAY
    
    
    def getRewards(self, rewards: int, state_info: StateInfo) -> None:
        '''
        receives rewards and the info for the next step (after taking action)
            rewards: rewards received after taking action
            state_info: state information at the next step
        '''
        return
    
    
    def gameOver(self, rewards: int) -> None:
        '''
        receives game over signal and final rewards
            rewards: final rewards received
        '''
        return
    
    
    
class HumanPlayer(Player):
    '''
    Human Player class
    '''
    def takeAction(self, state_info: StateInfo) -> CONTROLS:
        return CONTROLS.HUMAN


# constants

ACTIONS = np.array([CONTROLS.UP, CONTROLS.DOWN, CONTROLS.LEFT, CONTROLS.RIGHT, CONTROLS.STAY])  # might not be used


class REWARDS:
    '''
    defines reward values
    '''
    
    # in game
    STEP = -0.5   # penalty for each step taken
    INVALID = -10   # penalty for invalid move (e.g., hitting a wall, opening door without key)
    KEY_PICKUP = 20    # reward for picking up a key
    DOOR_OPEN = 10   # reward for opening a door
    VISIT = 1  # reward for visiting a new cell
    BACKTRACK = -1  # penalty for doing an opposite move to previous step
    
    # game end
    GOAL = 100  # reaching the goal
    TRAP = -100 # falling into a trap

    # reward for running out of steps
    # depending on distance from start
    @classmethod
    def outOfSteps(cls, player_pos: Position, start_pos: Position) -> int:
        # distance = np.linalg.norm(player_pos - start_pos)
        # return (distance / MAX_STEPS) * (cls.GOAL / 2)  # more reward the further away from start, get up to half the goal reward
        return -70
        
    