import collections
import json
import sys

corpus = sys.argv[1]
network = sys.argv[2]
order = int(sys.argv[3])
counts = collections.defaultdict(lambda: collections.defaultdict(lambda: 0))
with open(corpus) as f:
	for line in f:
		bchars = [""]*order
		
		line = line[:-1]
		for c in line:
			counts["".join(bchars)][c] += 1
			bchars[:-1] = bchars[1:]
			bchars[-1] = c
		counts["".join(bchars)][""] += 1
probs = {k1: {k2: v2/sum(v1.values()) for k2,v2 in v1.items()} for k1, v1 in counts.items()}
with open(network,'w') as o:
	o.write(json.dumps(probs))

