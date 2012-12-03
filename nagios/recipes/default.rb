#
# Cookbook Name:: nagios
# Recipe:: default
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#

include_recipe node[:nagios][:recipe]


Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
node.set_unless[:nagios][:mysql][:password] = secure_password
node.set_unless[:nagios][:pgsql][:password] = secure_password


mysql_config = node[:nagios][:mysql]
if mysql_config[:enable] and mysql_config[:host] == 'localhost'
    mysql_user mysql_config[:username] do
        action :create
        password mysql_config[:password]
    end
end

pgsql_config = node[:nagios][:pgsql]
if pgsql_config[:enable] and pgsql_config[:host] == 'localhost'
    pgsql_user pgsql_config[:username] do
        action :create
        password pgsql_config[:password]
    end
end


nrpe_service = node[:nagios][:service]

service nrpe_service do
    action [:start, :enable]
    supports :restart => true
end

template '/etc/nagios/nrpe.cfg' do
    source 'nrpe.cfg.erb'
    notifies :restart, "service[#{nrpe_service}]"
end


unless node[:platform] == 'ubuntu' && node[:platform_version].to_f <= 8.04
    include_recipe 'logwarn'
end
