#!/bin/sh

# TODO:
# - Create function for >/dev/null 2>errors.txt

# Install 'Extra Packages for Enterprise Linux' - force 'yes'
sudo yum install epel-release -y > /dev/null 2>errors.txt
cat errors.txt

# Update existing packages - force 'yes'
sudo yum update -y > /dev/null 2>errors.txt
cat errors.txt

# Install checksum tool for later use
sudo yum install perl-Digest-SHA -y > /dev/null 2>errors.txt
cat errors.txt

# Install open jdk 8
sudo yum install -y java-1.8.0-openjdk > /dev/null 2>errors.txt
cat errors.txt

# Verify Version
# TODO - add verify logic
java -version > /dev/null 2>errors.txt
cat errors.txt

# Need wget for later steps
sudo yum install -y wget > /dev/null 2>errors.txt
cat errors.txt

# https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SingleCluster.html
# SSH keygen, and add identity to current user
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa > /dev/null 2>errors.txt
cat errors.txt

# Add newly created ssh key to user auth keys
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

# Perm adjustment
chmod 0600 ~/.ssh/authorized_keys > /dev/null 2>errors.txt
cat errors.txt

# Reboot - vagrant file controlled ("config.vm.provision :reload")
#sudo shutdown -r now
