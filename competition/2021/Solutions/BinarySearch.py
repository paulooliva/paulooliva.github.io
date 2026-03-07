"""
class BSTreeNode:
    def __init__(self, node_value):
        self.value = node_value
        self.left = self.right = None
"""

def isPresent (root,val):
    # write your code here
    # return 1 or 0 depending on whether the element is present in the tree or not
    if (val == root.value): return 1
    elif (val < root.value):
        if (root.left == None): return 0
        return isPresent(root.left, val)
    else:
        if (root.right == None): return 0
        return isPresent(root.right, val)   
