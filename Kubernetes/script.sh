#! /bin/bash

cd Vagrant/
vagrant up
./client.sh
cd ..
cd Kubectl/
./script.sh
