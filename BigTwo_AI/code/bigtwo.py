import numpy as np
import random
from card import Card, isSingle, isPair, isTriplet, isStraight, isFlush, isFullHouse, isFourOfAKind, isStraightFlush, isCombination, isValidPlay

debug = True
instant_win = False
random_deal = True
    
# deal cards
def dealCards():
    if (random_deal):
        deck = [Card(suit, rank) for suit in Card.suits for rank in Card.ranks]
        random.shuffle(deck)
        
        player1_hand = []
        player2_hand = []
        player3_hand = []
        player4_hand = []
        
        for i in range(13):
            player1_hand.append(deck.pop())
            player2_hand.append(deck.pop())
            player3_hand.append(deck.pop())
            player4_hand.append(deck.pop())
            
        player1_hand.sort()
        player2_hand.sort()
        player3_hand.sort()
        player4_hand.sort()
    else:
        player1_hand = []
        player1_hand.append(Card('S', '3'))
        player1_hand.append(Card('D', '4'))
        player1_hand.append(Card('C', '4'))
        player1_hand.append(Card('H', '4'))
        player1_hand.append(Card('S', '4'))
        player1_hand.append(Card('D', '7'))
        player1_hand.append(Card('S', '9'))
        player1_hand.append(Card('D', 'Q'))
        player1_hand.append(Card('H', 'K'))
        player1_hand.append(Card('S', 'K'))
        player1_hand.append(Card('C', 'A'))
        player1_hand.append(Card('H', 'A'))
        player1_hand.append(Card('D', '2'))
        
        player2_hand = []
        player2_hand.append(Card('C', '3'))
        player2_hand.append(Card('H', '3'))
        player2_hand.append(Card('H', '5'))
        player2_hand.append(Card('S', '6'))
        player2_hand.append(Card('D', '8'))
        player2_hand.append(Card('H', '10'))
        player2_hand.append(Card('S', '10'))
        player2_hand.append(Card('C', 'J'))
        player2_hand.append(Card('H', 'J'))
        player2_hand.append(Card('H', 'Q'))
        player2_hand.append(Card('S', 'Q'))
        player2_hand.append(Card('H', '2'))
        player2_hand.append(Card('S', '2'))
        
        player3_hand = []
        player3_hand.append(Card('D', '3'))
        player3_hand.append(Card('C', '5'))
        player3_hand.append(Card('D', '6'))
        player3_hand.append(Card('C', '6'))
        player3_hand.append(Card('H', '6'))
        player3_hand.append(Card('H', '8'))
        player3_hand.append(Card('S', '8'))
        player3_hand.append(Card('D', '9'))
        player3_hand.append(Card('H', '9'))
        player3_hand.append(Card('C', 'Q'))
        player3_hand.append(Card('D', 'K'))
        player3_hand.append(Card('C', 'K'))
        player3_hand.append(Card('S', 'A'))
        
        player4_hand = []
        player4_hand.append(Card('D', '5'))
        player4_hand.append(Card('S', '5'))
        player4_hand.append(Card('C', '7'))
        player4_hand.append(Card('H', '7'))
        player4_hand.append(Card('S', '7'))
        player4_hand.append(Card('C', '8'))
        player4_hand.append(Card('C', '9'))
        player4_hand.append(Card('D', '10'))
        player4_hand.append(Card('C', '10'))
        player4_hand.append(Card('D', 'J'))
        player4_hand.append(Card('S', 'J'))
        player4_hand.append(Card('D', 'A'))
        player4_hand.append(Card('C', '2'))
        
        
    
    return player1_hand, player2_hand, player3_hand, player4_hand

# play cards (human player)
def playCards(player_hand, last_played_cards):
    print("Your hand:")
    for i in range(len(player_hand)):
        print(f"{i + 1}: {player_hand[i]}")
    
    while True:
        play = input("Enter the cards you want to play (separated by commas, e.g. 1,2,5), or input 'pass' to pass the turn: ")
        cards = []
        if (instant_win and play == "win"):
            cards = ["win"]
            return cards
        if (play == "pass" or play == ""):  # pass
            cards = []
        else:
            play = play.split(",")
            
            invalid = False
            for card in play:
                try:
                    int(card)
                except ValueError:
                    print("Invalid card number. Try again.")
                    invalid = True
                    break
                if (int(card) < 1 or int(card) > len(player_hand)):
                    print("Invalid card number. Try again.")
                    invalid = True
                    break
                if (card != ""):
                    cards.append(player_hand[int(card) - 1])
            if (invalid):
                continue
            cards.sort()
        
        if (isValidPlay(cards, last_played_cards)):
            return cards
        else:
            print("Invalid play. Try again.")
            
