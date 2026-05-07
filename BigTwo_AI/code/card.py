import random

# class for playing cards
class Card:
    # possible suits and ranks
    # Ranks in ascending order
    ranks = {'3': 3, '4': 4, '5': 5, '6': 6, '7': 7, '8': 8, '9': 9, '10': 10, 'J': 11, 'Q': 12, 'K': 13, 'A': 14, '2': 15}
    
    # Suits in ascending order
    suits = {'D': 0, 'C': 1, 'H': 2, 'S': 3}    # diamond, spade, heart, club

    # attributes
    suit = None
    rank = None

    # constructor
    def __init__(self, suit, rank):
        if rank not in self.ranks:
            raise ValueError(f"Invalid rank: {rank}")
        if suit not in self.suits:
            raise ValueError(f"Invalid suit: {suit}")
        
        self.rank = rank
        self.suit = suit
    
    # comparison operators
    def __eq__(self, other):
        if isinstance(other, Card):
            return (self.ranks[self.rank], self.suits[self.suit]) == \
                   (self.ranks[other.rank], self.suits[other.suit])
        return NotImplemented

    def __lt__(self, other):
        if isinstance(other, Card):
            # Compare by rank first, then by suit if ranks are equal
            return (self.ranks[self.rank], self.suits[self.suit]) < \
                   (self.ranks[other.rank], self.suits[other.suit])
        return NotImplemented
    
    # string representation
    def __str__(self):
        suit_name = ""
        if self.suit == 'D':
            suit_name = "Diamonds"
        elif self.suit == 'S':
            suit_name = "Spades"
        elif self.suit == 'H':
            suit_name = "Hearts"
        else:
            suit_name = "Clubs"
        return f"{self.rank} of {suit_name}"
    
# combination check
# checks if the played cards are a valid combination and returns the combination value
def isSingle(cards):
    if (len(cards) == 1):
        return cards
    return False

def isPair(cards):
    if (len(cards) == 2):
        if (cards[0].rank == cards[1].rank):
            return cards[1]
    return False

def isTriplet(cards):
    if (len(cards) == 3):
        if (cards[0].rank == cards[1].rank == cards[2].rank):
            return cards[2]
    return False

# five cards
def isStraight(cards):
    if (len(cards) == 5):
        cards.sort()
        for i in range(1, 5):
            if (Card.ranks[cards[i].rank] != Card.ranks[cards[i - 1].rank] + 1):
                return False
        return cards[4]
    return False

def isFlush(cards):
    if (len(cards) == 5):
        cards.sort()
        for i in range(1, 5):
            if (cards[i].suit != cards[i - 1].suit):
                return False
        return cards[4]
    return False

def isFullHouse(cards):
    if (len(cards) == 5):
        cards.sort()
        if (cards[0].rank == cards[1].rank == cards[2].rank and cards[3].rank == cards[4].rank):
            return cards[2]
        elif (cards[0].rank == cards[1].rank and cards[2].rank == cards[3].rank == cards[4].rank):
            return cards[4]
    return False

def isFourOfAKind(cards):
    if (len(cards) == 5):
        cards.sort()
        if (cards[0].rank == cards[1].rank == cards[2].rank == cards[3].rank):
            return cards[3]
        elif (cards[1].rank == cards[2].rank == cards[3].rank == cards[4].rank):
            return cards[4]
    return False

def isStraightFlush(cards):
    if (len(cards) == 5):
        cards.sort()
        if (isStraight(cards) and isFlush(cards)):
            return cards[4]
    return False

# returns the combination value and the highest card of the combination
def isCombination(cards):
    if (isStraightFlush(cards)):
        return 5, isStraightFlush(cards)
    elif (isFourOfAKind(cards)):
        return 4, isFourOfAKind(cards)
    elif (isFullHouse(cards)):
        return 3, isFullHouse(cards)
    elif (isFlush(cards)):
        return 2, isFlush(cards)
    elif (isStraight(cards)):
        return 1, isStraight(cards)
    else:
        return False, False
    
