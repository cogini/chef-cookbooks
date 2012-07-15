#
# Cookbook Name:: yum
# Recipe:: remi
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#

key = "#{node.platform}#{node.platform_version.to_i}"

case key
when "centos6"
    url = "http://remi-mirror.dedipower.com/enterprise/remi-release-6.rpm"
when "centos5"
    url = "http://remi-mirror.dedipower.com/enterprise/remi-release-5.rpm"
else
    raise NotImplementedError
end

remi_file = "#{Chef::Config[:file_cache_path]}/#{File.basename(url)}"


package "remi-release" do
    action :remove
end

remote_file remi_file do
    source url
    action :create_if_missing
end

execute "install remi" do
    command "yum install -y #{remi_file}"
end


yum_repo :remi do
    action :disable
end
