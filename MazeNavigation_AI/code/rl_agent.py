'''
Reinforcement Learning Agent
This file contains the RL agent implementation
'''

# imports
import numpy as np
from defs import *
import os
import jax.numpy as jnp
import time

# constants
POLICY_WEIGHTS_FILEPATH = "policy_weights"  # filepath for policy weights
STATE_WEIGHTS_FILEPATH = "state_weights"    # filepath for state weights
N_POLICY_FEATURES = 182  # number of features for policy function approximation
N_STATE_FEATURES = 12  # number of features for state value function approximation
DELTA_CLIP = 20.0  # clip TD error to this range

# feature toggles
policy_feature_toggle: np.ndarray = np.ones(N_POLICY_FEATURES, dtype=int)[:, None]  # toggle for policy features, 1 = on, 0 = off
state_feature_toggle: np.ndarray = np.ones(N_STATE_FEATURES, dtype=int)[:, None]      # toggle for state features, 1 = on, 0 = off

class RLAgent(Player):
    # constructor
    def __init__(self, gamma: float = 0.9, actor_step_size: float = 0.005, critic_step_size: float = 0.005, tau: float = 1.0) -> None:
        '''
        initializes the RL agent
        :param gamma: discount factor for future rewards
        :param actor_step_size: step size for actor
        :param critic_step_size: step size for critic
        :param tau: temperature parameter for softmax policy. Higher tau = more exploration
        '''
        super().__init__()
        
        # parameters
        self.gamma: float = gamma
        ''' discount factor for future rewards '''
        self.actor_step_size: float = actor_step_size
        ''' step size for actor '''
        self.critic_step_size: float = critic_step_size
        ''' step size for critic '''
        self.tau: float = tau
        ''' temperature parameter for softmax policy '''

        # variables
        self.policy_features: np.ndarray = np.zeros((N_POLICY_FEATURES, 1), dtype=np.float64)
        ''' policy features at current step '''
        self.state_features: np.ndarray = np.zeros((N_STATE_FEATURES, 1), dtype=np.float64)
        ''' state features at current step '''
        self.w: np.ndarray = np.ndarray([])
        ''' State value weights '''
        self.theta: np.ndarray = np.ndarray([])
        ''' Policy weights '''
        self.action: int = 0
        ''' action taken at current step '''
        self.last_action: int = 4
        ''' action taken at previous step '''
        
    
    # functions    ===========================================
    
    def takeAction(self, state_info: StateInfo) -> CONTROLS:
        '''
        chooses an action to play with policy
        :param state_info: state information at the current step
        :return: chosen action
        '''
        self.last_action = self.action
        # extract features
        self.policy_features = self.extractPolicyFeatures(state_info)
        self.state_features = self.extractStateFeatures(state_info)
        # get weights
        self.theta = self.readWeightsFromFile(POLICY_WEIGHTS_FILEPATH, (N_POLICY_FEATURES, N_ACTION))
        
        # select action using softmax policy
        self.action = self.softmaxPolicy(self.policy_features, self.theta)
        return list(CONTROL_ACTIONS)[self.action]
    
    
    def getRewards(self, reward: int, next_state_info: StateInfo) -> None:
        '''
        receives reward and the info for the next step (after taking action)
        :param reward: reward received after taking action
        :param next_state_info: state information at the next step
        '''
        self.w = self.readWeightsFromFile(STATE_WEIGHTS_FILEPATH, (N_STATE_FEATURES, 1))
        next_state_features = self.extractStateFeatures(next_state_info)
        # calculate TD error
        delta = np.clip(reward + self.gamma * float(self.w.T @ next_state_features) - float(self.w.T @ self.state_features), -DELTA_CLIP, DELTA_CLIP)
        # learn from the experience
        self.learn(delta)
        return
    
    
    def gameOver(self, reward: int) -> None:
        '''
        receives game over signal and final reward
        :param reward: final reward received
        '''
        self.w = self.readWeightsFromFile(STATE_WEIGHTS_FILEPATH, (N_STATE_FEATURES, 1))
        # calculate TD error
        delta = np.clip(reward - float(self.w.T @ self.state_features), -DELTA_CLIP, DELTA_CLIP)
        # learn from the experience
        self.learn(delta)
        return
    
    
    # feature extraction functions =======================================
    
    def old_extractPolicyFeatures(self, state_info: StateInfo) -> np.ndarray:
        '''
        extracts features for policy function approximation from the state info
        :param state_info: state information at the current step
        :return: a column vector of extracted features
        '''
        
        ##initialize np array
        features: np.ndarray = np.zeros(N_POLICY_FEATURES)[:, None] 

        idx = 0
        
        # bias term
        features[idx] = 1.0
        idx += 1
        
        # cell contents for each cell
        for row in state_info.view:
            for cell in row:
                # wall
                if (cell==MAZE_CONTENT.WALL.value):
                    features[idx] = 1
                idx += 1
                # key
                if (cell==MAZE_CONTENT.KEY.value):
                    features[idx] = 1
                idx += 1
                # door
                if (cell==MAZE_CONTENT.DOOR.value):
                    features[idx] = 1
                idx += 1
                # goal
                if (cell==MAZE_CONTENT.GOAL.value):
                    features[idx] = 1
                idx += 1
                # trap
                if (cell==MAZE_CONTENT.TRAP.value):
                    features[idx] = 1
                idx += 1
                if (cell==MAZE_CONTENT.EMPTY.value or cell==MAZE_CONTENT.START.value):
                    features[idx] = 1
                idx += 1
        
        # key count
        features[idx] = state_info.keys
        idx += 1
        
        # steps taken (normalized)
        features[idx] = state_info.steps_taken / MAX_STEPS
        idx += 1
        
        # visited cells in view
        for row, col in np.ndindex(state_info.visited_view.shape):
            if state_info.visited_view[row][col]:
                features[idx] = state_info.visited_view[row][col]
            idx += 1
        
        # last action one-hot encoding
        for action in range(N_ACTION):
            if self.last_action == action:
                features[idx] = 1
            idx += 1
        
        # sanity check on feature count
        assert idx == N_POLICY_FEATURES, f"Expected {N_POLICY_FEATURES} features, got {idx}"

        return features * policy_feature_toggle
    
    
    def extractPolicyFeatures(self, state_info: StateInfo) -> np.ndarray:
        '''
        extracts features for policy function approximation from the state info
        :param state_info: state information at the current step
        :return: a column vector of extracted features
        '''
        
        ##initialize np array
        features: np.ndarray = np.zeros(N_POLICY_FEATURES)[:, None] 

        idx = 0
        
        # bias term
        features[idx] = 1.0
        idx += 1
        
        # cell contents for each cell
        for row in state_info.view:
            for cell in row:
                # wall
                if (cell==MAZE_CONTENT.WALL.value):
                    features[idx] = 1
                idx += 1
                # key
                if (cell==MAZE_CONTENT.KEY.value):
                    features[idx] = 1
                idx += 1
                # door
                if (cell==MAZE_CONTENT.DOOR.value):
                    features[idx] = 1
                idx += 1
                # goal
                if (cell==MAZE_CONTENT.GOAL.value):
                    features[idx] = 1
                idx += 1
                # trap
                if (cell==MAZE_CONTENT.TRAP.value):
                    features[idx] = 1
                idx += 1
                if (cell==MAZE_CONTENT.EMPTY.value or cell==MAZE_CONTENT.START.value):
                    features[idx] = 1
                idx += 1
        
        # key count
        features[idx] = state_info.keys
        idx += 1
        
        # steps taken (normalized)
        features[idx] = state_info.steps_taken / MAX_STEPS
        idx += 1
        
        # visited cells in view
        for row, col in np.ndindex(state_info.visited_view.shape):
            if state_info.visited_view[row][col]:
                cell = state_info.view[row][col]
                if cell not in (MAZE_CONTENT.WALL.value, MAZE_CONTENT.TRAP.value):
                    features[idx] = state_info.visited_view[row][col]
            idx += 1
        
        # last action one-hot encoding
        for action in range(N_ACTION):
            if self.last_action == action:
                features[idx] = 1
            idx += 1
        
        # sanity check on feature count
        assert idx == N_POLICY_FEATURES, f"Expected {N_POLICY_FEATURES} features, got {idx}"

        return features * policy_feature_toggle
    
    
    def extractStateFeatures(self, state_info: StateInfo) -> np.ndarray:
        '''
        extracts features for state value function approximation from the state info
        :param state_info: state information at the current step
        :return: a column vector of extracted features
        '''  
        #column vector of features for V(s)                        
        features: np.ndarray = np.zeros(N_STATE_FEATURES, dtype=np.float64)[:, None]  

        idx = 0  #current feature index                            

        view = state_info.view                                      
        steps_taken = state_info.steps_taken                        
        keys = state_info.keys
        visited_view = state_info.visited_view                                  

        # Bias term                                              
        features[idx] = 1.0
        idx += 1
        
        # # cell contents for each cell
        # for row in state_info.view:
        #     for cell in row:
        #         # wall
        #         if (cell==MAZE_CONTENT.WALL.value):
        #             features[idx] = 1
        #         idx += 1
        #         # key
        #         if (cell==MAZE_CONTENT.KEY.value):
        #             features[idx] = 1
        #         idx += 1
        #         # door
        #         if (cell==MAZE_CONTENT.DOOR.value):
        #             features[idx] = 1
        #         idx += 1
        #         # goal
        #         if (cell==MAZE_CONTENT.GOAL.value):
        #             features[idx] = 1
        #         idx += 1
        #         # trap
        #         if (cell==MAZE_CONTENT.TRAP.value):
        #             features[idx] = 1
        #         idx += 1
        #         if (cell==MAZE_CONTENT.EMPTY.value or cell==MAZE_CONTENT.START.value):
        #             features[idx] = 1
        #         idx += 1
                    
        # Normalized steps taken           
        features[idx] = steps_taken / MAX_STEPS
        idx += 1
        
        # Number of keys held
        features[idx] = keys
        idx += 1

        # number of keys visible
        features[idx] = np.sum(view == MAZE_CONTENT.KEY.value)
        idx += 1
        
        # number of doors visible
        doors_visible = np.sum(view == MAZE_CONTENT.DOOR.value)
        features[idx] = doors_visible
        idx += 1
        
        # ratio of doors that can be opened
        features[idx] = min(doors_visible, keys) / (doors_visible + 1e-5)  # avoid division by zero
        idx += 1
        
        # if goal is visible
        features[idx] = 1.0 if np.any(view == MAZE_CONTENT.GOAL.value) else 0.0
        idx += 1

        #Fraction of wall tiles in view                    
        total_tiles = float(VISION_SIZE * VISION_SIZE)
        wall_count = np.sum(view == MAZE_CONTENT.WALL.value)
        features[idx] = wall_count / total_tiles
        idx += 1

        # number of visible traps
        features[idx] = np.sum(view == MAZE_CONTENT.TRAP.value)
        idx += 1

        center = np.array([VISION_SIZE // 2, VISION_SIZE // 2], dtype=int)
        max_dist = float((VISION_SIZE - 1) * 2)   

        def normalized_min_manhattan(target_value: int) -> float:   
            positions = np.argwhere(view == target_value)
            if positions.size == 0:
                return 1.0
            dists = np.abs(positions - center).sum(axis=1)
            return float(np.min(dists)) / max_dist
         
        features[idx] = normalized_min_manhattan(MAZE_CONTENT.KEY.value)
        idx += 1
          
        features[idx] = normalized_min_manhattan(MAZE_CONTENT.GOAL.value)
        idx += 1
        
        # sum of visited rates in view
        features[idx] = np.sum(visited_view)
        idx += 1

        #Running sanity check on feature count                                             
        assert idx == N_STATE_FEATURES, f"Expected {N_STATE_FEATURES} features, got {idx}"  

        return features * state_feature_toggle
    
    
    # policy functions ===========================================
    
    def softmaxPolicy(self, x: np.ndarray, Theta: np.ndarray) -> int:
        '''
        selects an action using softmax policy
        :param x: feature vector, d x 1
        :param Theta: weight matrix, d x |A|
        :return: chosen action index
        '''
        prob = np.array(self.softmaxProb(x, Theta)).flatten()  # |A| x 1
        # print(prob)
        return int(np.random.choice(len(prob), p=prob))
    
    
    def softmaxProb(self, x: np.ndarray, theta: np.ndarray) -> jnp.ndarray:
        '''
        calculates the softmax probabilities for each action
        uses jax for automatic differentiation
        :param x: feature vector, d x 1
        :param theta: weight matrix, d x |A|
        :return: jnp probability vector, |A| x 1
        '''
        h = jnp.dot(theta.T, x) / self.tau  # |A| x 1
        exp_h = jnp.exp(h - jnp.max(h))
        return exp_h / jnp.sum(exp_h)                                       

    
    def logSoftmaxPolicyGradient(self, x: np.ndarray, a: int, Theta: np.ndarray) -> np.ndarray:
        '''
        calculates the gradient of the log softmax policy
        :param x: feature vector, d x 1
        :param a: action taken
        :param Theta: weight matrix, d x |A|
        :return: gradient, d x |A|
        '''
        prob = np.array(self.softmaxProb(x, Theta))  # |A| x 1
        grad = -np.outer(x, prob)  # d x |A|
        grad[:, a] += x
        return grad
    
    
    def learn(self, delta):
        '''
        updates actor and critic weights
        :param delta: TD error ( reward + gamma * V(s', w) - V(s, w) )
        '''
        self.w += self.critic_step_size * delta * self.state_features
        self.theta += self.actor_step_size * delta * self.logSoftmaxPolicyGradient(self.policy_features.flatten(), self.action, self.theta)
        self.writeWeightsToFile(STATE_WEIGHTS_FILEPATH, self.w)
        self.writeWeightsToFile(POLICY_WEIGHTS_FILEPATH, self.theta)
    
    # weight file functions =======================================
    
    def readWeightsFromFile(self, filename: str, dim: tuple[int, int]) -> np.ndarray:
        '''
        Reads weights from a csv file.
        Only reads up to N_POLICY_FEATURES weights, pads with ones if less, truncates if more
        :param filename: path to the csv file without extension
        :param dim: dimensions of the weights array to return, x is number of features, y is number of columns
        :return: weights as a numpy array
        '''
        base = os.path.dirname(__file__)
        path = os.path.join(base, "weights", filename + ".csv")
        
        weights: np.ndarray
        feature_n, column_n = dim
        try:
            weights = np.genfromtxt(path, delimiter=",", dtype=np.float64, filling_values = 1)
            # make sure weights is 2D
            if weights.ndim == 1:
                weights = weights[:, None]
            # clip or pad rows
            if weights.shape[0] > feature_n:
                weights = weights[:feature_n]
            else:
                pad_length = feature_n - len(weights)
                pad_width = weights.shape[1] if len(weights.shape) > 1 else 1
                weights = np.vstack((weights, np.random.rand(pad_length, pad_width)))
            # clip or pad columns
            if weights.shape[1] > column_n:
                weights = weights[:, :column_n]
            else:
                pad_length = weights.shape[0] if len(weights.shape) > 1 else 1
                pad_width = column_n - weights.shape[1]
                weights = np.hstack((weights, np.random.rand(pad_length, pad_width)))

        except OSError:
            # file not found, initialize weights to ones
            weights = np.random.rand(feature_n, column_n)
        
        return weights
    
    
    def writeWeightsToFile(self, filename: str, weights: np.ndarray) -> None:
        '''
        writes weights to a csv file
        :param weights: weights to write
        :param filename: path to the csv file without extension
        '''
        base = os.path.dirname(__file__)
        path = os.path.join(base, "weights", filename + ".csv")
        temp_path = os.path.join(base, "weights", filename + "_temp.csv")
        
        # write to temp file first
        np.savetxt(temp_path, weights, delimiter=",", fmt="%f")
        
        # replace original file
        max_retries = 5
        for attempt in range(max_retries):
            try:
                os.replace(temp_path, path)
                return
            except PermissionError as e:
                if attempt >= max_retries - 1:
                    # failed after retries
                    try:
                        os.remove(temp_path)
                    except OSError:
                        pass
                    return
                # wait and retry
                time.sleep(0.05)