#
# Cookbook Name:: basics
# Recipe:: cronic
#
# Copyright 2012, Cogini
#

cronic = node[:cronic]

directory File.dirname(cronic) do
    action :create
    recursive true
end

template cronic do
    source 'cronic.erb'
    mode '755'
end
