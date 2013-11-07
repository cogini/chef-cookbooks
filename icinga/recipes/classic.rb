#
# Cookbook Name:: icinga
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'mysql::server'


apt_repository 'icinga' do
    uri 'http://ppa.launchpad.net/formorer/icinga/ubuntu'
    distribution node['lsb']['codename']
    components ['main']
    keyserver 'keyserver.ubuntu.com'
    key '36862847'
end


%w{
    icinga
    icinga-doc
    libdbd-mysql
}.each do |p|
    package p
end


# This bad guy asks for DB config
package 'icinga-idoutils' do
    response_file 'icinga-idoutils.seed'
end

username = node[:icinga][:ido_db][:username]
password = node[:icinga][:ido_db][:password]
database = node[:icinga][:ido_db][:database]

mysql_user username do
    password password
end

mysql_db database do
    owner username
end

execute 'icinga-initialize-db' do
    command "mysql -u#{username} -p#{password} #{database} < /usr/share/doc/icinga-idoutils/examples/mysql/mysql.sql"
    only_if { `echo 'show tables' | mysql -u#{username} -p#{password} #{database}`.empty? }
end


service 'ido2db' do
    action :nothing
end

service 'icinga' do
    action :nothing
end


template '/etc/default/icinga' do
    source '_etc_default_icinga.erb'
    mode '644'
    notifies :restart, 'service[ido2db]'
end

template '/etc/icinga/modules/idoutils.cfg' do
    mode '644'
    notifies :restart, 'service[icinga]'
end

template '/etc/icinga/ido2db.cfg' do
    mode '644'
    notifies :restart, 'service[ido2db]'
end
