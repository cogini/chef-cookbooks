#
# Cookbook Name:: basics
# Recipe:: hostname
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#

hostname = node[:new_hostname]
fqdn = node[:new_fqdn]


case node[:platform]

when 'redhat', 'centos', 'amazon'
    template '/etc/sysconfig/network' do
        mode '0644'
        source 'redhat-sysconfig-network.erb'
    end

when 'ubuntu'

    file '/etc/hostname' do
        mode '0644'
        content hostname
    end

    # Some programs read from mailname
    file '/etc/mailname' do
        mode '0644'
        content fqdn
    end
end

execute 'hostname' do
    command "hostname #{hostname}"
end


# To make the host know about itself
template '/etc/hosts' do
    source 'hosts.erb'
    mode '0644'
end
