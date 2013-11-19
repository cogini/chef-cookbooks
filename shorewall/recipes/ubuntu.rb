#
# Cookbook Name:: shorewall
# Recipe:: ubuntu
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#


package 'shorewall' do
    action 'install'
end

service 'shorewall' do
    action [:enable, :start]
end

template '/etc/default/shorewall' do
    mode '644'
    source 'ubuntu-shorewall.conf.erb'
    notifies 'service[shorewall]'
end
