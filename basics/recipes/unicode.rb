#
# Cookbook Name:: basics
# Recipe:: unicode
#
# Copyright 2012, Cogini
#


case node[:platform]


when 'ubuntu'

    execute 'locale-gen' do
        action :nothing
    end

    file '/etc/default/locale' do
        mode '644'
        content 'LANG="en_US.UTF-8"'
        notifies :run, 'execute[locale-gen]'
    end


when 'redhat', 'centos', 'amazon'

    file '/etc/sysconfig/i18n' do
        mode '644'
        content 'LANG="en_US.UTF-8"'
    end

end
