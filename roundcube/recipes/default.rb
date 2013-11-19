#
# Cookbook Name:: roundcube
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'nginx'
include_recipe 'php::module_sqlite3'
include_recipe 'php::module_mcrypt'
include_recipe 'php::module_intl'
include_recipe 'php::module_curl'
include_recipe 'php::fpm'


[
    node[:roundcube][:log_dir],
    "#{node[:roundcube][:site_dir]}/temp",
    File.dirname(node[:roundcube][:db][:sqlite]),
].each do |dir|
    directory dir do
        action :create
        recursive true
        owner 'www-data'
    end
end

%w{ main db }.each do |config|
    template "#{node[:roundcube][:site_dir]}/config/#{config}.inc.php" do
        source "#{config}.inc.php.erb"
        mode '644'
    end
end


site = node[:roundcube][:server_name]

template "/etc/nginx/sites-available/#{site}" do
    source 'nginx-site.erb'
    mode '644'
    notifies :reload, 'service[nginx]'
end

nginx_site site do
    action :enable
end


template "/etc/logrotate.d/#{site}" do
    mode '644'
    source 'logrotate.erb'
end
