#
# Cookbook Name:: nagios
# Recipe:: ubuntu
#
# Copyright 2012, Cogini
#

%w{ nagios-nrpe-server nagios-plugins }.each do |pkg|
    package pkg do
        action :install
    end
end


%w{ check_reboot check_updates }.each do |plugin|
    template "#{node[:nagios][:plugin_dir]}/#{plugin}" do
        source "ubuntu-#{plugin}.erb"
        mode '775'
    end
end
