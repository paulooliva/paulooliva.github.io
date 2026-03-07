#
# Complete the 'quickestGoal' function below.
#
# The function is expected to return an INTEGER.
# The function accepts 2D_INTEGER_ARRAY players as parameter.
#

from math import sqrt

k = 4

def dist(x0, y0, x1, y1):
    if abs(x0-x1) < 0.00001: 
        return abs(y0-y1)
    if abs(y0-y1) < 0.00001: 
        return abs(x0-x1)
    b = (x0-x1) ** 2
    c = (y0-y1) ** 2
    return sqrt(b + c)

def d_max(v0):
    return (v0 ** 2)/(2 * k)

def time(v0, d):
    return (v0 - sqrt(v0**2 - 2*k*d)) / k

def dijkstra(graph, start_node, end_node):
    border = {(start_node, 0)}
    not_visited = set()
    for i in range(0, end_node+1):
        if i != start_node:
            not_visited.add(i)
    fastest = 100000000000 # infinity
    while end_node in not_visited:
        next_best_index = None
        next_best_time = None
        for (node, current_cost) in border:
            for next_node in not_visited:
                if graph[node][next_node]:
                    if next_best_index is None or current_cost + graph[node][next_node] < next_best_time:
                        next_best_index = next_node
                        next_best_time = current_cost + graph[node][next_node]
        if next_best_index is None:
            # Failed to reach destination
            return None
        border.add((next_best_index, next_best_time))
   
    return [ (n, c) for (n, c) in border if n == end_node ][0][1]

def quickestGoal(players):
    # Add final destination
    players.append((100,0,0,0))
    n = len(players)
    # Initially graph 
    graph = {}
    for i in range(0, n):
        graph[i] = {}
        for j in range(0, n):
            graph[i][j] = None    
    # Find goalie
    goalie = None
    for i in range(0, n):
        (x0, y0, p0, s0) = players[i]
        if x0 == 0 and y0 == 0:
            goalie = i
            break
    # Build graph considering passes
    for i in range(0, n):
        (x0, y0, p0, s0) = players[i]
        for j in range(0, n):
            if i != j:
                (x1, y1, _, _) = players[j]
                d = dist(x0, y0, x1, y1)
                # Can it pass to this player
                d_m = d_max(p0)
                if d <= d_m:
                    graph[i][j] = time(p0, d)
    # Build extra edges for shooting at goal directly
    (x1, y1) = (100, 0)
    for i in range(0, n-1):
        (x0, y0, p0, s0) = players[i]
        # Distance to final goal
        d = dist(x0, y0, x1, y1)
        # Can it shoot at goal
        d_m = d_max(s0)
        if d <= d_m:
            graph[i][j] = time(s0, d)

    return dijkstra(graph, goalie, n)