import sys
import csv

DEST_TYPE_ROW_NAME = 'dest_type'
BROADCAST_STRING = 'bcast'


def broadcast_percentage(filename):
    amount = 0
    total = 0
    with open(filename, newline='') as csvfile:
        csvreader = csv.DictReader(csvfile)
        for row in csvreader:
            total += 1
            if row[DEST_TYPE_ROW_NAME] == BROADCAST_STRING:
                amount += 1

    print("Broadcast amount:", amount)
    print("Total rows:", total)
    return amount * 100 / total


filename = sys.argv[1]
print("Broadcast percentage:", broadcast_percentage(filename))
