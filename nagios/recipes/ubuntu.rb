#
# Cookbook Name:: nagios
# Recipe:: ubuntu
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#

%w{nagios-nrpe-server nagios-plugins}.each do |pkg|
    package pkg do
        action :install
    end
end
