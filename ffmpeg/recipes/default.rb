#
# Cookbook Name:: ffmpeg
# Recipe:: default
#
# Copyright 2012, Cogini
#

package 'yum-plugin-versionlock'

package_from_url node[:ffmpeg][:package_url]

execute 'yum versionlock add ffmpeg' do
    not_if 'yum versionlock list | grep ffmpeg'
end
