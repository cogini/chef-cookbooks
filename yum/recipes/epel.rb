#
# Cookbook Name:: yum
# Recipe:: epel
#
# Copyright 2012, Cogini
#

key = "#{node.platform}#{node.platform_version.to_i}"

case key
when 'centos6', 'amazon2012'
    url = 'http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm'
when 'centos5'
    url = 'http://dl.fedoraproject.org/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm'
else
    raise NotImplementedError
end

rpm_file = "#{Chef::Config[:file_cache_path]}/#{File.basename(url)}"

remote_file rpm_file do
    source url
    action :create_if_missing
end

package 'epel-release' do
    source rpm_file
end
