#
# Complete the 'countGroups' function below.
#
# The function is expected to return an INTEGER.
# The function accepts STRING_ARRAY related as parameter.
#

def convert(related):
    # convert to matrix of booleans
    n = len(related)
    return [
        [related[i][j] == '1' for j in range(0, n)]
        for i in range(0, n)
    ]

def withoutGroup(groups):
    # find person yet without a group
    for i in range(0, len(groups)):
        if not groups[i]:
            return i
    return None

def propagate(p, n_groups, matrix, groups):
    # propage group number through relationship matrix
    for i in range(0, len(groups)):
        if matrix[p][i] and groups[i] is None:
            groups[i] = n_groups
            propagate(i, n_groups, matrix, groups)
            
def countGroups(related):
    matrix = convert(related)
    n_groups = 0
    groups = [None for i in range(0, len(related))]
    p = withoutGroup(groups)
    while p is not None:
        n_groups += 1
        groups[p] = n_groups
        propagate(p, n_groups, matrix, groups)
        p = withoutGroup(groups)
    return n_groups  