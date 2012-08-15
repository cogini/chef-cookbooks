#
# Cookbook Name:: localbackup
# Recipe:: default
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'basics::cronic'

script_dir = '/root/scripts'

[node[:localbackup][:destination], script_dir].each do |dir|
    directory dir do
        action 'create'
        recursive true
    end
end

template "#{script_dir}/make_backup.sh" do
    source 'make_backup.sh.erb'
    action 'create'
    mode '0700'
end

cron 'local backup' do
    hour node[:localbackup][:time]
    minute '0'
    command "#{node[:cronic]} #{script_dir}/make_backup.sh"
end
