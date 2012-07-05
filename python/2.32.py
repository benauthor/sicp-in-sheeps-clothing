from itertools import *

def subsets(s):
    combos = [combinations(s,r) for r in range(len(s)+1)]
    return list(chain.from_iterable(combos))

alist = [1,2,3]
print(subsets(alist))
