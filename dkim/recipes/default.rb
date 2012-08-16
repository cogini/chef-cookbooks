#
# Cookbook Name:: mail
# Recipe:: dkim
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#


package node[:dkim][:package] do
    action :install
end

template node[:dkim][:config] do
    source 'opendkim.conf.erb'
end


service node[:dkim][:service] do
    action [:enable, :restart]
end


selector = node[:dkim][:selector]

bash 'dkim genkey' do
    code <<-EOBASH
        mkdir -p /etc/mail
        cd /etc/mail
        #{node[:dkim][:genkey]} -s #{selector} -d #{node[:dkim][:domains][0]}
    EOBASH
    not_if { File.exists?("/etc/mail/#{selector}.private") }
end
