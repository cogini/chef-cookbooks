#
# Cookbook Name:: basics
# Recipe:: sudoers
#
# Copyright 2012, Cogini
#

case node[:platform]
when 'ubuntu', 'centos', 'amazon'
else
    raise NotImpleMentedError
end

sudoers = node[:sudoers]
admin_users = node[:admin_users]

users = sudoers | admin_users

users.each do |user|
    user_account user[:username] do
        ssh_keys user[:ssh_keys]
        manage_home true
        home "/home/#{user[:username]}"
        action :create
    end
end

sudo_members = users.collect { |u| u[:username] }

group 'sudo' do
    members sudo_members
    action :create
end

admin_members = admin_users.collect { |u| u[:username] }

group node[:admin_group] do
    members admin_members
    action :create
end

template '/etc/sudoers' do
    source 'sudoers.erb'
    mode '0440'
end
