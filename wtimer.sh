#!/bin/bash

sleep "$1" && notify-send -u critical -t 0 "⏰ Timer" "$2" &

