#
# Cookbook Name:: shorewall
# Recipe:: redhat
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'yum::epel'

package 'shorewall' do
    action :install
    options '--enablerepo=epel'
end

template '/etc/shorewall/shorewall.conf' do
    mode '0644'
    source 'redhat-shorewall.conf.erb'
end
