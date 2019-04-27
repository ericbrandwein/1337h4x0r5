#!/usr/bin/python3

from scapy.all import sniff, ARP


def op_to_string(operation):
    return 'who-has' if operation == 1 else 'is-at'


def entropy_callback(paquete):
    try:
        print(
            ','.join([
                'ARP',
                op_to_string(paquete[ARP].op),
                paquete[ARP].psrc,
                paquete[ARP].pdst,
                paquete[ARP].type,
            ])
        )
    except:
        pass


print('method,operation,source,destination')
sniff(prn=entropy_callback, filter="arp")
