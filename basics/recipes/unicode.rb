#
# Cookbook Name:: basics
# Recipe:: unicode
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#


case node[:platform]

when 'ubuntu'
    file '/etc/default/locale' do
        mode '0644'
        content 'LANG="en_US.UTF-8"'
    end

    execute 'locale' do
        command 'locale-gen'
    end

when 'redhat', 'centos', 'amazon'
    file '/etc/sysconfig/i18n' do
        mode '0644'
        content 'LANG="en_US.UTF-8"'
    end
end
