import random
import numpy as np
import csv
from card import *

weights_filepath = "./weights.csv"
num_features = 20
weights_switch = np.ones(num_features)
#weights_switch[0] = 0
#weights_switch[1] = 0
#weights_switch[2] = 0
#weights_switch[3] = 0
#weights_switch[4] = 0
#weights_switch[5] = 0
#weights_switch[6] = 0
#weights_switch[7] = 0
#weights_switch[8] = 0

weights_switch[9] = 0
weights_switch[10] = 0
weights_switch[16] = 0
weights_switch[17] = 0

weights_switch[11] = 0
weights_switch[12] = 0
weights_switch[13] = 0
weights_switch[14] = 0
weights_switch[15] = 0
weights_switch[18] = 0
weights_switch[19] = 0

learning = False

class QLearningAi:
    def __init__(self, player_id, learning_rate = 0.05, discount_factor = 0.95, exploration_rate = 0.5, exploration_decay=0.995):
        self.player_id = player_id
        self.learning_rate = np.full(num_features, learning_rate)  # Per-feature learning rates
        self.discount_factor = discount_factor  # Discount factor
        self.exploration_rate = exploration_rate  # Exploration rate
        self.exploration_decay = exploration_decay
        self.weights = self.load_weights()  # Load weights from file or initialize to zeros
        self.last_state = None
        self.last_action = None
        self.last_features = None
        self.last_reward = -float('inf')

    def load_weights(self):
        # loads weights from csv file
        try:
            with open(weights_filepath, mode='r') as file:
                reader = csv.reader(file)
                weights = np.ones(num_features)
                count = 0
                for item in reader:
                    weights[count] = float(item[0])
                    count += 1
                    if count >= num_features:
                        break
                
                
                return weights
        except (FileNotFoundError, ValueError):
            return np.ones(num_features)


    def save_weights(self):
            
        # saves weights to csv file
        with open(weights_filepath, mode='w', newline='') as file:
            writer = csv.writer(file)
            for weight in self.weights:
                writer.writerow([weight])

    def get_features(self, hand, last_played_cards, opponent_hand_count, action):
        # generates a feature vector for a given state-action pair.
        features = np.zeros(num_features)
        
        hand.sort()

        # basis functions
        features[0] = len(hand) # number of cards in hand
        features[1] = len(action)   # number of cards in the action
        avg_opponent_cards = sum(opponent_hand_count) / len(opponent_hand_count)
        features[2] = len(hand) - avg_opponent_cards    # difference in hand size
        if (isValidPlay(action, last_played_cards)):    # validity of action
            features[3] = 1
        else:
            features[3] = 0
        features[4] = len(action)   # action size
        if (len(hand) == 0):
            features[5] = 0 # rank of the first card in hand
            features[6] = 0 # rank of the last card in hand
        else:
            features[5] = Card.ranks[hand[0].rank]     # rank of the first card in hand
            features[6] = Card.ranks[hand[-1].rank]    # rank of the last card in hand
        features[7] = min(opponent_hand_count)  # length of the shortest opponent hand
        features[8] = max(opponent_hand_count)  # length of the longest opponent hand
        
        
        new_hand = hand.copy()
        '''
        for card in action:
            new_hand.remove(card)
        old_combination_count = get_combination_count(hand)
        new_combination_count = get_combination_count(new_hand)
            
        features[9] = old_combination_count[1] - new_combination_count[1]  # number of pairs after action
        features[10] = old_combination_count[2] - new_combination_count[2]  # number of triples after action
        features[11] = old_combination_count[3] - new_combination_count[3]  # number of straights after action
        features[12] = old_combination_count[4] - new_combination_count[4]  # number of flushes after action
        features[13] = old_combination_count[5] - new_combination_count[5]  # number of full houses after action
        features[14] = old_combination_count[6] - new_combination_count[6]  # number of four of a kind after action
        features[15] = old_combination_count[7] - new_combination_count[7]  # number of royal flushes after action
        
        features[16] = get_big_cards_count(new_hand)    # number of big cards in hand after action
        
        features[17] = get_big_small_card_ratio(hand)   # ratio of small to big cards in hand before action
        '''
        features[18] = get_big_small_card_ratio(new_hand)    # ratio of small to big cards in hand after action
        '''
        valid_action = get_valid_actions(hand, last_played_cards)
        features[19] = (len(valid_action) / (valid_action.index(action) + 1)) if action in valid_action else 0  # ratio of valid actions to the index of the action, smaller index is better
        '''
        
        # switch off features
        features = features * weights_switch
        
        # normalize features
        features = features / (np.linalg.norm(features) + 1e-8)

        return features

    def q_value(self, features):
        # computes Q value using weights and features
        return np.dot(self.weights, features)

    def choose_action(self, state, valid_actions):
        if (learning):
            # chooses an action using an epsilon-greedy policy
            if random.uniform(0, 1) < self.exploration_rate:
                self.update_exploration_rate()
                return random.choice(valid_actions)  # Exploration
            else:
                player_hand, last_played_cards, opponent_card_counts = state
                best_action = None
                best_q_value = -float('inf')
                for action in valid_actions:
                    features = self.get_features(player_hand, last_played_cards, opponent_card_counts, action)
                    q_value = self.q_value(features)
                    if q_value > best_q_value:
                        best_q_value = q_value
                        best_action = action
                self.update_exploration_rate()
                return best_action
        else:
            player_hand, last_played_cards, opponent_card_counts = state
            best_action = None
            best_q_value = -float('inf')
            for action in valid_actions:
                features = self.get_features(player_hand, last_played_cards, opponent_card_counts, action)
                q_value = self.q_value(features)
                if q_value > best_q_value:
                    best_q_value = q_value
                    best_action = action
            return best_action

    def update_weights(self, reward, new_state, valid_actions):            
        if self.last_features is not None:
            current_q = self.q_value(self.last_features)
            future_q = []
            new_player_hand, new_last_played_cards, new_opponent_card_counts = new_state
            for action in valid_actions:
                future_q.append(self.q_value(self.get_features(new_player_hand, new_last_played_cards, new_opponent_card_counts, action)))
            max_future_q = max(future_q, default=0)
            td_error = reward + self.discount_factor * max_future_q - current_q

            # feature importance (normalize absolute feature values)
            feature_importance = np.abs(self.last_features) / np.sum(np.abs(self.last_features)) if np.sum(np.abs(self.last_features)) > 0 else np.ones(len(self.last_features))

            # Update each weight independently
            for i in range(len(self.weights)):
                if weights_switch[i] == 0:
                    continue
                # feature-specific TD error
                feature_td_error = td_error * self.last_features[i] * feature_importance[i]

                # nonlinear transformation to the gradient
                nonlinear_gradient = np.tanh(feature_td_error)

                # regularization (L2 penalty)
                regularization_term = -0.01 * self.weights[i]  # Regularization factor

                # update weight
                self.weights[i] += self.learning_rate[i] * (nonlinear_gradient + regularization_term)

            # Save updated weights
            #self.weights = np.clip(self.weights, -1e3, 1e3)  # clamp weights to prevent explosion
            self.save_weights()
            
    def update_exploration_rate(self):
        self.exploration_rate *= self.exploration_decay
            
    def get_reward(self, current_state, last_state):
        reward = 0
        current_player_hand, current_last_played_cards, current_opponent_card_counts = current_state
        last_player_hand, last_last_played_cards, last_opponent_card_counts = last_state
        # won
        if len(current_player_hand) == 0:
            reward += 5000
        # self hand size reward
        if len(current_player_hand) == len(last_player_hand):   # passed
            reward -= 10
        else:   # played cards
            hand_diff = len(current_player_hand) - len(last_player_hand)
            reward += 2 ** (hand_diff - 1) * 2  # exponential reward for playing more cards
        # opponent hand size reward
        for i in range(len(current_opponent_card_counts)):
            if current_opponent_card_counts[i] == last_opponent_card_counts[i]:     # opponent passed
                reward += 20
            else:   # opponent played cards
                hand_diff = last_opponent_card_counts[i] - current_opponent_card_counts[i]
                reward -= hand_diff
            # opponent close to winning
            if current_opponent_card_counts[i] == 0:
                reward -= 1000
            elif current_opponent_card_counts[i] == 1:
                reward -= 40
            elif current_opponent_card_counts[i] == 2:
                reward -= 20
            elif current_opponent_card_counts[i] == 3:
                reward -= 10
            elif current_opponent_card_counts[i] <= 5:
                reward -= 5
        # Penalize breaking combinations
        old_combinations = get_combination_count(last_player_hand)
        new_combinations = get_combination_count(current_player_hand)
        for combo_type in range(1, 8):  # 1 to 7 represent combinations
            if new_combinations[combo_type] < old_combinations[combo_type]:
                reward -= (old_combinations[combo_type] - new_combinations[combo_type]) * 15
        return reward
            

    def playCards(self, player_hand, last_played_cards, p1_count, p2_count, p3_count):
        # chooses an action and returns the action
        self.weights = self.load_weights()
        opponent_card_counts = [p1_count, p2_count, p3_count]
        state = (player_hand, last_played_cards, opponent_card_counts)
        if (learning):
            self.learn(player_hand, last_played_cards, p1_count, p2_count, p3_count)
        valid_actions = get_valid_actions(player_hand, last_played_cards)
        action = self.choose_action(state, valid_actions)
        self.last_state = state
        self.last_features = self.get_features(player_hand, last_played_cards, opponent_card_counts, action)
        return action

    def learn(self, player_hand, last_played_cards, p1_count, p2_count, p3_count):
        if self.last_state is not None:
            reward = self.get_reward((player_hand, last_played_cards, [p1_count, p2_count, p3_count]), self.last_state)
            if (reward > self.last_reward):
                opponent_card_counts = [p1_count, p2_count, p3_count]
                new_state = (player_hand, last_played_cards, opponent_card_counts)
                new_valid_actions = get_valid_actions(player_hand, last_played_cards)
                self.update_weights(reward, new_state, new_valid_actions)
            self.last_reward = reward
    
    def game_end(self, player_hand, last_played_cards, p1_count, p2_count, p3_count):
        # learns from the final state
        if (learning):
            self.learn(player_hand, last_played_cards, p1_count, p2_count, p3_count)

def readCsv(filepath):
  state_actions = []
  with open(filepath, newline='') as file:
    reader = csv.reader(file)
    # each row
    for row in reader:
      print(row)
  return state_actions