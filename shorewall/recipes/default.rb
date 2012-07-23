#
# Cookbook Name:: shorewall
# Recipe:: default
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#

case node['platform']
when 'centos', 'redhat'
    include_recipe 'shorewall::redhat'
when 'ubuntu'
    include_recipe 'shorewall::ubuntu'
end


template '/etc/shorewall/rules' do
    mode '0644'
    source 'rules.erb'
end

template '/etc/shorewall/zones' do
    mode '0644'
    source 'zones.erb'
end

template '/etc/shorewall/interfaces' do
    mode '0644'
    source 'interfaces.erb'
end

template '/etc/shorewall/policy' do
    mode '0644'
    source 'policy.erb'
end

service 'shorewall' do
    action [:enable, :start, :restart]
end
