#
# Cookbook Name:: basics
# Recipe:: default
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#


include_recipe 'apt'
include_recipe 'apt::disable_recommends'


# Default shared memory is too low to be useful
template '/etc/sysctl.conf' do
    mode '0644'
    source 'ubuntu-sysctl.conf.erb'
end
