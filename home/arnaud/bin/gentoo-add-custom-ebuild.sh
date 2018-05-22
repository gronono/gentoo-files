#!/bin/sh
sudo mkdir -p /usr/local/portage/$1/$2
sudo cp $3 /usr/local/portage/$1/$2/
sudo chown -R portage:portage /usr/local/portage
cd /usr/local/portage/$1/$2
sudo repoman manifest
cd -

