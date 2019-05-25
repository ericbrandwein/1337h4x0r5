#!/usr/bin/python3

from scapy.all import *
import sys


def is_ICMP_echo_reply (answer):
    return answer.res[0][1].type == 0

def get_ICMP_error_src (answer):
    return answer.res[0][1].src

    
def get_hops(ip_addr):
    hops = []
    
    ttl = 1
    cota = 32
    for times in range(cota):
        ans, unans = sr(IP(dst = ip_addr, ttl = ttl) / ICMP())

        if is_ICMP_echo_reply (ans): break
        else:
            hops.append (get_ICMP_error_src(ans))
            ttl = ttl + 1

    print("----------------------------------------------------------------------------------------")
    return hops

def main(ip_addr):
    hops = get_hops(ip_addr)
    for i, hop in enumerate(hops):
        print("{}\t{}".format(i, hop))


              

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("tenes que darme una direccion de ip")
    else:
        main(sys.argv[1])
