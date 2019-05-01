import csv


class S1DataRow:
    def __init__(self, row):
        self.method = row['method']
        self.dest_type = row['dest_type']

    def is_broadcast(self):
        return self.dest_type == 'bcast'

    def is_unicast(self):
        return self.dest_type == 'unicast'


class S1Reader:
    def __init__(self, filename):
        self.filename = filename

    def __enter__(self):
        self.csvfile = open(self.filename, newline='')
        self.csvreader = csv.DictReader(self.csvfile)
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.csvfile.close()

    def __iter__(self):
        return self

    def __next__(self):
        return S1DataRow(next(self.csvreader))