# play cards (ai player)
def playCardsAI(ai_player, player_hand, last_played_cards, player_1_hand, player_2_hand, player_3_hand):
    player_1_card_count = len(player_1_hand)
    player_2_card_count = len(player_2_hand)
    player_3_card_count = len(player_3_hand)
    
    if (debug):
        print("Ai's hand:")
        for i in range(len(player_hand)):
            print(f"{i + 1}: {player_hand[i]}")
    
    cards = ai_player.playCards(player_hand, last_played_cards, player_1_card_count, player_2_card_count, player_3_card_count)
    cards.sort()
    return cards
                    
# remove card from hand
def removeCard(player_hand, cards):
    for card in cards:
        try:
            player_hand.remove(card)
        except ValueError:
            continue
        
        
# main game
def game(ai_players = None, initial_hand = None):
    ai_players = ai_players or {}
    
    winner = None
    
    # deal cards
    if (initial_hand is None):
        player1_hand, player2_hand, player3_hand, player4_hand = dealCards()
    else:
        player1_hand = initial_hand[0].copy()
        player2_hand = initial_hand[1].copy()
        player3_hand = initial_hand[2].copy()
        player4_hand = initial_hand[3].copy()
    
    players = {
        1: player1_hand,
        2: player2_hand,
        3: player3_hand,
        4: player4_hand
    }
    
    if (debug):
        print("Player 1's hand:")
        for card in player1_hand:
            print(card)
        
        print("\nPlayer 2's hand:")
        for card in player2_hand:
            print(card)
            
        print("\nPlayer 3's hand:")
        for card in player3_hand:
            print(card)
            
        print("\nPlayer 4's hand:")
        for card in player4_hand:
            print(card)
        
    # main game loop
    while (winner is None):
        last_played_cards = []
        last_played_player = None
        current_player = 1
        
        # find first player
        for i in range(1, 5):
            if (Card('D', '3') in players[i]):
                current_player = i
                break
        
        while True:
            # reset last played cards if the all players passed
            if (last_played_player == current_player):
                last_played_cards = []
                last_played_player = None
            
            played_cards = []
            
            if (current_player in ai_players):  # ai player
                
                if (debug):
                    print(f"\nAi {current_player}'s turn:\n")
                
                player_hands = []
                for i in range(1, 5):
                    if (i != current_player):
                        player_hands.append(players[i])
                played_cards = playCardsAI(ai_players[current_player], players[current_player], last_played_cards, player_hands[0], player_hands[1], player_hands[2])
                
                if (debug):
                    print("played:")
                    for card in played_cards:
                        print(card)
            else:   # human player
            
                print(f"\nPlayer {current_player}'s turn:\n")
                
                # print other players' hands
                for i in range(1, 5):
                    if (i != current_player):
                        print(f"Player {i}'s hand: {len(players[i])} cards")
                print()
                
                # print last played cards
                if (last_played_cards != []):
                    print("Last played cards:")
                    for card in last_played_cards:
                        print(card)
                    print()
                else:
                    print("No cards have been played yet.\n")
                
                # play cards
                played_cards = playCards(players[current_player], last_played_cards)
                
                if (instant_win and played_cards == ["win"]):
                    players[current_player] = []
                    played_cards = []
            
            # remove played cards from player's hand
            removeCard(players[current_player], played_cards)
            
            # update last played card
            if (played_cards != []):    # not pass
                last_played_cards = played_cards
                last_played_player = current_player
        
            # check if player has won
            if (len(players[current_player]) == 0):
                winner = current_player
                for ai_player in range(1, 5):
                    if ai_player in ai_players:    # ai player
                        player_hands = []
                        for i in range(1, 5):
                            if (i != current_player):
                                player_hands.append(players[i])
                        ai_players[ai_player].game_end(players[i], last_played_cards, len(player_hands[0]), len(player_hands[1]), len(player_hands[2]))
                break
            
            # next player
            current_player += 1
            if (current_player > 4):
                current_player = 1
            
    if (debug):
        print(f"Player {winner} wins!")
    return winner