# check if the played cards are valid
def isValidPlay(cards, last_played_cards):
    if (last_played_cards == []):   # first play
        if (cards == []):   # cant pass on first play
            return False
        elif (isSingle(cards) or isPair(cards) or isTriplet(cards) or isStraight(cards) or isFlush(cards) or isFullHouse(cards) or isFourOfAKind(cards) or isStraightFlush(cards)):
            return True
    elif (cards == []): # pass
        return True
    elif (len(cards) == len(last_played_cards)):    # same number of cards
        if (isSingle(cards)):
            if (cards[0] > last_played_cards[0]):
                return True
        elif (isPair(cards)):
            card_value = isPair(cards)
            last_played_value = isPair(last_played_cards)
            if (card_value > last_played_value):
                return True
        elif (isTriplet(cards)):
            card_value = isTriplet(cards)
            last_played_value = isTriplet(last_played_cards)
            if (card_value > last_played_value):
                return True
        else:   # combination
            card_combination, card_value = isCombination(cards)
            last_played_combination, last_played_value = isCombination(last_played_cards)
            if (card_combination):  # valid combination
                if (card_combination > last_played_combination):    # higher combination
                    return True
                elif (card_combination == last_played_combination and card_value > last_played_value):  # same combination but higher value
                    return True
    return False

# find combination from hand

def findSmallestSingle(hand):
    hand.sort()
    for card in hand:
        if (isSingle([card])):
            return [card]
    return False

def findSmallestSingleAboveCard(hand, card):
    hand.sort()
    for c in hand:
        if (isSingle([c]) and c > card):
            return [c]
    return False

def findSmallestPair(hand):
    hand.sort()
    for i in range(len(hand) - 1):
        if (isPair([hand[i], hand[i + 1]])):
            return [hand[i], hand[i + 1]]
    return False

def findSmallestPairAboveCard(hand, card):
    hand.sort()
    for i in range(len(hand) - 1):
        if (isPair([hand[i], hand[i + 1]]) and hand[i + 1] > card):
            return [hand[i], hand[i + 1]]
    return False

def findSmallestTriplet(hand):
    hand.sort()
    for i in range(len(hand) - 2):
        if (isTriplet([hand[i], hand[i + 1], hand[i + 2]])):
            return [hand[i], hand[i + 1], hand[i + 2]]
    return False

def findSmallestTripletAboveCard(hand, card):
    hand.sort()
    for i in range(len(hand) - 2):
        if (isTriplet([hand[i], hand[i + 1], hand[i + 2]]) and hand[i + 2] > card):
            return [hand[i], hand[i + 1], hand[i + 2]]
    return False

def findSmallestStraight(hand):
    hand.sort()
    for i in range(len(hand) - 4):
        for j in range(i + 1, len(hand) - 3):
            if (Card.ranks[hand[j].rank] == Card.ranks[hand[i].rank] + 1):
                for k in range(j + 1, len(hand) - 2):
                    if (Card.ranks[hand[k].rank] == Card.ranks[hand[j].rank] + 1):
                        for l in range(k + 1, len(hand) - 1):
                            if (Card.ranks[hand[l].rank] == Card.ranks[hand[k].rank] + 1):
                                for m in range(l + 1, len(hand)):
                                    if (Card.ranks[hand[m].rank] == Card.ranks[hand[l].rank] + 1):
                                        return [hand[i], hand[j], hand[k], hand[l], hand[m]]
    return False

def findSmallestStraightAboveCard(hand, card):
    hand.sort()
    for i in range(len(hand) - 4):
        for j in range(i + 1, len(hand) - 3):
            if (Card.ranks[hand[j].rank] == Card.ranks[hand[i].rank] + 1):
                for k in range(j + 1, len(hand) - 2):
                    if (Card.ranks[hand[k].rank] == Card.ranks[hand[j].rank] + 1):
                        for l in range(k + 1, len(hand) - 1):
                            if (Card.ranks[hand[l].rank] == Card.ranks[hand[k].rank] + 1):
                                for m in range(l + 1, len(hand)):
                                    if (Card.ranks[hand[m].rank] == Card.ranks[hand[l].rank] + 1 and hand[m] > card):
                                        return [hand[i], hand[j], hand[k], hand[l], hand[m]]
    return False

