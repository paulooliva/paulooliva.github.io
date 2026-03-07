#
# Complete the 'smallestString' function below.
#
# The function is expected to return a STRING.
# The function accepts STRING_ARRAY substrings as parameter.
#

def smallestDNA(substrings):
    # Write your code here
    from functools import cmp_to_key
    def f(x,y):
        if x+y>y+x:
            return 1
        elif x+y==y+x:
            return 0
        return -1
    return "".join(sorted(substrings, key=cmp_to_key(f)))

fragments_count = int(input().strip())

fragments = []

for _ in range(fragments_count):
    fragments_item = input()
    fragments.append(fragments_item)

result = smallestDNA(fragments)

print(result)
