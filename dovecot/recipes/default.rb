#
# Cookbook Name:: dovecot
# Recipe:: default
#
# Copyright 2013, Cogini
#


node[:dovecot][:packages].each do |pkg|
    package pkg
end

package "dovecot-#{node[:dovecot][:db][:driver]}"


# For now we take this to mean "enable sieve"
if node[:dovecot][:enable_sieve]

    unless node[:postfix][:virtual_transport] == 'dovecot'
        raise 'node[:postfix][:virtual_transport] must be set to "dovecot".'
    end

    package 'dovecot-managesieved'

    template '/etc/dovecot/conf.d/15-lda.conf' do
        mode '644'
        notifies :reload, 'service[dovecot]'
    end
end


service 'dovecot' do
    action :nothing
end


%w{
    /etc/dovecot/conf.d/10-auth.conf
    /etc/dovecot/conf.d/10-master.conf
    /etc/dovecot/conf.d/10-ssl.conf
    /etc/dovecot/dovecot.conf
}.each do |t|
    template t do
        mode '644'
        notifies :reload, 'service[dovecot]'
    end
end

# This file may contain passwords and should be protected
template '/etc/dovecot/dovecot-sql.conf' do
    mode '600'
    notifies :reload, 'service[dovecot]'
end
