#!/bin/bash

if [ 1 -eq $# ]; then
    SRC_NAME=$1

    while read -a line; do
        IP_ADDR=${line[1]}
        UNIV_NAME=${line[0]}

        traceroute -n $IP_ADDR > $SRC_NAME-$UNIV_NAME.icmp &
        traceroute -nT $IP_ADDR > $SRC_NAME-$UNIV_NAME.tcp &
        traceroute -nU $IP_ADDR > $SRC_NAME-$UNIV_NAME.udp &
        
    done < ../universidades

    wait
    echo get-data.sh finished

else
    echo tenes que poner un nombre de source.
    echo Ejemplo:
    echo $0 MI_NOMBRE
fi
