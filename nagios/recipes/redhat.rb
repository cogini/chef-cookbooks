#
# Cookbook Name:: nagios
# Recipe:: redhat
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'yum::epel'

%w{ nagios-nrpe nagios-plugins-all }.each do |pkg|
    package pkg do
        action :install
    end
end

%w{ check_updates }.each do |plugin|
    template "#{plugin_dir}/#{plugin}" do
        source "redhat-#{plugin}.erb"
        mode '0775'
    end
end
