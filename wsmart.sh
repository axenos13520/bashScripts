#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

sleep 0.5

input=$(iwctl station wlan0 get-networks)

networks=()
networkProtocols=()
count=0

previous=''
for i in ${input[@]}; do
    isProtocol $i

    if [ $? -eq 1 ] && [ $count -lt 20 ]; then
        networks=(${networks[@]} $previous)
        networkProtocols=(${networkProtocols[@]} $i)
        count=$(expr $count + 1)
    fi

    previous=$i
done

echo -e "${BLUE}Available networks:"

for i in ${!networks[@]}; do
    echo -e "${YELLOW}[$i] ${NC}${networks[$i]} ${BLUE}${networkProtocols[i]}${NC}"
done

echo

read -p 'enter network id to connect (default - 0): ' index

if [ ${#index} -eq 0 ]; then
    index=0
fi

re='^[0-9]+$'
if ! [[ $index =~ $re ]] || [ $index -lt 0 ] || [ $index -ge ${#networks[@]} ]; then
    echo -e "${RED}error: invalid network id${NC}"
    exit
fi

echo "wsmart: connecting to '${networks[$index]}'..."
iwctl station wlan0 connect ${networks[$index]}
