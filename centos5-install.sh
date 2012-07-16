#!/bin/bash

rubygems_version=1.8.10

# Install Ruby
yum install -y wget
wget -O /etc/yum.repos.d/aegisco.repo http://rpm.aegisco.com/aegisco/el5/aegisco.repo
rpm -Uvh http://rbel.frameos.org/rbel5
yum install -y ruby ruby-devel ruby-ri ruby-rdoc ruby-shadow gcc gcc-c++ automake autoconf make curl dmidecode

# Install RubyGems from Source
curl -O http://production.cf.rubygems.org/rubygems/rubygems-$rubygems_version.tgz
tar zxf rubygems-$rubygems_version.tgz
cd rubygems-$rubygems_version
sudo ruby setup.rb --no-format-executable

# Install Chef Gem
gem install chef --no-ri --no-rdoc
