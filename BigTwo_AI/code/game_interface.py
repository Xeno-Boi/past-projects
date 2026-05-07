from bigtwo import game
from simple_ai import SimpleAi
from even_simpler_ai import EvenSimplerAi
from q_learning_ai import QLearningAi
from card import *

game_type = 1

iterations = 100
per_hand_iterations = 30

i = 0
q_win = 0

if game_type == 1:
    while i < iterations:
        print(f"Game {i + 1} of {iterations}... ({q_win} / {i})")
        ai_players = {}
        #ai_players[1] = SimpleAi(1)
        #ai_players[2] = SimpleAi(2)
        #ai_players[3] = SimpleAi(3)

        #ai_players[1] = EvenSimplerAi(1)
        #ai_players[2] = EvenSimplerAi(2)
        #ai_players[3] = EvenSimplerAi(3)
        
        ai_players[1] = QLearningAi(1)
        ai_players[2] = QLearningAi(2)
        ai_players[3] = QLearningAi(3)
        #ai_players[4] = QLearningAi(4)
        #ai_players[4] = SimpleAi(4)

        #ai_count = 4
        #for i in range(1, ai_count + 1):
        #    ai_players[i] = SimpleAi(i)

        winner = game(ai_players)
        
        if winner == 4:
            q_win += 1
        
        i += 1

    print(f"Q-learning AI won {q_win} out of {iterations} games.")
    
elif game_type == 2:
    game_count = 0
    while i < iterations:
        deck = [Card(suit, rank) for suit in Card.suits for rank in Card.ranks]
        random.shuffle(deck)
        
        player1_hand = []
        player2_hand = []
        player3_hand = []
        player4_hand = []
        
        for num in range(13):
            player1_hand.append(deck.pop())
            player2_hand.append(deck.pop())
            player3_hand.append(deck.pop())
            player4_hand.append(deck.pop())
            
        player1_hand.sort()
        player2_hand.sort()
        player3_hand.sort()
        player4_hand.sort()
        
        deck_list = [player1_hand, player2_hand, player3_hand, player4_hand]
        
        j = 0
        q_win_per_hand = 0
        while j < per_hand_iterations:
            print(f"Hand {i + 1} / {iterations}, Game {j + 1} of {per_hand_iterations}... ({q_win_per_hand} / {per_hand_iterations})")
            ai_players = {}
            #ai_players[1] = SimpleAi(1)
            #ai_players[2] = SimpleAi(2)
            #ai_players[3] = SimpleAi(3)

            ai_players[1] = EvenSimplerAi(1)
            ai_players[2] = EvenSimplerAi(2)
            ai_players[3] = EvenSimplerAi(3)
            
            #ai_players[1] = QLearningAi(1)
            #ai_players[2] = QLearningAi(2)
            #ai_players[3] = QLearningAi(3)
            ai_players[4] = QLearningAi(4)
            #ai_players[4] = SimpleAi(4)

            #ai_count = 4
            #for i in range(1, ai_count + 1):
            #ai_players[i] = SimpleAi(i)
            

            winner = game(ai_players, deck_list)
        
            if winner == 4:
                q_win += 1
                q_win_per_hand += 1
            
            j += 1
            game_count += 1
        
        i += 1

    print(f"Q-learning AI won {q_win} out of {iterations * 10} games.")