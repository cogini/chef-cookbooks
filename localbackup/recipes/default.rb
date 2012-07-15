#
# Cookbook Name:: localbackup
# Recipe:: default
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#

directory node[:localbackup][:destination] do
    action 'create'
    recursive true
end

template '/usr/local/backups/make_backup.sh' do
    source 'make_backup.sh.erb'
    action 'create'
    mode '0700'
end

cron 'local backup' do
    hour node[:localbackup][:time]
    minute '0'
    command '/usr/local/backups/make_backup.sh'
end
