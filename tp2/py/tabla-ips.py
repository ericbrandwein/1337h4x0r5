#!/usr/bin/python

import csv
from geoip import geolite2
import sys

#python tabla-ips.py "nombrearchivo csv de datos"
filename = sys.argv[1]

file_csv = open(filename,"r")
tabla = csv.reader(file_csv)

listaIPs = []

for row in tabla:
	if row[1] != "dst" and row[1] != "NA":
		if row[1] not in listaIPs:
			listaIPs.append(row[1])



file_csv.close()


print "Host, Lat, Long, Timezone, Pais, Continente"

for ip in listaIPs:
	match = geolite2.lookup(ip)
	if match is not None:
		print ip,"," ,match.location[0],",",match.location[1],",", match.timezone,",", match.country,",", match.continent
