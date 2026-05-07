'''
This file contains an implementation of the map loader
Reads a text map and then builds a MazeDict for the existing game
'''

from typing import Dict, Tuple, List
from defs import *


# Legend (extend as needed)
CHAR2STATE = {
    '#': MAZE_CONTENT.WALL,
    '.': MAZE_CONTENT.EMPTY,
    'S': MAZE_CONTENT.START,
    'G': MAZE_CONTENT.GOAL,
    'D': MAZE_CONTENT.DOOR,
    'K': MAZE_CONTENT.KEY,
    'T': MAZE_CONTENT.TRAP,
}
STATE2CHAR = {v: k for k, v in CHAR2STATE.items()}

def load_text_map(path: str) -> List[str]:
    with open(path, "r", encoding="utf-8") as f:
        rows = [line.rstrip("\n") for line in f if line.strip("\n") != ""]
    width = max(len(r) for r in rows) if rows else 0
    return [r.ljust(width, '.') for r in rows]

def build_maze(rows: List[str]) -> np.ndarray:
    '''
    Parse rows into an array and return (maze, start, goal).
    Top-left is (0,0); x increases right, y increases down.
    '''
    maze = np.zeros((len(rows), len(rows[0])))
    start = (0, 0)
    goal = (0, 0)
    for y, row in enumerate(rows):
        for x, ch in enumerate(row):
            state = CHAR2STATE.get(ch, MAZE_CONTENT.EMPTY)
            maze[y][x] = state.value
            if state == MAZE_CONTENT.START:
                start = (x, y)
            elif state == MAZE_CONTENT.GOAL:
                goal = (x, y)
    return maze, start, goal

def load_maze_from_file(path: str) -> np.ndarray:
    # We read the file then build it
    return build_maze(load_text_map(path))