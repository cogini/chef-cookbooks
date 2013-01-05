#
# Cookbook Name:: yum
# Recipe:: atrpms
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#

package_name = 'atrpms-repo'

package package_name do
    action :remove
end

key = "#{node.platform}#{node.platform_version.to_i}-#{system('uname -m | grep 64') ? 64 : 32}"

case key
when 'centos6-64', 'redhat6-64'
    url = 'http://dl.atrpms.net/all/atrpms-repo-6-6.el6.x86_64.rpm'
when 'centos6-32', 'redhat6-32'
    url = 'http://dl.atrpms.net/all/atrpms-repo-6-6.el6.i686.rpm'
when 'centos5-64', 'redhat5-64'
    url = 'http://dl.atrpms.net/all/atrpms-repo-5-6.el5.x86_64.rpm'
when 'centos5-32', 'redhat5-32'
    url = 'http://dl.atrpms.net/all/atrpms-repo-5-6.el5.i386.rpm'
else
    raise NotImplementedError
end

rpm_file = "#{Chef::Config[:file_cache_path]}/#{File.basename(url)}"

remote_file rpm_file do
    source url
    action :create_if_missing
end

execute 'install atrpms' do
    command "yum install -y #{rpm_file}"
end
