#
# Cookbook Name:: shorewall
# Recipe:: ubuntu
#
# Copyright 2012, Cogini
#


package 'shorewall' do
    action 'install'
end

template '/etc/default/shorewall' do
    mode '644'
    source 'ubuntu-shorewall.conf.erb'
    notifies :restart, 'service[shorewall]'
end
