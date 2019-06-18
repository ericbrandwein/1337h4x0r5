#!/bin/bash

if [ 1 -eq $# ]; then

    SRC_NAME=$1
    
    while read -a line; do
        IP_ADDR=${line[1]}
        UNIV_NAME=${line[0]}
        OUTFILE=$SRC_NAME-$UNIV_NAME.csv
        
        echo route from $SRC_NAME to  $IP_ADDR $UNIV_NAME
        echo outfile: $OUTFILE
        sudo ../py/traceroute.py  $IP_ADDR $OUTFILE
        
    done < universidades

    wait
    echo get-data-scapy.sh finished

else
    echo tenes que poner un nombre de source.
    echo Ejemplo:
    echo $0 MI_NOMBRE
fi
