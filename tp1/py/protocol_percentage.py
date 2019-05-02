import sys
from s1_reader import S1Reader


def protocol_percentage(filename):
    with S1Reader(filename) as reader:
        rows = list(reader)

    percentage_dict = {}
    for row in rows:
        if row.method in percentage_dict:
            percentage_dict[row.method] += 1
        else:
            percentage_dict[row.method] = 1

    total = len(rows)
    for key in percentage_dict:
        percentage_dict[key] *= 100
        percentage_dict[key] /= total

    return percentage_dict


filename = sys.argv[1]
percentages = protocol_percentage(filename)
for key, value in percentages.items():
    print('{}: {}'.format(key, value))
