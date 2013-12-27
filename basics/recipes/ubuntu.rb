#
# Cookbook Name:: basics
# Recipe:: default
#
# Copyright 2012, Cogini
#


include_recipe 'apt'
include_recipe 'apt::disable_recommends'


# Default is 32MB which is too low to be useful
sysctl_param 'kernel.shmmax' do
    # 64MB
    value 67108864
end
