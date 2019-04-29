#!/bin/python3

from scapy.all import sniff
import pdb

def tipo_de_destino(paquete):
    if paquete.dst == 'ff:ff:ff:ff:ff:ff':  # es broadcast
        return 'bcast'
    else:  # es unicast (o quiza multicast)
        return 'unicast'


def mostrar_paquete(paquete):
    print(
        ','.join([
            paquete.payload.name,
            tipo_de_destino(paquete),
        ])
    )


print('method,dest_type')
sniff(prn=mostrar_paquete)
