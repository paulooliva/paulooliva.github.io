def classify(n):
    # Write your code here
    s = sum([ i for i in range(1, n) if n % i == 0 ])
    if n == s:
        return "ideal"
    elif s < n:
        return "under-ideal"
    else:
        return "over-ideal"
