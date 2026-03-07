def allPermutations(xs):
    if len(xs) < 2: return [xs]
    return [ [x] + p for x in xs for p in allPermutations([ v for v in xs if v != x ]) ]

def lastYearRanking(currentRanking, better, worse):
    n_teams = len(currentRanking)
    # Save ranking of each team in dictionary
    current = {}
    for i in range(1, n_teams+1):
        current[i] = currentRanking.index(i)
    last = {}
    taken = []
    # Compute dictionary of possible rankings (list) for each team
    for i in range(1, n_teams+1):
        if i in better:
            last[i] = [j for j in range(current[i]+1, n_teams)]
        elif i in worse:
            last[i] = [j for j in range(0, current[i])]
        else:
            last[i] = [current[i]]
        if len(last[i]) == 1:
            taken.append(last[i][0])
    progress = True
    while progress and len(taken) < n_teams:
        progress = False
        for i in range(1, n_teams+1):
            # For each undecided team...
            if len(last[i]) > 1:
                for j in last[i]:
                    if j in taken:
                        # ...remove rankings are already taken
                        last[i].remove(j)
                        progress = True
                        # if only one option left, set that
                        if len(last[i]) == 1:
                            taken.append(last[i][0])
    if len(taken) == n_teams:
        xs = [ (last[i][0], i) for i in range(1, n_teams+1) ]
        xs = sorted(xs)
        return [ v for (i, v) in xs ]
    return [0]

def genTable(lastRanking):
    table = {}

    print("Creating table...")

    for currentRanking in allPermutations(lastRanking):
        better = set()
        worse = set()
        for i in lastRanking:
            last_index = lastRanking.index(i)
            current_index = currentRanking.index(i)
            if current_index > last_index:
                worse.add(i)
            if current_index < last_index:
                better.add(i)
        if str(better) in table:
            if str(worse) in table[str(better)]:
                table[str(better)][str(worse)][2].append(currentRanking)
            else:
                table[str(better)][str(worse)] = (better, worse, [currentRanking])
        else:
            table[str(better)] = {
                str(worse): (better, worse, [currentRanking])
            }

    print("Table created!")

    x_n = 0
    x = None
    for better in table:
        for worse in table[better]:
            b, w, ps = table[better][worse]
            if len(ps) > x_n:
                x = (b, w)
                x_n = len(ps)

    print(x)

            # for currentRanking in ps:
            #     sol = lastYearRanking(len(currentRanking), currentRanking, list(b), list(w))
            #     if sol is not None and len(ps) == 1:
            #         pass
            #     elif sol is None and len(ps) > 1:
            #         pass
            #     else:
            #         print("------------------------------------------------")
            #         print("Found counter example!")
            #         print(b, w, " => ", ps)
            #         print(sol)
            #         return

