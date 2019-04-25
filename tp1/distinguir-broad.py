import sys, os
from math import log as LOG
from scapy.all import *

def mostrarNodos(source):
	H = 0
	N = sum(source.values())

	nodes = []
	for a, c in source.iteritems():
		p = c/float(N)
		i = -LOG(p, 2)
		H += p * i
		nodes.append((a,p))

	# nodes.sort(key=lambda n: n[1])
	print "Entropia", H, "Entropia maxima", LOG(len(nodes),2)
	for a,p in nodes:
		print a , ("%.5f" % p) 

def trafico_type(pkt):
	if pkt.dst == 'ff:ff:ff:ff:ff:ff': # es broadcast
		if ('bcast',hex(pkt.type)) not in fuente_s1:
			fuente_s1.append(('bcast',hex(pkt.type)))
			frec[('bcast',hex(pkt.type))] = 0
		frec[('bcast',hex(pkt.type))] += 1
	else:				  # es unicast (o quiza multicast)	
		if ('unicast',hex(pkt.type)) not in fuente_s1:
			fuente_s1.append(('unicast',hex(pkt.type)))
			frec[('unicast',hex(pkt.type))] = 0
		frec[('unicast',hex(pkt.type))] += 1
		
		

fuente_s1 = []
frec = {}	

sniff(prn=trafico_type, count=12000)
print fuente_s1
mostrarNodos(frec)	
