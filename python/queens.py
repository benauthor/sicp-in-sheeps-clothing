# SICP exercise 2.43 -- 8 queens

# I did this to indulge my perhaps naive instinct to implement this puzzle in
# a very OO way, modeling queens like actual chess pieces. Actually working
# this out made me realize how much inessential cruft my impulses want me to
# write. It is still basically using their add-a-line-and-check algorithm.

# The code in SICP is much more concise, because this
# puzzle isn't actually about chess. What I realized doing this was that 
# if I wanted to develop a chess game, the OO approach might be appropriate,
# but if I want to solve this puzzle as quickly as possible for boardsize N,
# all the 'real life' modeling detail is just in the way.

# The problem space after n=8 grows very quickly into something ridiculous.
# I wonder if there's a way to solve it faster.

from copy import deepcopy

class Board(object):
    def __init__(self, queens=[]):
        self.queens = queens

    def add_queen_at(self, row, col):
        self.queens.append(Queen(row, col))

    def queen_is_safe_at(self, row, col):
        if self._queens_in_row(row):
            return False
        elif self._queens_in_column(col):
            return False
        elif self._queens_on_diagonal(row, col):
            return False
        else:
            return True

    def _queens_in_row(self, row):
        for queen in self.queens:
            if queen.row == row:
                return True
        return False

    def _queens_in_column(self, col):
        for queen in self.queens:
            if queen.col == col:
                return True
        return False

    def _queens_on_diagonal(self, row, col):
        s = row + col
        d = row - col
        for queen in self.queens:
            if (queen.row + queen.col) == s:
                return True
            if (queen.row - queen.col) == d:
                return True
        return False

    def __str__(self):
        for queen in self.queens:
            print queen
        return "That's the board.\n"


class Queen(object):
    def __init__(self, row, col):
        self.row = row
        self.col = col

    def __str__(self):
        return "Queen in row {0}, col {1}".format(self.row, self.col)


if __name__ == "__main__":
    # Let's come up will all possible boards for board size n

    def generate_plausible_boards_for_new_row(row, board):
        plausible = []
        for col in range(1, boardsize+1):
            if board.queen_is_safe_at(row, col):
                newboard = deepcopy(board)
                newboard.add_queen_at(row, col)
                plausible.append(newboard)
        return plausible

    def generate_plausible_boards_for_all(row, boards):
        plausible = []
        for b in boards:
            s = generate_plausible_boards_for_new_row(row, b)
            plausible.extend(s)
        return plausible

    def generate_plausible_boards_for_size(size):
        b = Board()
        plausible = [b]
        for row in range(1, size+1):
            plausible = generate_plausible_boards_for_all(row, plausible)
        return plausible

    boardsize = 8

    d = generate_plausible_boards_for_size(boardsize)

    for b in d:
        print b

    print len(d)

# By the way, here's a solution from the wikipedia page in 6 LOC
# from itertools import permutations
 
# n = 8
# cols = range(n)
# for vec in permutations(cols):
#     if (n == len(set(vec[i] + i for i in cols))
#           == len(set(vec[i] - i for i in cols))):
#         print vec