import sys
import random

rows = []
filename = sys.argv[1]

with open(filename) as archivo:
    rows = list(archivo)


new_rows = list(rows)
for i in range(len(rows), 12278):
    next_row = random.randrange(0, len(rows), 1)
    new_rows.append(rows[next_row])

with open(filename + '.bak', 'w') as archivo:
    archivo.writelines(new_rows)
