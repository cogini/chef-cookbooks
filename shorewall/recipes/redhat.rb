#
# Cookbook Name:: shorewall
# Recipe:: redhat
#
# Copyright 2012, Cogini
#

include_recipe 'yum::epel'

package 'shorewall' do
    action :install
    options '--enablerepo=epel'
end

template '/etc/shorewall/shorewall.conf' do
    mode '644'
    source 'redhat-shorewall.conf.erb'
    notifies :restart, 'service[shorewall]'
end
