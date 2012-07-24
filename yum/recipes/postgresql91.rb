#
# Cookbook Name:: yum
# Recipe:: postgresql91
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#

key = "#{node.platform}#{node.platform_version.to_i}"

case key
when 'centos6'
    url = 'http://yum.postgresql.org/9.1/redhat/rhel-6-x86_64/pgdg-centos91-9.1-4.noarch.rpm'
else
    raise NotImplementedError
end

rpm_file = "#{Chef::Config[:file_cache_path]}/#{File.basename(url)}"

package 'pgdg-centos91' do
    action :remove
end

remote_file rpm_file do
    source url
    action :create_if_missing
end

execute 'install pgdg-centos91' do
    command "rpm -i #{rpm_file}"
end

template '/etc/yum.repos.d/CentOS-Base.repo' do
    source 'postgresql-CentOS-Base.repo.erb'
    mode '0644'
end
