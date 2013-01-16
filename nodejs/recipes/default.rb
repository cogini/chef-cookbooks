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


chef_cache = Chef::Config[:file_cache_path]
package_file = "#{chef_cache}/#{node[:nodejs][:package_file]}"
version = node[:nodejs][:version]
nodejs_tar = "node-v#{version}.tar.gz"
download_path = nodejs_tar
build_dir = "#{chef_cache}/node-v#{version}"

if version.split('.')[1].to_i >= 5
    download_path = "v#{version}/#{download_path}"
end


# Build the package if needed
unless File.exists?(package_file)

    node[:nodejs][:dependencies].each do |pkg|
        package pkg
    end

    remote_file "#{chef_cache}/#{nodejs_tar}" do
        source "http://nodejs.org/dist/#{download_path}"
        checksum node[:nodejs][:checksum]
        mode 0644
    end

    # --no-same-owner required overcome "Cannot change ownership" bug
    # on NFS-mounted filesystem
    execute "tar --no-same-owner -zxf #{nodejs_tar}" do
        cwd "#{chef_cache}"
    end

    bash 'compile node.js' do
        cwd build_dir
        code <<-EOH
            ./configure
            make
        EOH
    end

    execute 'nodejs make temp install' do
        cwd build_dir
        command 'make install DESTDIR=./install'
    end

    execute "build #{package_file}" do
        cwd build_dir
        command "fpm -s dir -t #{node[:fpm][:package_type]} -n nodejs -v #{version} -p #{package_file} -C install ."
    end
end

package 'nodejs' do
    action :install
    source package_file
    provider node[:fpm][:provider]
end
