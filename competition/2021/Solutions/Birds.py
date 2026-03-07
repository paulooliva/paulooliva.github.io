
def birdCount(birds):
    # The function is expected to return an INTEGER.
    # The function accepts STRING birds as parameter.
    count = 0
    for i in range(0, len(birds)):
        if birds[i] == '<':
            for j in range(0, i):
                if birds[j] == '>':
                    count += 1
        else:
            for j in range(i+1, len(birds)):
                if birds[j] == '<':
                    count += 1
    return count

birds = input()

result = birdCount(birds)

print(result)