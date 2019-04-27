
import sys, os
from math import log as LOG
from scapy.all import *

i = 0
def i_pack():
	global i
	i +=1
	print "paquete nro : ", i
	os.system("clear")		
	print "paquete nro : ", i
	os.system("clear")		
	print "paquete nro : ", i
	os.system("clear")		
	print "paquete nro : ", i
	

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
		print a , " " , ("%.5f" % p) 

def trafico(pkt):
	i_pack()
	try:
		if pkt.dst == 'ff:ff:ff:ff:ff:ff': # es broadcast
			if ('bcast',hex(pkt.type)) not in frec:
				frec[('bcast',hex(pkt.type))] = 0
			frec[('bcast',hex(pkt.type))] += 1
		else:				  # es unicast (o quiza multicast)	
			if ('unicast',hex(pkt.type)) not in frec:
				frec[('unicast',hex(pkt.type))] = 0
			frec[('unicast',hex(pkt.type))] += 1
	except:	
		 return


frec = {}	

sniff(prn=trafico, count=12000)
print "mi fuente"
print frec.items() , "\n"
mostrarNodos(frec)
