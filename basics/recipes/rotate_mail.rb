#
# Cookbook Name:: main
# Recipe:: rotate_mail
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#

old_mail_dir = '/var/mail/old'

directory old_mail_dir do
    action :create
    recursive true
end

template '/etc/logrotate.d/old-mail' do
    mode '0644'
    source 'logrotate-mail.erb'
    variables({
        :old_mail_dir => old_mail_dir,
    })
end
