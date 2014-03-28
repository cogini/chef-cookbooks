#
# Cookbook Name:: munin
# Recipe:: gatherer
#
# Copyright 2012, Cogini
#

include_recipe 'munin::default'

package 'munin' do
    action :install
end

service 'munin' do
    action [:enable, :start]
end

template '/etc/munin/munin.conf' do
    mode 0644
    source 'munin.conf.erb'
    notifies :restart, 'service[munin]'
end
