#
# Cookbook Name:: localbackup
# Recipe:: default
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'basics::cronic'


[
    node[:localbackup][:script_dir],
    node[:localbackup][:destination],
].each do |dir|
    directory dir do
        action 'create'
        recursive true
    end
end


file node[:localbackup][:ignore_file] do
    content node[:localbackup][:ignore].join("\n")
end


backup_script = "#{node[:localbackup][:script_file]}"


template backup_script do
    source 'make_backup.sh.erb'
    mode '0700'
end


cron 'local backup' do
    hour node[:localbackup][:cron_time]
    minute '0'
    command "#{node[:cronic]} #{backup_script}"
end
