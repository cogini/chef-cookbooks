#
# Cookbook Name:: nagios
# Recipe:: redhat
#
# Copyright 2012, Cogini
#

include_recipe 'yum::epel'


%w{ nagios-nrpe nagios-plugins-all nagios-plugins-check-updates }.each do |pkg|
    package pkg do
        action :install
    end
end
