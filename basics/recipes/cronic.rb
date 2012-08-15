#
# Cookbook Name:: basics
# Recipe:: cronic
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#

cronic = node[:cronic]

directory File.dirname(cronic) do
    action :create
    recursive true
end

remote_file cronic do
    source 'http://habilis.net/cronic/cronic'
    action :create_if_missing
    mode '0755'
end
