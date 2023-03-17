#!/bin/bash

# Tested on Oracle Linux 7.9, 24th, March 2021

sudo yum install -y yum-utils libseccomp
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
sudo sed -i 's/$releasever/7/g' /etc/yum.repos.d/docker-ce.repo
mkdir rpms && cd rpms
wget http://mirror.centos.org/centos/7/extras/x86_64/Packages/slirp4netns-0.4.3-4.el7_8.x86_64.rpm
wget http://mirror.centos.org/centos/7/extras/x86_64/Packages/fuse3-libs-3.6.1-4.el7.x86_64.rpm
wget http://mirror.centos.org/centos/7/extras/x86_64/Packages/fuse-overlayfs-0.7.2-6.el7_8.x86_64.rpm
sudo rpm -Uvh slirp4netns-0.4.3-4.el7_8.x86_64.rpm fuse3-libs-3.6.1-4.el7.x86_64.rpm fuse-overlayfs-0.7.2-6.el7_8.x86_64.rpm
sudo yum install docker-ce docker-ce-cli containerd.io -y
cd .. && rm -rf rpms
docker --version


########################### Another way to install ###########################
# This will install a customized version of docker from oracle provided repo
# And this won't install the latest docker version, use the following lines to install
# repo-query -i docker-engine
# sudo yum-config-manager --enable ol7_addons
# sudo yum install docker-engine

