#
# Complete the 'knightAndPawn' function below.
#
# The function is expected to return a STRING.
# The function accepts following parameters:
#  1. STRING knight
#  2. STRING pawn
#

def to_coord(position):
    x = ord(position[0]) - ord('a')
    y = ord(position[1]) - ord('1') 
    return (int(x), int(y))

def last_rank(position):
    return position[1] == 7

def valid(position):
    return position[0] >= 0 and position[0] <= 7 and position[1] >= 0 and position[1] <= 7

def move(position, i, j):
    return (position[0]+i, position[1]+j)

def jumps(knight):
    return [
        move(knight, 2, 1),
        move(knight, 2, -1),
        move(knight, 1, 2),
        move(knight, 1, -2),
        move(knight, -2, 1),
        move(knight, -2, -1),
        move(knight, -1, 2),
        move(knight, -1, -2),
    ]

def process(ks, pawn):
    next_pawn = move(pawn, 0, 1)
    if next_pawn in ks:
        return "Knight can block pawn before promotion (stalemate)"
    next_ks = set([ next_pos for pos in ks for next_pos in jumps(pos) if valid(next_pos) ])
    if next_pawn in next_ks:
        if last_rank(next_pawn):
            return "Knight can capture pawn immediately after promotion"
        return "Knight can capture pawn before promotion"
    if last_rank(pawn):
        return "Pawn can promote without being captured"
    return process(next_ks, next_pawn)
    
def knightAndPawn(knight, pawn):
    # Write your code here
    return process([to_coord(knight)], to_coord(pawn))
