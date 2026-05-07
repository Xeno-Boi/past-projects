# rl-project

purpose:
To create AI agents that navigates a grid maze with limited vision.
An agent is implemented using Actor-Critic function approximation TD learning

--- Group members ---
Ho Nam Leung (101197127)
Henry Johnson (101163220)
Vincent Vogl (101141514)

--- Instructions to run the code ---

1. install all packages with the appropriate versions from 'requirements.txt'
	Make sure jax and jaxlib use the same version
2. in 'interface.py', select the appropriate function to run in "main"
3. Set the parameters in the startGame() function in 'interface.py'
4. Set the parameters in the RLAgent constructor in 'interface.py'
4. Navigate to the code folder and run 'interface.py'


--- interface.py functions ---

- humanPlayerGame()
	Game played by human player

- rlAgentLearningGame()
	Game played by rl agent, agent learning is turned on

- rlAgentGame()
	Game played by rl agent, agent learning is turned off

- randomAgentGame()
	Game played by a random agent

--- parameters ---

startGame()
   
   - maze_level_list: list of maze filenames to load, do not include file extension (.txt)

   - repeats: number of times to repeat each level

   - render: whether to render the game window

   - log_game: whether to print game log messages

   - log_player: whether to print player log messages

   - display_full_maze: whether to display the full maze or just the vision grid

   - learning: whether the agent is learning or just playing


RLAgent Constructor

   - gamma: discount factor for future rewards

   - actor_step_size: step size for actor

   - critic_step_size: step size for critic

   - tau: temperature parameter for softmax policy. Higher tau = more exploration


--- Files ---

- defs.py
   define constants, parameters, class and structures used by other files

- game.py
   contains the logic for the game

- interface.py
   contains the interface between the game and the RL agent

- map_builder.py
   contains the implementation of the map loader

- random_agent.py
   contains the Random agent implementation

- rl_agent.py
   contains the RL agent implementation

--- Folders ---

- levels
   stores txt files for the levels

- textures
   stores texture files for the game

- weights
   stores the learnt weight for the agent