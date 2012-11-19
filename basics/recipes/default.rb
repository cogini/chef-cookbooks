#
# Cookbook Name:: basics
# Recipe:: default
#
# Copyright 2012, Cogini
#
# All rights reserved - Do not Redistribute
#


# Somehow the cache is not created automatically
directory Chef::Config[:file_cache_path] do
    action :create
    recursive true
end


include_recipe 'basics::hostname'
include_recipe 'basics::aliases'
include_recipe 'basics::unicode'
include_recipe 'ssh'
include_recipe 'basics::sudoers'
include_recipe 'basics::rotate_mail'
include_recipe 'localbackup'
include_recipe 'basics::packages'


case node.platform
when 'redhat', 'centos', 'amazon'
    include_recipe 'basics::redhat'
when 'ubuntu'
    include_recipe 'basics::ubuntu'
end
