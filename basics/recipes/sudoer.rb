#
# Cookbook Name:: basics
# Recipe:: sudoer
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#

sudoers = node[:sudoers]
admin_users = node[:admin_users]

case node[:platform]
when 'ubuntu'
else
    raise NotImpleMentedError
end

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

group 'admin' do
    members admin_users
    action :create
end

template '/etc/sudoers' do
    source 'sudoers.erb'
    mode '0440'
end
