#!/bin/bash

while true; do
	battery_status=$(echo "$(acpi -b)" | awk -F', ' '{print $2}')

	xsetroot -name "$battery_status $(date)"
	sleep 1
done
