from card import *

# simple ai class
class EvenSimplerAi:
    def __init__(self, player_id):
        self.player_id = player_id
    
    def playCards(self, player_hand, last_played_cards, player_1_card_count, player_2_card_count, player_3_card_count):
        to_play = None
        valid_actions = get_valid_actions(player_hand, last_played_cards)
        if len(valid_actions) == 1:
            to_play = valid_actions[0]
        else:
            to_play = get_valid_actions(player_hand, last_played_cards)[1]
        return to_play
        
    def game_end(self, player_hand, last_played_cards, p1_count, p2_count, p3_count):
        # does nothing
        return 0