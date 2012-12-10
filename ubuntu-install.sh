#!/bin/bash

# For Hardy see http://stackoverflow.com/questions/1814301/updating-rubygems-on-ubuntu

sudo apt-get update
sudo apt-get install build-essential libopenssl-ruby ruby1.8-dev rubygems
sudo gem install chef

for i in $(echo chef-solo knife)
do
    sudo ln -s /var/lib/gems/1.8/bin/$i /usr/bin
done
