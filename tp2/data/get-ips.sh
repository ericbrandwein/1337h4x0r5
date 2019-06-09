#!/bin/bash

while read -a line; do
    IP_ADDR=${line[1]}
    UNIV_NAME=${line[0]}
    OUTFILE=$SRC_NAME-$UNIV_NAME.csv
    IP_NUM=$(dig $IP_ADDR | grep -G "^$IP_ADDR" | awk ' { print $5 }')
    echo $UNIV_NAME $IP_ADDR $IP_NUM
done < universidades

