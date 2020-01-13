#!/bin/sh

# Install 'Extra Packages for Enterprise Linux' - force 'yes'
sudo yum install epel-release -y

# Update existing packages - force 'yes'
sudo yum update -y

# Install checksum tool for later use
sudo yum install perl-Digest-SHA -y

# Install open jdk 8
sudo yum install -y java-1.8.0-openjdk

# Verify Version
# TODO - add verify logic
java -version

# Need wget for later steps
sudo yum install -y wget

# Assuming root login for build - switching to vagrant user
sudo su vagrant

# Chg dir to current user - should be vagrant (not root)
cd

# https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SingleCluster.html
# SSH keygen, and add identity to current user
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa

# Add newly created ssh key to user auth keys
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

# Perm adjustment
chmod 0600 ~/.ssh/authorized_keys


# Reboot - vagrant file controlled ("config.vm.provision :reload")
#sudo shutdown -r now
