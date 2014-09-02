#!/bin/bash

# This script is modified from the setup script for SaaSBook Image
# https://github.com/saasbook/courseware/blob/master/vm-setup/configure-image-0.10.3.sh

# This script is designed for Ubuntu 12.04
# run with . <filename>.sh

# Get password to be used with sudo commands
# Script still requires password entry during rvm and heroku installs
echo -n "Enter password to be used for sudo commands:"
read -s password

echo -n "Prompt before installing each package? [yes/no] "
read prompt

# Function to issue sudo command with password
function sudo-pw {
    echo $password | sudo -S $@
}

# Start configuration
cd ~/
sudo-pw apt-get update

for i in dkms virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11 vim emacs git chromium-browser curl postgresql postgresql-contrib python-protobuf mongodb openjdk-7-jdk r-base-core python-setuptools python-dev python-pip python-matplotlib ipython-notebook python-numpy  python-pandas python-scipy python-zmq python-jinja2 sqlite3
do
    if [ "$prompt" = "yes" ]; then
        tput clear; echo "================== INSTALLING " $i " ==== Press Enter to Continue"; read answer 
    fi
    sudo-pw apt-get install -y $i
done

# These have binaries and can be installed through apt-get -- pip install -U numpy pandas ipython jinja2 zmq
# These don't -- pip install -U scikit-learn tornado
# Not sure whether we really need: zmq tornado
if [ "$prompt" = "yes" ]; then
    tput clear; echo "================== INSTALLING scikit-learn ==== Press Enter to Continue"; read answer 
fi
pip install -U scikit-learn


# Install maven
if [ "$prompt" = "yes" ]; then
    tput clear; echo "================== INSTALLING Apache Maven ==== Press Enter to Continue"; read answer 
fi
sudo-pw curl -o /usr/local/apache-maven-3.2.3-bin.zip http://mirror.tcpdiag.net/apache/maven/maven-3/3.2.3/binaries/apache-maven-3.2.3-bin.zip
cd /usr/local/
sudo-pw unzip apache-maven-3.2.3-bin.zip
echo 'PATH=/usr/local/apache-maven-3.2.3/bin:$PATH' >> ~/.bashrc
cd ~
