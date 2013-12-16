#
# Cookbook Name:: supervisor
# Recipe:: default
#
# Copyright 2012, Cogini
#

package_from_url "http://packages.cogini.com/supervisor-#{node[:supervisor][:version]}-noarch.rpm"

template '/etc/init.d/supervisord' do
    mode '755'
end

template '/etc/supervisord.conf' do
    mode '644'
    notifies :reload, 'service[supervisord]'
end

service 'supervisord' do
    supports :status => true, :restart => true, :reload => true
    action [ :enable, :start ]
end
