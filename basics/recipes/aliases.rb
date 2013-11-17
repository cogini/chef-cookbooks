#
# Cookbook Name:: basics
# Recipe:: aliases
#
# Copyright 2012, Cogini
#
# All rights reserved - Do not Redistribute
#

include_recipe 'postfix::vanilla'

execute 'newaliases' do
    action :nothing
end

template '/etc/aliases' do
    mode '644'
    notifies :run, 'execute[newaliases]'
end
