#
# Cookbook Name:: basics
# Recipe:: sudoers
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#

include_recipe "user"

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
        ssh_keygen false
        action :create
    end
end

sudo_members = []
sudoers.each do |user|
  sudo_members.push(user[:username])
end

group 'sudo' do
    members sudo_members
    action :create
end

admin_members = []
admin_users.each do |user|
  admin_members.push(user[:username])
end

group node[:admin_group] do
    members admin_members
    action :create
end

template '/etc/sudoers' do
    source 'sudoers.erb'
    mode '0440'
end
