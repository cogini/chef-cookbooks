#!/bin/bash
echo "deb http://apt.opscode.com/ `lsb_release -cs`-0.10 main" > /etc/apt/sources.list.d/opscode.list
mkdir -p /etc/apt/trusted.gpg.d
gpg --keyserver keys.gnupg.net --recv-keys 83EF826A
gpg --export packages@opscode.com > /etc/apt/trusted.gpg.d/opscode-keyring.gpg
apt-get update
apt-get install opscode-keyring
echo "chef chef/chef_server_url string none" | debconf-set-selections && apt-get install chef -y

# Hardy is funny
# Add this ppa https://launchpad.net/~ubuntu-ruby/+archive/ppa
#sudo apt-get install build-essential libopenssl-ruby ruby1.8-dev rubygems
#sudo gem install chef
