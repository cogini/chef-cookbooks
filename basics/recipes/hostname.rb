#
# Cookbook Name:: basics
# Recipe:: hostname
#
# Copyright 2012, Cogini
#

hostname = node[:new_hostname]
fqdn = node[:new_fqdn]


case node[:platform]


when 'redhat', 'centos', 'amazon'

    unless node[:network][:gateway]
        raise 'node[:network][:gateway] is required.'
    end

    template '/etc/sysconfig/network' do
        mode '644'
        source 'redhat-sysconfig-network.erb'
    end


when 'ubuntu'

    file '/etc/hostname' do
        mode '644'
        content hostname
    end

    # Some programs read from mailname
    file '/etc/mailname' do
        mode '644'
        content fqdn
    end
end


execute 'hostname' do
    command "hostname #{hostname}"
    not_if { node[:hostname] == hostname and node[:fqdn] == fqdn }
end


# To make the host know about itself
template '/etc/hosts' do
    source 'hosts.erb'
    mode '644'
end
