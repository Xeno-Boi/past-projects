'''
Random Learning Agent
This file contains the Random agent implementation
Agent chooses actions at random
'''

# imports
import numpy as np
from defs import *

class RandomAgent(Player):
    # constructor
    def __init__(self):
        pass
    
    # variables
    
    # functions
    

    def policy(self) -> CONTROLS:
        '''
        calculates the policy to follow
        '''
        return np.random.choice(ACTIONS)

    
    def takeAction(self, state_info: StateInfo) -> CONTROLS:
        '''
        chooses an action to play
        '''
        return self.policy()
    
    
    def getRewards(self, rewards: int, state_info: StateInfo) -> None:
        '''
        receives rewards and the info for the next step (after taking action)
        '''
        return
    
    
    def gameOver(self, rewards: int) -> None:
        '''
        receives game over signal and final rewards
        '''
        return