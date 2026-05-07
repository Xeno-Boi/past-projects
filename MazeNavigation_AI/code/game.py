# imports
import pygame
import numpy as np
import os
from defs import *
from collections import deque
from map_builder import load_maze_from_file


# constants
TILE_SIZE = 30    # in pixels


class MazeGame:
    def __init__(self, agent: Player):
        self.player: Player = agent

    def setup(self, maze_level_list: list[str] = ["level1"], repeats: int = 1, render: bool = True, log_game: bool = True, log_player: bool = True, display_full_maze: bool = False, learning: bool = True):
        '''
        sets up the game parameters
            :param maze_level_list: list of maze filenames to load, do not include file extension (.txt)
            :param repeats: number of times to repeat each level
            :param render: whether to render the game window
            :param log_game: whether to print game log messages
            :param log_player: whether to print player log messages
            :param display_full_maze: whether to display the full maze or just the vision grid
            :param learning: whether the agent is learning or just playing
        '''
        pygame.init()
        pygame.key.set_repeat(0)

        # game parameters
        self.render: bool = render
        self.log_game: bool = log_game
        self.log_player: bool = log_player
        self.display_full_maze: bool = display_full_maze
        self.maze_queue: deque = deque(maze_level_list)    # stores the list of maze filenames
        self.repeats: int = repeats  # number of times to repeat each level
        self.font = pygame.font.SysFont('Arial', TILE_SIZE // 2)
        self.clock = pygame.time.Clock()
        self.recent_visit_recovery: float = 0.005  # recovery factor for recent visit tracking
        self.learning: bool = learning
        

        # variables
        self.current_maze: np.ndarray = None    # stores the level being played, used for resets
        self.maze: np.ndarray = None    # the current maze map
        self.player_pos: Position = np.array([0, 0])
        self.start_pos: Position = np.array([0, 0])
        self.goal_pos: Position = np.array([0, 0])
        self.keys: int = 0  # number of keys the player has
        self.steps_taken: int = 0
        self.rewards: int = 0   # total rewards accumulated in one step
        self.recent_visit: np.ndarray = None  # stores how recently each cell was visited, 0 means recently visited, 1 means never visited
        self.total_rewards: int = 0  # total rewards accumulated in the game
        self.last_action: CONTROLS = CONTROLS.STAY  # last action taken by the player


        if self.render:
            self.limit_fps = True

            # set up in game textures
            self.map_textures = {
                MAZE_CONTENT.WALL.value: pygame.transform.scale(pygame.image.load('textures/wall.png'), (TILE_SIZE, TILE_SIZE)),
                MAZE_CONTENT.EMPTY.value: pygame.transform.scale(pygame.image.load('textures/floor.png'), (TILE_SIZE, TILE_SIZE)),
                MAZE_CONTENT.START.value: pygame.transform.scale(pygame.image.load('textures/start.png'), (TILE_SIZE, TILE_SIZE)),
                MAZE_CONTENT.GOAL.value: pygame.transform.scale(pygame.image.load('textures/goal.png'), (TILE_SIZE, TILE_SIZE)),
                MAZE_CONTENT.DOOR.value: pygame.transform.scale(pygame.image.load('textures/door.png'), (TILE_SIZE, TILE_SIZE)),
                MAZE_CONTENT.KEY.value: pygame.transform.scale(pygame.image.load('textures/key.png'), (TILE_SIZE, TILE_SIZE)),
                MAZE_CONTENT.TRAP.value: pygame.transform.scale(pygame.image.load('textures/trap.png'), (TILE_SIZE, TILE_SIZE))
            }
            self.player_texture = pygame.transform.scale(pygame.image.load('textures/player_pin.png'), (TILE_SIZE, TILE_SIZE))
        else:
            self.limit_fps = False


    
    def run(self):
        '''
        main game loop
        '''
        
        while self.maze_queue:  # continue while there are mazes in the queue
            self.resetLevel()
            runs = 0
            
            while runs < self.repeats:
                if self.log_game:
                    print(f"Starting level: {self.level} | Run: {runs + 1} / {self.repeats}")
                running = True
                self.resetRun()
                
                while running:
                    
                    # get event
                    events = pygame.event.get()
                    
                    
                    # rendering
                    
                    # get the view around the player
                    view = self.getView()
                    
                    if self.render:
                        if self.display_full_maze:
                            # print the whole maze
                            for y in range(self.maze.shape[0]):
                                for x in range(self.maze.shape[1]):
                                    tile_value = self.maze[y][x]
                                    draw_pos = (x * TILE_SIZE, y * TILE_SIZE)
                                    self.screen.blit(self.map_textures[tile_value], draw_pos)
                            # draw the player
                            player_draw_pos = (self.player_pos[0] * TILE_SIZE, self.player_pos[1] * TILE_SIZE)
                            self.screen.blit(self.player_texture, player_draw_pos)
                        else:
                            # print only the view
                            for y in range(view.shape[0]):
                                for x in range(view.shape[1]):
                                    tile_value = view[y][x]
                                    draw_pos = (x * TILE_SIZE, y * TILE_SIZE)
                                    self.screen.blit(self.map_textures[tile_value], draw_pos)
                            # draw the player in the center
                            player_draw_pos = ((VISION_SIZE // 2) * TILE_SIZE, (VISION_SIZE // 2) * TILE_SIZE)
                            self.screen.blit(self.player_texture, player_draw_pos)
                        # draw steps taken
                        text = self.font.render(f'{self.steps_taken} / {MAX_STEPS}', True, (125, 125, 125))
                        self.screen.blit(text, (TILE_SIZE // 4, TILE_SIZE // 4))
                        
                        pygame.display.flip()
                    
                    
                    # check for quit events
                    for event in events:
                        if event.type == pygame.QUIT:
                            pygame.quit()
                            return
                        

                    # update recent visit tracking
                    self.recent_visit = np.minimum(self.recent_visit + self.recent_visit_recovery, 1.0)
                    

                    self.rewards += REWARDS.VISIT * self.recent_visit[self.player_pos[1]][self.player_pos[0]]
                    
                    self.recent_visit[self.player_pos[1]][self.player_pos[0]] = 0
                    visited_view = self.getVisitedView()
                        
                    
                    # handles input
                    current_state: StateInfo = StateInfo(view=view.copy(), player_position=self.player_pos.copy(), keys=self.keys, steps_taken=self.steps_taken, visited_view=visited_view.copy())
                    action = self.player.takeAction(current_state)
                    
                    if action == CONTROLS.HUMAN:    # if human input, override with keyboard
                        for event in events:
                            if event.type == pygame.KEYDOWN:
                                if event.key == pygame.K_UP:
                                    action = CONTROLS.UP
                                elif event.key == pygame.K_DOWN:
                                    action = CONTROLS.DOWN
                                elif event.key == pygame.K_LEFT:
                                    action = CONTROLS.LEFT
                                elif event.key == pygame.K_RIGHT:
                                    action = CONTROLS.RIGHT
                                else:
                                    action = CONTROLS.STAY
                                self.steps_taken += 1
                    else:
                        self.steps_taken += 1
            
                    moveDir = CONTROL_ACTIONS.get(action, (0, 0))
                    

                    # update player position
                    new_player_pos = self.player_pos + moveDir
                    
                    
                    # check for backtracking
                    if (self.last_action == CONTROLS.UP and action == CONTROLS.DOWN) or \
                          (self.last_action == CONTROLS.DOWN and action == CONTROLS.UP) or \
                          (self.last_action == CONTROLS.LEFT and action == CONTROLS.RIGHT) or \
                          (self.last_action == CONTROLS.RIGHT and action == CONTROLS.LEFT):
                        self.rewards += REWARDS.BACKTRACK
                    self.last_action = action
                    
                    
                    # check for collisions
                    stateAtNewPos = self.maze[new_player_pos[1]][new_player_pos[0]]
                    if stateAtNewPos == MAZE_CONTENT.WALL.value:
                        # encountered a wall
                        if self.log_player:
                            print("Bumped into a wall!")
                        self.rewards += REWARDS.INVALID
                        self.last_action = CONTROLS.STAY  # cancel backtrack penalty
                    elif stateAtNewPos == MAZE_CONTENT.DOOR.value:
                        # encountered a door
                        if self.keys > 0:
                            # has key
                            if self.log_player:
                                print("You used a key to open the door.")
                            self.keys -= 1
                            self.maze[new_player_pos[1]][new_player_pos[0]] = MAZE_CONTENT.EMPTY.value
                            self.player_pos = new_player_pos
                            self.rewards += REWARDS.DOOR_OPEN
                        else:
                            # no key
                            if self.log_player:
                                print("The door is locked. You need a key to open it.")
                            self.rewards += REWARDS.INVALID
                            self.last_action = CONTROLS.STAY  # cancel backtrack penalty
                    else:
                        self.player_pos = new_player_pos

                    # check for key pickups
                    if stateAtNewPos == MAZE_CONTENT.KEY.value:
                        if self.log_player:
                            print("You've picked up a key!")
                        self.keys += 1
                        self.maze[new_player_pos[1]][new_player_pos[0]] = MAZE_CONTENT.EMPTY.value
                        self.rewards += REWARDS.KEY_PICKUP


                    # check for win condition
                    if np.array_equal(self.player_pos, self.goal_pos):
                        if self.log_player:
                            print("Congratulations! You've reached the goal!")
                        running = False
                        self.rewards += REWARDS.GOAL
                        if self.log_game:
                            print(f"Total rewards: {self.total_rewards + self.rewards}")
                        if self.learning:
                            self.player.gameOver(self.rewards)
                        continue
                    
                    
                    # check for loose condition
                    
                    # check for maximum steps
                    if self.steps_taken >= MAX_STEPS:
                        if self.log_player:
                            print("Maximum steps reached! You lose this run.")
                        running = False
                        self.rewards += REWARDS.outOfSteps(self.player_pos, self.start_pos)
                        if self.log_game:
                            print(f"Total rewards: {self.total_rewards + self.rewards}")
                        if self.learning:
                            self.player.gameOver(self.rewards)
                        continue
                    
                    # check for traps
                    if stateAtNewPos == MAZE_CONTENT.TRAP.value:
                        if self.log_player:
                            print("You stepped on a trap! You lose this run.")
                        running = False
                        self.rewards += REWARDS.TRAP
                        if self.log_game:
                            print(f"Total rewards: {self.total_rewards + self.rewards}")
                        if self.learning:
                            self.player.gameOver(self.rewards)
                        continue
                    
                    
                    # add step penalty
                    if self.rewards == 0:
                        self.rewards += REWARDS.STEP
                
                
                    # send the reward of last step to the agent with updated view (state)
                    if self.learning:
                        next_view = self.getView()
                        next_visited_view = self.getVisitedView()
                        next_state: StateInfo = StateInfo(view=next_view.copy(), player_position=self.player_pos.copy(), keys=self.keys, steps_taken=self.steps_taken, visited_view=next_visited_view.copy())
                        self.player.getRewards(self.rewards, next_state)
                    
                    # print("step rewards:", self.rewards)
                    # update total rewards
                    self.total_rewards += self.rewards
                    self.rewards = 0
                        
                    
                    if self.limit_fps:
                        self.clock.tick(FPS)
                        
                runs += 1

        pygame.quit()
    
    
    def startGame(self, maze_level_list: list[str] = ["level1"], repeats: int = 1, render: bool = True, log_game: bool = True, log_player: bool = True, display_full_maze: bool = False, learning: bool = True):
        '''
        starts the game
            :param maze_level_list: list of maze filenames to load, do not include file extension (.txt)
            :param repeats: number of times to repeat each level
            :param render: whether to render the game window
            :param log_game: whether to print game log messages
            :param log_player: whether to print player log messages
            :param display_full_maze: whether to display the full maze or just the vision grid
            :param learning: whether the agent is learning or just playing
        '''
        self.setup(maze_level_list=maze_level_list, repeats=repeats, render=render, log_game=log_game, log_player=log_player, display_full_maze=display_full_maze, learning=learning)
        self.run()
    

    # helpers

    
    def getView(self) -> np.ndarray:
        '''
        get the current view around the player
        :return: 2D numpy array representing the view
        '''
        # get slice bounds from player position without clipping
        x_0 = self.player_pos[0] - VISION_SIZE // 2
        x_1 = self.player_pos[0] + VISION_SIZE // 2 + 1
        y_0 = self.player_pos[1] - VISION_SIZE // 2
        y_1 = self.player_pos[1] + VISION_SIZE // 2 + 1
        
        # get clipped bounds
        x_0_clip = max(0, x_0)
        x_1_clip = min(self.maze.shape[1], x_1)
        y_0_clip = max(0, y_0)
        y_1_clip = min(self.maze.shape[0], y_1)
        
        # slice the maze
        view = self.maze[y_0_clip:y_1_clip, x_0_clip:x_1_clip]
        
        # pad the view if necessary
        pad_top = y_0_clip - y_0
        pad_bottom = y_1 - y_1_clip
        pad_left = x_0_clip - x_0
        pad_right = x_1 - x_1_clip
        
        return np.pad(view, pad_width=((pad_top, pad_bottom), (pad_left, pad_right)), mode='constant', constant_values=MAZE_CONTENT.WALL.value)
    
    
    def getVisitedView(self) -> np.ndarray:
        '''
        get the current visited view around the player
        :return: 2D numpy array representing the visited view
        '''
        # get slice bounds from player position without clipping
        x_0 = self.player_pos[0] - VISION_SIZE // 2
        x_1 = self.player_pos[0] + VISION_SIZE // 2 + 1
        y_0 = self.player_pos[1] - VISION_SIZE // 2
        y_1 = self.player_pos[1] + VISION_SIZE // 2 + 1
        
        # get clipped bounds
        x_0_clip = max(0, x_0)
        x_1_clip = min(self.maze.shape[1], x_1)
        y_0_clip = max(0, y_0)
        y_1_clip = min(self.maze.shape[0], y_1)
        
        # slice the maze
        view = self.recent_visit[y_0_clip:y_1_clip, x_0_clip:x_1_clip]
        
        # pad the view if necessary
        pad_top = y_0_clip - y_0
        pad_bottom = y_1 - y_1_clip
        pad_left = x_0_clip - x_0
        pad_right = x_1 - x_1_clip
        
        return np.pad(view, pad_width=((pad_top, pad_bottom), (pad_left, pad_right)), mode='constant', constant_values=0.0)
    
    
    def resetLevel(self):
        '''
        resets the level, loads the next maze from the queue
        '''
        # get next maze from queue
        self.level = self.maze_queue.popleft()
        
        base = os.path.dirname(__file__)
        path = os.path.join(base, "levels", self.level + ".txt")
    
        self.current_maze, start_pos_tuple, goal_pos_tuple = load_maze_from_file(path)

        self.start_pos[:] = start_pos_tuple
        self.goal_pos[:] = goal_pos_tuple
        
        # set up the display
        if self.render:
            if self.display_full_maze:
                height = self.current_maze.shape[0] * TILE_SIZE
                width = self.current_maze.shape[1] * TILE_SIZE
            else:
                height = VISION_SIZE * TILE_SIZE
                width = VISION_SIZE * TILE_SIZE
            self.screen = pygame.display.set_mode((width, height))
    
    
    
    def resetRun(self):
        '''
        resets the run to initial state, loads the current maze again
        '''
        self.maze = np.copy(self.current_maze)
        self.recent_visit = np.ones_like(self.maze, dtype=np.float32)  # initialize all cells as never visited
        self.player_pos[:] = np.copy(self.start_pos)
        self.steps_taken = 0
        self.keys = 0
        self.rewards = 0
        self.total_rewards = 0
        self.last_action = CONTROLS.STAY
        