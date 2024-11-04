#!/bin/bash

option=${1:1}

if [ ${#option} -eq 0 ]; then
    echo 'error: no operation specified (use -h for help)'
    exit
fi

case $option in
'-help') option='h' ;;
'-connect') option='c' ;;
'-disconnect') option='d' ;;
esac

if [ $option = 'h' ]; then
    echo 'usage: bsmart <operation>'
    echo 'operations:'
    echo '  bsmart {-h --help}'
    echo '  bsmart {-c --connect}'
    echo '  bsmart {-d --disconnect}'

    exit
fi

if [ $option != 'c' ] && [ $option != 'd' ]; then
    echo "bsmart: invalid option -- '$option'"
    exit
fi

input=($(bluetoothctl devices))
devices=()
macArray=()

for i in ${!input[@]}; do
    if [ ${input[i]} = 'Device' ]; then
        macArray=(${macArray[@]} ${input[(i + 1)]})

        j=$(expr $i + 2)
        current=''
        while [ $j -lt ${#input[@]} ] && [ ${input[$j]} != 'Device' ]; do
            current+="${input[$j]}-"
            j=$(expr $j + 1)
        done
        current=${current:0:-1}

        devices=(${devices[@]} $current)
    fi
done

echo 'Paired devices:'
for i in ${!devices[@]}; do
    echo "[$i] ${devices[i]}"
done

echo

case $option in
'c') read -p 'enter device id to connect (default - 0): ' index ;;
'd') read -p 'enter device id to disconnect (default - 0): ' index ;;
esac

if [ ${#index} -eq 0 ]; then
    index=0
fi

re='^[0-9]+$'
if ! [[ $index =~ $re ]] || [ $index -lt 0 ] || [ $index -ge ${#macArray[@]} ]; then
    echo 'error: invalid device id'
    exit
fi

case $option in
'c') bluetoothctl connect ${macArray[$index]} ;;
'd') bluetoothctl disconnect ${macArray[$index]} ;;
esac
