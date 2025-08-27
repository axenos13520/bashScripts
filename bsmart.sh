#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

option=${1:1}

if [ ${#option} -eq 0 ]; then
    echo -e "${RED}error: no operation specified (use -h for help)${NC}"
    exit
fi

case "$option" in
'-help') option='h' ;;
'-connect') option='c' ;;
'-disconnect') option='d' ;;
'-remove') option='r' ;;
esac

if [ "$option" = 'h' ]; then
    echo 'usage: bsmart <operation>'
    echo 'operations:'
    echo '  -h --help: open this help page'
    echo '  -c --connect: connect to paired device'
    echo '  -d --disconnect: disconnect from paired device'
    echo '  -r --remove: unpair device'
    exit
fi

if [ "$option" != 'c' ] && [ "$option" != 'd' ] && [ "$option" != 'r' ]; then
    echo -e "${RED}bsmart: invalid option -- '$option'${NC}"
    exit
fi

mapfile -t input < <(bluetoothctl devices)

devices=()
macArray=()

for i in "${!input[@]}"; do
    read -ra words <<<"${input[$i]}"

    if [ "${words[0]}" == "Device" ]; then
        macArray=("${macArray[@]}" "${words[1]}")

        current="${words[*]:2}"

        devices=("${devices[@]}" "$current")
    fi
done

echo -e "${BLUE}Paired devices:${NC}"
for i in "${!devices[@]}"; do
    echo -e "${YELLOW}[$i] ${NC}${devices[$i]} | ${macArray[$i]}"
done

echo

case "$option" in
'c') read -rp 'enter device id to connect (default - 0): ' index ;;
'd') read -rp 'enter device id to disconnect (default - 0): ' index ;;
'r') read -rp 'enter device id to remove (default - 0): ' index ;;
esac

if [ ${#index} -eq 0 ]; then
    index=0
fi

re='^[0-9]+$'
if ! [[ $index =~ $re ]] || [ "$index" -lt 0 ] || [ "$index" -ge ${#macArray[@]} ]; then
    echo -e "${RED}error: invalid device id${NC}"
    exit
fi

deviceMac="${macArray[$index]}"

case "$option" in
'c') bluetoothctl connect "$deviceMac" ;;
'd') bluetoothctl disconnect "$deviceMac" ;;
'r') bluetoothctl remove "$deviceMac" ;;
esac
