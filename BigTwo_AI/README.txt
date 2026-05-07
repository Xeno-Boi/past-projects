Big Two AI
December, 2024

purpose:
To create AI agents that plays the card game "Big Two".
Two agents are implemented using trivial logic and one is implemented to use Q-Learning.


To run:

1. install python 3.13.7 (version the project was developed in)
2. install numpy using pip
	- in command line, input "pip install numpy"
3. set parameters in bigtwo.py and game_interface.py (explained later)
4. open command line in the "code" folder and run the desired game mode using command lines stated below

modes:
- 4 players versus
   python -c 'from bigtwo import *; game();'

- games that involve AI players
   python game_interface.py


Parameters

Parameters are stored at the top inside bigtwo.py and game_interface.py.
Here are a detailed explanation to all the parameters.

bigtwo.py

   debug
	True -> Displays all player's hands after every turn
	False -> Disables debug mode

   instant_win
	True -> Enables instant win. During any turn, if "win" is input during play, current player immediately wins the game.
	False -> Turns off instant win.

   random_deal
	Ture -> Randomly deals card to the players at the start of the game.
	False -> Deals a predetermined hand to each player at the start of the game.
	The predetermined hand is shown inside the "dealCards()" function, after the first "else:".

game_interface.py
** only takes effect when running the game using game_interface.py

   game_type
	1 -> Game iterates a set amount of times automatically, each time running 1 full round (until one player wins)
	     The players can be set to be different types of AI or users, and is set on line 19. Do not set for more than 4 players.
	     If the number of ai players is set to be less than 4, the game automatically fills in human players up to 4.

	2 -> Game iterates a set amount of times automatically, each time running a set amount of rounds with the same hand. The hand changes after.
	     Players can be set at line 75 using the same logic as above.


Files
- bigtwo.py
   Contains logic for the main game.

- card.py
   Contains all cards as objects.
   Contains all possible play combinations.
   Contains logic to determine if a play is valid.
   Contains comparisons for cards and hands.

- even_simpler_ai.py
   The most simple AI variant. Plays any possible combination.

- game_interface.py
   Interface for setting up games that involves AI players.

- q_learning_ai.py
   Most advanced AI variant. Uses Q-learning to learn and improve through multiple plays.

- simple_ai.py
   A simple AI variant. Chooses the smallest possible combination to play.