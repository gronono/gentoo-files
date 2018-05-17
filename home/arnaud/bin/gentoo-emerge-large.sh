#!/bin/bash

read -e -p 'Size(GB): ' -i '4' size
read -e -p 'File: ' -i "$HOME/swap.img" file

echo "Creating swap file..."
sudo touch $file
sudo chmod 600 $file
sudo dd if=/dev/zero bs=1024M of=$file count=$size
echo "Enable swap..."
sudo mkswap $file
sudo swapon $file

echo "Emerge $1"
sudo emerge -auND $1

echo "Removing swap file..."
sudo swapoff $file
sudo rm $file

