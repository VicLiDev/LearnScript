#!/usr/bin/python

import sys
import copy

print("Message from sys.stdin:")
print()

# sys.stdin.readline()
# sys.stdin.read(cnt)
# sys.stdin.read()
for line in sys.stdin:
    # if 'Exit' == line.rstrip():
    #     break
    print("\r%s" % (line.strip()), flush=True, end="")
print("Done")
