from card import *

# simple ai class
class SimpleAi:
    def __init__(self, player_id):
        self.player_id = player_id
    
    def playCards(self, player_hand, last_played_cards, player_1_card_count, player_2_card_count, player_3_card_count):
        to_play = self.find_lowest_card(player_hand, last_played_cards)
        return to_play
    
    def find_lowest_card(self, player_hand, last_played_cards):
        if (last_played_cards == []):   # first play
            combination = findBiggestCombination(player_hand)
            if (combination):
                return combination
            
            triplet = findSmallestTriplet(player_hand)
            if (triplet):
                return triplet
            
            pair = findSmallestPair(player_hand)
            if (pair):
                return pair
            
            single = findSmallestSingle(player_hand)
            return single
            
        else:
            last_played_cards.sort()
            if (len(last_played_cards) == 1):
                single = findSmallestSingleAboveCard(player_hand, last_played_cards[0])
                if (single):
                    return single
            elif (len(last_played_cards) == 2):
                pair = findSmallestPairAboveCard(player_hand, last_played_cards[1])
                if (pair):
                    return pair
            elif (len(last_played_cards) == 3):
                triplet = findSmallestTripletAboveCard(player_hand, last_played_cards[2])
                if (triplet):
                    return triplet
            elif (len(last_played_cards) == 5):
                combination = findBiggestCombinationAboveHand(player_hand, last_played_cards)
                if (combination):
                    return combination
            return []
        
    def game_end(self, player_hand, last_played_cards, p1_count, p2_count, p3_count):
        # does nothing
        return 0