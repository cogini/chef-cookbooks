#
# Cookbook Name:: basics
# Recipe:: aliases
#
# Copyright 2012, Cogini
#
# All rights reserved - Do not Redistribute
#

include_recipe 'postfix::vanilla'

template '/etc/aliases' do
    mode '0644'
    source 'aliases.erb'
end

execute 'newaliases' do
  command 'newaliases'
end
