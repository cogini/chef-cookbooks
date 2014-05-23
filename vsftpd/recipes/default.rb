#
# Cookbook Name:: vsftpd
# Recipe:: default
#
# Copyright 2010, Robert J. Berger
#
# Apache License, Version 2.0
#

package "vsftpd"

service "vsftpd" do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end


template "/etc/vsftpd.chroot_list" do
  mode 0644
end

template "/etc/vsftpd.conf" do
  mode 0644
  notifies :restart, 'service[vsftpd]', :delayed
end

