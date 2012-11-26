#
# Cookbook Name:: nagios
# Recipe:: ubuntu
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#

%w{nagios-nrpe-server nagios-plugins}.each do |pkg|
    package pkg do
        action :install
    end
end


plugin_dir = node[:nagios][:plugin_dir]

directory plugin_dir do
    action :create
    recursive true
end

template "#{plugin_dir}/check_reboot" do
    source 'check_reboot'
    mode '0775'
end
