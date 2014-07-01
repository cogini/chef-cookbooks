#
# Cookbook Name:: mail
# Recipe:: dkim
#
# Copyright 2012, Cogini
#


dkim = node[:dkim]
dkim_service = node[:dkim][:service]
selector = node[:dkim][:selector]
key_dir = node[:dkim][:key_dir]


dkim[:packages].each do |pkg|
    package pkg do
        action :install
    end
end


service dkim_service do
    action [:enable, :start]
end


template dkim[:config] do
    source 'opendkim.conf.erb'
    notifies :restart, "service[#{dkim_service}]"
end


directory key_dir do
    recursive true
end

execute "#{dkim[:genkey]} -s #{selector} -d #{dkim[:domains][0]}" do
    cwd key_dir
    not_if { File.exists?("#{key_dir}/#{selector}.private") }
end
