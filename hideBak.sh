#!/bin/bash

find $1*.bak -maxdepth 1 -type f -printf "%f\n" | while read file; do mv "$1$file" "$1.$file"; done
