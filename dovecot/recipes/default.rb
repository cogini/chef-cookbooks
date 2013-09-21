#
# Cookbook Name:: dovecot
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

node[:dovecot][:packages].each do |pkg|
    package pkg
end


template '/etc/dovecot/dovecot.conf' do
    source 'dovecot.conf.erb'
    owner 'root'
    group 'dovecot'
    mode '640'
end

template '/etc/dovecot/dovecot-sql.conf' do
    source 'dovecot-sql.conf.erb'
    owner 'root'
    group 'dovecot'
    mode '640'
end

template '/etc/dovecot/conf.d/10-master.conf' do
    source 'dovecot-10-master.conf.erb'
    owner 'root'
    group 'dovecot'
    mode '640'
end

template '/etc/dovecot/conf.d/10-ssl.conf' do
    source 'dovecot-10-ssl.conf.erb'
    owner 'root'
    group 'dovecot'
    mode '640'
end
