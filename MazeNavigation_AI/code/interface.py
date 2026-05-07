'''
Game Interface
This file contains the interface between the game and the RL agent
Learning loop happens here
'''

# imports
from defs import *
from game import MazeGame
from rl_agent import RLAgent
from random_agent import RandomAgent


def humanPlayerGame():
    game = MazeGame(agent=HumanPlayer())
    game.startGame(["level6","level6"], repeats=2, display_full_maze=False)
    
    
def rlAgentLearningGame():
    game_list = ["level6", "level1i", "level2", "level2i", "level3", "level3i", "level4", "level4i", "level5", "level6"]
    # game_list = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
    #              "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
    #              "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
    #              "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
    #              "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
    #              "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
    #              "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
    #              "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
    #              "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
    #              "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
    #              "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
    #              "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
    #              "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
    #              "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
    #              "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    game_list = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
                 "11", "12", "13", "14", "15", "16", "17", "18", "19", "20",
                 "21", "22", "23", "24", "25", "26", "27", "28", "29", "30",
                 "31", "32", "33", "34", "35", "36", "37", "38", "39", "40",
                 "41", "42", "43", "44", "45", "46", "47", "48", "49", "50",
                 "51", "52", "53", "54", "55", "56", "57", "58", "59", "60",
                 "61", "62", "63", "64", "65", "66", "67", "68", "69", "70",
                 "71", "72", "73", "74", "75", "76", "77", "78", "79", "80"]
    actor_size = [0.0001, 0.00001, 0.000001]
    critic_size = [0.00001]
    for a in actor_size:
        for c in critic_size:
            print(f"Starting game with actor step size: {a}, critic step size: {c}")
            game = MazeGame(agent=RLAgent(gamma=0.5, actor_step_size=a, critic_step_size=c, tau=10.0))
            game.startGame(game_list, repeats=3, render=False, log_game=True, log_player=False, display_full_maze=True, learning=True)

def rlAgentGame():
    # game_list = ["level1", "level1i", "level2", "level2i", "level3", "level3i", "level4", "level4i", "level5", "level6"]
    # game_list = ["level3"]
    # game_list = ["level4"]
    # game_list = ["level5"]
    game_list = ["level6"]
    game = MazeGame(agent=RLAgent(tau=2.0))
    game.startGame(game_list, repeats=1, render=True, log_game=True, log_player=False, display_full_maze=True, learning=False)



def randomAgentGame():
    game = MazeGame(agent=RandomAgent())
    game_list = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    game.startGame(game_list, repeats=2, render=True, log_game=True, log_player=False, display_full_maze=True)    
    

if __name__ == "__main__":
    # humanPlayerGame()
    # rlAgentLearningGame()
    rlAgentGame()
    # randomAgentGame()