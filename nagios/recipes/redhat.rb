#
# Cookbook Name:: nagios
# Recipe:: redhat
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#

include_recipe "yum::epel"

%w{nagios-nrpe nagios-plugins-all}.each do |pkg|
    package pkg do
        action :install
    end
end
