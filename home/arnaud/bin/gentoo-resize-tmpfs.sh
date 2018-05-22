#!/bin/bash

read -e -p 'Size(GB): ' -i '2' size
size="${size}g"
sudo mount -o remount,size=${size} /tmp