def findSmallestFlush(hand):
    hand.sort()
    for i in range(len(hand) - 4):
        for j in range(i + 1, len(hand) - 3):
            if (hand[i].suit == hand[j].suit):
                for k in range(j + 1, len(hand) - 2):
                    if (hand[j].suit == hand[k].suit):
                        for l in range(k + 1, len(hand) - 1):
                            if (hand[k].suit == hand[l].suit):
                                for m in range(l + 1, len(hand)):
                                    if (hand[l].suit == hand[m].suit):
                                        return [hand[i], hand[j], hand[k], hand[l], hand[m]]
    return False

def findSmallestFlushAboveCard(hand, card):
    hand.sort()
    for i in range(len(hand) - 4):
        for j in range(i + 1, len(hand) - 3):
            if (hand[i].suit == hand[j].suit):
                for k in range(j + 1, len(hand) - 2):
                    if (hand[j].suit == hand[k].suit):
                        for l in range(k + 1, len(hand) - 1):
                            if (hand[k].suit == hand[l].suit):
                                for m in range(l + 1, len(hand)):
                                    if (hand[l].suit == hand[m].suit and hand[m] > card):
                                        return [hand[i], hand[j], hand[k], hand[l], hand[m]]
    return False

def findSmallestFullHouse(hand):
    hand.sort()
    triplet = findSmallestTriplet(hand)
    if (triplet):
        for i in range(len(hand) - 1):
            if (hand[i] not in triplet):
                for j in range(i + 1, len(hand)):
                    if (hand[j] not in triplet and isPair([hand[i], hand[j]])):
                        return triplet + [hand[i], hand[j]]
    return False

def findSmallestFullHouseAboveCard(hand, card):
    hand.sort()
    triplet = findSmallestTripletAboveCard(hand, card)
    if (triplet):
        for i in range(len(hand) - 1):
            if (hand[i] not in triplet):
                for j in range(i + 1, len(hand)):
                    if (hand[j] not in triplet and isPair([hand[i], hand[j]])):
                        return triplet + [hand[i], hand[j]]
    return False

def findSmallestFourOfAKind(hand):
    hand.sort()
    for i in range(len(hand) - 3):
        if (Card.ranks[hand[i].rank] == Card.ranks[hand[i + 1].rank] == Card.ranks[hand[i + 2].rank] == Card.ranks[hand[i + 3].rank]):
            for j in range(len(hand)):
                if (j != i and j != i + 1 and j != i + 2 and j != i + 3):
                    return [hand[i], hand[i + 1], hand[i + 2], hand[i + 3], hand[j]]
    return False

def findSmallestFourOfAKindAboveCard(hand, card):
    hand.sort()
    for i in range(len(hand) - 3):
        if (Card.ranks[hand[i].rank] == Card.ranks[hand[i + 1].rank] == Card.ranks[hand[i + 2].rank] == Card.ranks[hand[i + 3].rank] and hand[i + 3] > card):
            for j in range(len(hand)):
                if (j != i and j != i + 1 and j != i + 2 and j != i + 3):
                    return [hand[i], hand[i + 1], hand[i + 2], hand[i + 3], hand[j]]
    return False

def findSmallestStraightFlush(hand):
    hand.sort()
    for i in range(len(hand) - 4):
        for j in range(i + 1, len(hand) - 3):
            if (Card.ranks[hand[j].rank] == Card.ranks[hand[i].rank] + 1 and hand[j].suit == hand[i].suit):
                for k in range(j + 1, len(hand) - 2):
                    if (Card.ranks[hand[k].rank] == Card.ranks[hand[j].rank] + 1 and hand[k].suit == hand[j].suit):
                        for l in range(k + 1, len(hand) - 1):
                            if (Card.ranks[hand[l].rank] == Card.ranks[hand[k].rank] + 1 and hand[l].suit == hand[k].suit):
                                for m in range(l + 1, len(hand)):
                                    if (Card.ranks[hand[m].rank] == Card.ranks[hand[l].rank] + 1 and hand[m].suit == hand[l].suit):
                                        return [hand[i], hand[j], hand[k], hand[l], hand[m]]
    return False

