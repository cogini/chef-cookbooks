#
# Cookbook Name:: basics
# Recipe:: sshusers
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#

sshusers = node[:sshusers]

service node[:ssh][:service] do
    supports :restart => true
end

sshusers.each do |username|
    user username do
        home "/home/#{username}"
        shell '/bin/bash'
        supports :manage_home => true
        action :create
    end
end

group 'sshusers' do
    members sshusers
    action :create
end

template '/etc/ssh/sshd_config' do
    source 'sshd-config.erb'
    mode '0644'
    notifies :restart, "service[#{node[:ssh][:service]}]"
end
