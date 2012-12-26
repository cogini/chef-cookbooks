#
# Author:: Marius Ducea (marius@promethost.com)
# Cookbook Name:: nodejs
# Recipe:: default
#
# Copyright 2010, Promet Solutions
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'build-essential'
include_recipe 'fpm'


case node[:platform]
when 'centos', 'redhat', 'fedora'
    package 'openssl-devel'
when 'debian', 'ubuntu'
    package 'libssl-dev'
end

chef_cache = Chef::Config[:file_cache_path]

nodejs_tar = "node-v#{node[:nodejs][:version]}.tar.gz"
nodejs_tar_path = nodejs_tar

if node[:nodejs][:version].split('.')[1].to_i >= 5
    nodejs_tar_path = "v#{node[:nodejs][:version]}/#{nodejs_tar_path}"
end

remote_file "#{chef_cache}/#{nodejs_tar}" do
    source "http://nodejs.org/dist/#{nodejs_tar_path}"
    checksum node[:nodejs][:checksum]
    mode 0644
end

# --no-same-owner required overcome "Cannot change ownership" bug
# on NFS-mounted filesystem
execute "tar --no-same-owner -zxf #{nodejs_tar}" do
    cwd "#{chef_cache}"
    creates "#{chef_cache}/node-v#{node[:nodejs][:version]}"
end

bash 'compile node.js' do
    cwd "#{chef_cache}/node-v#{node[:nodejs][:version]}"
    code <<-EOH
        ./configure --prefix=#{node[:nodejs][:dir]} && \
        make
    EOH
    creates "#{chef_cache}/node-v#{node[:nodejs][:version]}/node"
end

execute 'nodejs make install' do
    command 'make install'
    cwd "#{chef_cache}/node-v#{node[:nodejs][:version]}"
    not_if {File.exists?("#{node[:nodejs][:dir]}/bin/node") && `#{node[:nodejs][:dir]}/bin/node --version`.chomp == "v#{node[:nodejs][:version]}" }
end
