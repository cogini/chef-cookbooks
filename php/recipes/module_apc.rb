#
# Author::  Joshua Timberman (<joshua@opscode.com>)
# Author::  Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: php
# Recipe:: module_apc
#
# Copyright 2009-2011, Opscode, Inc.
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

case node[:platform_family]
when "rhel", "fedora"
    %w{ httpd-devel pcre pcre-devel }.each do |pkg|
        package pkg do
            action :install
        end
    end
when "debian"
    package "libpcre3-dev"
else
    raise NotImplementedError
end

# Use PEAR package instead of distro-provided package because sometimes
# they cause PHP to hang
php_pear "apc" do
    directives node[:php][:apc]
    if File.file?(node[:php][:fpm_config])
        notifies :restart, "service[#{node[:php][:fpm_service]}]"
    end
end
