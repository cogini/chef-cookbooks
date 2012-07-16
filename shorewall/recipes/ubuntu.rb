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

template '/etc/default/shorewall' do
    mode '0644'
    source 'ubuntu-shorewall.conf.erb'
end
