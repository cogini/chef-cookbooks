#
# Cookbook Name:: basics
# Recipe:: sudoers
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#

case node[:platform]
when 'ubuntu', 'centos', 'amazon'
else
    raise NotImpleMentedError
end

sudoers = node[:sudoers]
admin_users = node[:admin_users]

users = sudoers | admin_users

users.each do |username|
    user username do
        home "/home/#{username}"
        supports :manage_home => true
        action :create
    end
end

group 'sudo' do
    members sudoers
    action :create
end

group node[:admin_group] do
    members admin_users
    action :create
end

template '/etc/sudoers' do
    source 'sudoers.erb'
    mode '0440'
end