def findSmallestStraightFlushAboveCard(hand, card):
    hand.sort()
    for i in range(len(hand) - 4):
        for j in range(i + 1, len(hand) - 3):
            if (Card.ranks[hand[j].rank] == Card.ranks[hand[i].rank] + 1 and hand[j].suit == hand[i].suit):
                for k in range(j + 1, len(hand) - 2):
                    if (Card.ranks[hand[k].rank] == Card.ranks[hand[j].rank] + 1 and hand[k].suit == hand[j].suit):
                        for l in range(k + 1, len(hand) - 1):
                            if (Card.ranks[hand[l].rank] == Card.ranks[hand[k].rank] + 1 and hand[l].suit == hand[k].suit):
                                for m in range(l + 1, len(hand)):
                                    if (Card.ranks[hand[m].rank] == Card.ranks[hand[l].rank] + 1 and hand[m].suit == hand[l].suit and hand[m] > card):
                                        return [hand[i], hand[j], hand[k], hand[l], hand[m]]
    return False

def findBiggestCombination(hand):
    royal_flush = findSmallestStraightFlush(hand)
    if (royal_flush):
        return royal_flush
    four_of_a_kind = findSmallestFourOfAKind(hand)
    if (four_of_a_kind):
        return four_of_a_kind
    full_house = findSmallestFullHouse(hand)
    if (full_house):
        return full_house
    flush = findSmallestFlush(hand)
    if (flush):
        return flush
    straight = findSmallestStraight(hand)
    if (straight):
        return straight
    return False

def findBiggestCombinationAboveHand(hand, last_played_cards):
    last_played_combination, last_played_value = isCombination(last_played_cards)
    
    if (last_played_combination == 5):  # royal flush
        royal_flush = findSmallestStraightFlushAboveCard(hand, last_played_value)
        if (royal_flush):
            return royal_flush
        return False
    else:
        royal_flush = findSmallestStraightFlush(hand)
        if (royal_flush):
            return royal_flush
        
    if (last_played_combination == 4):  # four of a kind
        four_of_a_kind = findSmallestFourOfAKindAboveCard(hand, last_played_value)
        if (four_of_a_kind):
            return four_of_a_kind
        return False
    else:
        four_of_a_kind = findSmallestFourOfAKind(hand)
        if (four_of_a_kind):
            return four_of_a_kind
    
    if (last_played_combination == 3):  # full house
        full_house = findSmallestFullHouseAboveCard(hand, last_played_value)
        if (full_house):
            return full_house
        return False
    else:
        full_house = findSmallestFullHouse(hand)
        if (full_house):
            return full_house
        
    if (last_played_combination == 2):  # flush
        flush = findSmallestFlushAboveCard(hand, last_played_value)
        if (flush):
            return flush
        return False
    else:
        flush = findSmallestFlush(hand)
        if (flush):
            return flush
        
    if (last_played_combination == 1):  # straight
        straight = findSmallestStraightAboveCard(hand, last_played_value)
        if (straight):
            return straight
        return False
    
    return False

def get_valid_actions(hand, last_played_cards):
        valid_actions = []
        if last_played_cards != []: # not the first play
            valid_actions.append([])  # include "pass"
            
        hand.sort()
        
        # singles
        for card in hand:
            if isValidPlay([card], last_played_cards):
                valid_actions.append([card])
        # pairs
        for i in range(len(hand) - 1):
            for j in range(i + 1, min(i + 4, len(hand))):
                if isValidPlay([hand[i], hand[j]], last_played_cards):
                    valid_actions.append([hand[i], hand[j]])
        # triplets
        for i in range(len(hand) - 2):
            for j in range(i + 1, min(i + 4, len(hand))):
                for k in range(j + 1, min(j + 3, len(hand))):
                    if isValidPlay([hand[i], hand[j], hand[k]], last_played_cards):
                        valid_actions.append([hand[i], hand[j], hand[k]])
        # combinations
        for i in range(len(hand) - 4):
            for j in range(i + 1, len(hand) - 3):
                for k in range(j + 1, len(hand) - 2):
                    for l in range(k + 1, len(hand) - 1):
                        for m in range(l + 1, len(hand)):
                            if isValidPlay([hand[i], hand[j], hand[k], hand[l], hand[m]], last_played_cards):
                                valid_actions.append([hand[i], hand[j], hand[k], hand[l], hand[m]])            
        return valid_actions

