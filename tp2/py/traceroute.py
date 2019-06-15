#!/usr/bin/python3

from scapy.all import *
import sys
import os
import time
import csv

def is_ICMP_echo_reply (answer):
    return len(answer.res) > 0 and answer.res[0][1].type == 0

def get_IP_src (answer):
    return 'NA' if len(answer.res) == 0 else answer.res[0][1].src

    
def write_hops(ip_addr, csv_writer):
    hops = []
    cota = 32
    for ttl in range(1, cota):
        for packets_sent in range(32):
            start = time.time()

            ans, unans = sr(IP(dst = ip_addr, ttl = ttl) / ICMP(), timeout=1)
            
            end = time.time()

            if unans:
                elapsed_time = 'NA'
            else:
                elapsed_time = end - start

            csv_writer.writerow([get_IP_src(ans), elapsed_time, ttl])


    print("----------------------------------------------------------------------------------------")
    return hops

def main(ip_addr, csv_file):
    exists = os.path.isfile(csv_file)

    if exists:
        print("El archivo ya existe")
    else:
        bufsize = 1
        with open(csv_file, 'w', bufsize) as archivo:
            writer = csv.writer(archivo)
            writer.writerow(['dst', 'rtt', 'ttl'])
            write_hops(ip_addr, writer)
            

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("tenes que darme una direccion de ip y un archivo csv")
    else:
        main(sys.argv[1], sys.argv[2])
