#!/bin/bash

sudo mount.cifs -o user=arch,uid=1000 //192.168.0.$1/ОБМЕН $2
