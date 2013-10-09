#
# Cookbook Name:: mail
# Recipe:: dkim
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#


dkim_service = node[:dkim][:service]
selector = node[:dkim][:selector]


node[:dkim][:packages].each do |pkg|
    package pkg do
        action :install
    end
end


service dkim_service do
    action [:enable, :start]
    supports :reload => true, :restart => true, :status => true
end


template node[:dkim][:config] do
    source 'opendkim.conf.erb'
    notifies :reload, resources(:service => dkim_service)
end

template "/etc/default/opendkim" do
    source "etc_default_opendkim.erb"
    notifies :reload, resources(:service => dkim_service)
end


bash 'dkim genkey' do
    code <<-EOBASH
        mkdir -p /etc/mail
        cd /etc/mail
        #{node[:dkim][:genkey]} -s #{selector} -d #{node[:dkim][:domains][0]}
    EOBASH
    not_if { File.exists?("/etc/mail/#{selector}.private") }
end
