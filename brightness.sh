#!/bin/bash

max_brightness=$(cat /sys/class/backlight/intel_backlight/max_brightness)

sudo tee /sys/class/backlight/intel_backlight/brightness <<<$(($1 * $max_brightness / 100)) >/dev/null
