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

package "dovecot-#{node[:dovecot][:db][:driver]}"


service 'dovecot' do
    action :nothing
end


%w{
    /etc/dovecot/conf.d/10-auth.conf
    /etc/dovecot/conf.d/10-master.conf
    /etc/dovecot/conf.d/10-ssl.conf
    /etc/dovecot/dovecot-sql.conf
    /etc/dovecot/dovecot.conf
}.each do |t|
    template t do
        owner 'root'
        group 'dovecot'
        mode '640'
        notifies :reload, 'service[dovecot]'
    end
end
