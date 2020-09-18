#!/usr/bin/env python3

import re
import sys
from pathlib import Path

def main(full_changelog, output):
	p = Path(full_changelog)
	with p.open() as f:
		contents = f.read()
		# Find the contents of the first subheading-delineated section:
		match = re.search(r"^## .+?\n+([^#]+)\n+", contents, re.MULTILINE)
		if match:
			with open(output, 'w') as out:
				out.write(match.group(1))
				print("Wrote changelog to", output)
				return
	sys.exit("Couldn't write changelog")

if __name__ == '__main__':
	main(sys.argv[1], sys.argv[2])
