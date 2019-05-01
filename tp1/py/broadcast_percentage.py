import sys
from s1_reader import S1Reader


def broadcast_percentage(filename):
    total = 0
    amount = 0
    with S1Reader(filename) as reader:
        for row in reader:
            total += 1
            if row.is_broadcast():
                amount += 1

    print("Broadcast amount:", amount)
    print("Total rows:", total)
    return amount * 100 / total


filename = sys.argv[1]
print("Broadcast percentage:", broadcast_percentage(filename))
