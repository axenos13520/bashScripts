#!/bin/bash

protocols=('psk' '8021x')

isProtocol() {
    for protocol in ${protocols[@]}; do
        if [ $1 = $protocol ]; then
            return 1
        fi
    done

    return 0
}

iwctl station wlan0 scan

input=$(iwctl station wlan0 get-networks)

networks=()
count=0

previous=''
for i in ${input[@]}; do
    isProtocol $i

    if [ $? -eq 1 ] && [ $count -lt 20 ]; then
        networks=(${networks[@]} $previous)
        count=$(expr $count + 1)
    fi

    previous=$i
done

echo 'Available networks:'

for i in ${!networks[@]}; do
    echo "[$i] ${networks[$i]}"
done

echo

read -p 'enter network id to connect (default - 0): ' index

if [ ${#index} -eq 0 ]; then
    index=0
fi

re='^[0-9]+$'
if ! [[ $index =~ $re ]] || [ $index -lt 0 ] || [ $index -ge ${#networks[@]} ]; then
    echo 'error: invalid network id'
    exit
fi

echo "wsmart: connecting to '${networks[$index]}'..."
iwctl station wlan0 connect ${networks[$index]}