def get_combination_count(hand):
    output = [0, 0, 0, 0, 0, 0, 0, 0]   # singles, pairs, triplets, straights, flushes, full houses, four of a kinds, straight flushes
    hand.sort()
    
    # singles
    for card in hand:
        output[0] += 1
    # pairs
    for i in range(len(hand) - 1):
        for j in range(i + 1, min(i + 4, len(hand))):
            if (isPair([hand[i], hand[j]])):
                output[1] += 1
    # triplets
    for i in range(len(hand) - 2):
        for j in range(i + 1, min(i + 4, len(hand))):
            for k in range(j + 1, min(j + 3, len(hand))):
                if (isTriplet([hand[i], hand[j], hand[k]])):
                    output[2] += 1
    # straights
    for i in range(len(hand) - 4):
        for j in range(i + 1, len(hand) - 3):
            for k in range(j + 1, len(hand) - 2):
                for l in range(k + 1, len(hand) - 1):
                    for m in range(l + 1, len(hand)):
                        if (isStraight([hand[i], hand[j], hand[k], hand[l], hand[m]])):
                            output[3] += 1
    # flushes
    for i in range(len(hand) - 4):
        for j in range(i + 1, len(hand) - 3):
            for k in range(j + 1, len(hand) - 2):
                for l in range(k + 1, len(hand) - 1):
                    for m in range(l + 1, len(hand)):
                        if (isFlush([hand[i], hand[j], hand[k], hand[l], hand[m]])):
                            output[4] += 1
    # full houses
    for i in range(len(hand) - 4):
        for j in range(i + 1, len(hand) - 3):
            for k in range(j + 1, len(hand) - 2):
                for l in range(k + 1, len(hand) - 1):
                    for m in range(l + 1, len(hand)):
                        if (isFullHouse([hand[i], hand[j], hand[k], hand[l], hand[m]])):
                            output[5] += 1
    # four of a kinds
    for i in range(len(hand) - 4):
        for j in range(i + 1, len(hand) - 3):
            for k in range(j + 1, len(hand) - 2):
                for l in range(k + 1, len(hand) - 1):
                    for m in range(l + 1, len(hand)):
                        if (isFourOfAKind([hand[i], hand[j], hand[k], hand[l], hand[m]])):
                            output[6] += 1
    # straight flushes
    for i in range(len(hand) - 4):
        for j in range(i + 1, len(hand) - 3):
            for k in range(j + 1, len(hand) - 2):
                for l in range(k + 1, len(hand) - 1):
                    for m in range(l + 1, len(hand)):
                        if (isStraightFlush([hand[i], hand[j], hand[k], hand[l], hand[m]])):
                            output[7] += 1
    
    return output

def get_big_cards_count(hand):
    count = 0
    for card in hand:
        if (Card.ranks[card.rank] >= 14):   # A, 2
            count += 1
    return count

def get_big_small_card_ratio(hand):
    small = 0
    big = 0
    for card in hand:
        if (Card.ranks[card.rank] <= 10):
            small += 1
        else:
            big += 1
    if (small == 0):
        return big
    return big / small

'''
c3 = Card('C', '3')
c4 = Card('C', '4')
c5 = Card('C', '5')
c6 = Card('C', '6')
c7 = Card('C', '7')
c8 = Card('C', '8')
c9 = Card('C', '9')
c10 = Card('C', '10')
d3 = Card('D', '3')
d4 = Card('D', '4')
d5 = Card('D', '5')
d6 = Card('D', '6')
d7 = Card('D', '7')
d8 = Card('D', '8')
d9 = Card('D', '9')
d10 = Card('D', '10')
s3 = Card('S', '3')
s4 = Card('S', '4')
s5 = Card('S', '5')
s6 = Card('S', '6')
s7 = Card('S', '7')
s8 = Card('S', '8')
s9 = Card('S', '9')
s10 = Card('S', '10')
h3 = Card('H', '3')
h4 = Card('H', '4')
h5 = Card('H', '5')
h6 = Card('H', '6')
h7 = Card('H', '7')
h8 = Card('H', '8')
h9 = Card('H', '9')
h10 = Card('H', '10')

deck1 = [c6, d6, s6, s4, d4]
deck2 = [s9]
deck3 = [c3, d3]
deck4 = [c9, s9]
decke = []
hand = [c3, c4, c5, c6, c7, c8, c9]

v = get_combination_count(hand)

print(v)
'''