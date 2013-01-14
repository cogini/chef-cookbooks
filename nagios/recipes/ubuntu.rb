#
# Cookbook Name:: nagios
# Recipe:: ubuntu
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#

%w{ nagios-nrpe-server nagios-plugins }.each do |pkg|
    package pkg do
        action :install
    end
end


plugin_dir = node[:nagios][:plugin_dir]

directory plugin_dir do
    action :create
    recursive true
end

%w{ check_reboot check_updates }.each do |plugin|
    template "#{plugin_dir}/#{plugin}" do
        source "ubuntu-#{plugin}.erb"
        mode '0775'
    end
end
