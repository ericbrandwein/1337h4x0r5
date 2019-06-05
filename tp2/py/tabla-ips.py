import csv
from geoip import geolite2
import sys

#python tabla-ips.py "nombrearchivo csv de datos"

file_csv = open(sys.argv[1],"r")
tabla = csv.reader(file_csv)

listaIPs = []

for row in tabla:
	if row[0] != "dst" and row[0] != "NA":
		if row[0] not in listaIPs:
			listaIPs.append(row[0])



file_csv.close()


print "Host","(Lat, Long)", "Timezone", "Pais", "Continente"

for ip in listaIPs:
	match = geolite2.lookup(ip)
	if match is not None:
		print ip, match.location, match.timezone, match.country, match.continent




