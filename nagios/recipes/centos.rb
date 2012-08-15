#
# Cookbook Name:: nagios
# Recipe:: default
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#

include_recipe "yum::epel"


yum_repo :epel do
    action :enable
end

%w{nagios-nrpe nagios-plugins-all}.each do |pkg|
    package pkg do
        action :install
    end
end

yum_repo :epel do
    action :disable
end
