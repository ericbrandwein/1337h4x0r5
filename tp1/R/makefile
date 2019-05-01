DATOS_S1=../datos/s1
DATOS_S2=../datos/s2

tablas: tabla-s1-eric tabla-s1-bilio tabla-s1-exactas tabla-s1-labo \
	tabla-s2-biblio tabla-s2-eric 

barras: barras-s1-eric barras-s1-bilio barras-s1-exactas barras-s1-labo 

tabla-s1-eric:
	Rscript punto1.Rscript $(DATOS_S1)/casa-eric-nuevo.csv > \
	../tablas/$@

tabla-s1-bilio:
	Rscript punto1.Rscript $(DATOS_S1)/biblio-s1.csv > \
	../tablas/$@

tabla-s1-exactas:
	Rscript punto1.Rscript $(DATOS_S1)/exactas-wifi.csv > \
	../tablas/$@

tabla-s1-labo:
	Rscript punto1.Rscript $(DATOS_S1)/labo-wifi.csv > \
	../tablas/$@



tabla-s2-biblio:
	Rscript punto2a.Rscript $(DATOS_S2)/biblio-s2.csv > \
	../tablas/$@

tabla-s2-eric:
	Rscript punto2a.Rscript $(DATOS_S2)/casa-eric.csv > \
	../tablas/$@



barras-s1-eric:
	Rscript grafico-barras-s1.Rscript $(DATOS_S1)/casa-eric-nuevo.csv 


barras-s1-bilio:
	Rscript grafico-barras-s1.Rscript $(DATOS_S1)/exactas-wifi.csv

barras-s1-exactas:
	Rscript grafico-barras-s1.Rscript $(DATOS_S1)/labo-wifi.csv

barras-s1-labo:
	Rscript grafico-barras-s1.Rscript $(DATOS_S1)/s1-uchi.csv

