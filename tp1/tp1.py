#!/usr/bin/python3

import sys
import os
from math import log2
from scapy.all import sniff, ARP


def mostrar_nodos_distinguidos(source):
    entropia = 0
    apariciones_totales = sum(source.values())
    cant_simbolos = len(source)
    if cant_simbolos:
        nodes = []
        for simbolo, apariciones in source.items():
            probabilidad_simbolo = apariciones / float(apariciones_totales)
            informacion = -log2(probabilidad_simbolo)
            entropia += probabilidad_simbolo * informacion
            nodes.append((simbolo, informacion))

        nodes.sort(key=lambda n: n[1])
        print("Entropía:", entropia, "\tEntropía máxima:", log2(cant_simbolos))
        print("Símbolo\t\tInformación - Entropía\t\tDistinguido")
        for simbolo, informacion in nodes[:20]:
            print(simbolo + "\t" + ("%.5f" % (informacion - entropia)) +
                  "\t\t\t" + ("*" if informacion - entropia < 0 else ""))


def entropy_callback(paquete):
    try:
        if paquete[ARP].op == 1:  # who-has (request)
            if paquete[ARP].psrc not in who_has_sources:
                who_has_sources[paquete[ARP].psrc] = 0
            who_has_sources[paquete[ARP].psrc] += 1
            if paquete[ARP].pdst not in who_has_destinations:
                who_has_destinations[paquete[ARP].pdst] = 0
            who_has_destinations[paquete[ARP].pdst] += 1

        if paquete[ARP].op == 2:  # is-at (response)
            if paquete[ARP].psrc not in is_at_sources:
                is_at_sources[paquete[ARP].psrc] = 0
            is_at_sources[paquete[ARP].psrc] += 1
            if paquete[ARP].pdst not in is_at_destinations:
                is_at_destinations[paquete[ARP].pdst] = 0
            is_at_destinations[paquete[ARP].pdst] += 1
    except:
        return

    os.system("clear")
    print("~~~~~ WHO-HAS ~~~~~")
    print("=== Orígenes ===")
    mostrar_nodos_distinguidos(who_has_sources)
    print("\n=== Destinos ===")
    mostrar_nodos_distinguidos(who_has_destinations)
    print("\n~~~~~ IS-AT ~~~~~")
    print("=== Orígenes ===")
    mostrar_nodos_distinguidos(is_at_destinations)
    print("\n=== Destinos ===")
    mostrar_nodos_distinguidos(is_at_sources)
    global paquetes_totales
    paquetes_totales += 1
    print("\nCantidad de paquetes ARP: " + str(paquetes_totales))
    cantidad_paquetes_is_at = sum(is_at_destinations.values())
    print("Cantidad de paquetes IS-AT: " + str(cantidad_paquetes_is_at))


who_has_sources = {}
who_has_destinations = {}
is_at_sources = {}
is_at_destinations = {}
paquetes_totales = 0

sniff(prn=entropy_callback, filter="arp")
