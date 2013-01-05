#
# Cookbook Name:: yum
# Recipe:: epel
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
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

package 'epel-release' do
    action :remove
end

remote_file rpm_file do
    source url
    action :create_if_missing
end

execute 'install epel' do
    command "rpm -i #{rpm_file}"
end
