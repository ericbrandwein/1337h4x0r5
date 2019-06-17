#!/usr/bin/python3

from scapy.all import *
import sys
import os
import time
import csv
import argparse


def is_ICMP_echo_reply (answer):
    try:
        return answer.res[0][1].type == 0
    except:
        return False

def get_IP_src (answer):
    try:
        return answer.res[0][1].src
    except:
        return 'NA'

def get_time_received(answer):
    try:
        return answer.res[0][1].time
    except:
        return 0


def final_hop_reached(answer, ip_dest):
    return get_IP_src(answer) == ip_dest

def write_hops(ip_addr, csv_writer, proto, times):
    
    
    hops = []
    cota = 32
    reached_final_hop = False

    for ttl in range(1, cota) and not reached_final_hop:
        for packets_sent in range(times):

            sent_package = IP(dst = ip_addr, ttl = ttl) / proto()

            start = time.time()
            ans, unans = sr(sent_package, timeout=1)
            end = time.time()

            if unans:
                elapsed_time = 'NA'
            else:
                elapsed_time = end - start

            csv_writer.writerow([get_IP_src(ans), elapsed_time, ttl])

            reached_final_hop = final_hop_reached(ans, ip_addr)

    print("----------------------------------------------------------------------------------------")
    return hops

def main(ip_addr, csv_file, proto, times):

    exists = os.path.isfile(csv_file)
    if exists:
        print("El archivo ya existe")
    else:
        bufsize = 1
        with open(csv_file, 'w', bufsize) as archivo:
            writer = csv.writer(archivo)
            writer.writerow(['dst', 'rtt', 'ttl'])
            write_hops(ip_addr, writer, proto, times)
            
        print("traceroute.py finished")
        print("\t ip: {}".format(ip_addr))
        proto_str = str(proto)[-1]
        print("\t protocolo: {}".format(proto_str.strip("\"'>")))
        print("\t times: {}".format(times))
        print("\t outfile: {}".format(csv_file))

            
if __name__ == "__main__":
    
    parser = argparse.ArgumentParser(description='Traceroute con scapy.')
    parser.add_argument('ip_addr', metavar='IP_ADDR',type=str,
                        help='la direccion ip')

    parser.add_argument('filename', metavar='FILE', type=str, 
                    help='nombre del archivo destino')

    parser.add_argument('-U',
                    dest='proto', action='store_const',
                    const=UDP, default=ICMP,
                    help='usar UDP en vez de ICMP')
    parser.add_argument('-T',
                    dest='proto', action='store_const',
                    const=TCP, 
                    help='usar TCP en vez de ICMP')

    parser.add_argument('-n', nargs='?', type=int, dest='times',
                        default=32, 
                        help='Cantidad de paquetes por Hop')

    args = parser.parse_args()
    main(args.ip_addr, args.filename, args.proto, args.times)

