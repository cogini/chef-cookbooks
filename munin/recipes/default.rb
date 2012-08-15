#
# Cookbook Name:: munin
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w{ munin-node munin-plugins-extra}.each do |pkg|
    package pkg do
        action :install
    end
end

service "munin-node" do
    action [:start, :enable]
    supports :restart => true
end

template "/etc/munin/munin-node.conf" do
    mode "0644"
    source "munin-node.conf.erb"
    notifies :restart, "service[munin-node]"
end
