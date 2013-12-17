#
# Cookbook Name:: icinga
# Recipe:: default
#
# Copyright 2013, Cogini
#

include_recipe 'mysql::server'


apt_repository 'icinga' do
    uri 'http://ppa.launchpad.net/formorer/icinga/ubuntu'
    distribution node['lsb']['codename']
    components ['main']
    keyserver 'keyserver.ubuntu.com'
    key '36862847'
end


%w{
    icinga
    icinga-doc
    libdbd-mysql
    nagios-images
}.each do |p|
    package p
end


# Fix path for some missing logos
link '/usr/share/icinga/htdocs/images/logos/base' do
    to '/usr/share/nagios/htdocs/images/logos/base'
end


service 'icinga' do
    action [:enable, :start]
end
