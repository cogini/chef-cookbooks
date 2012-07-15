#
# Cookbook Name:: basics
# Recipe:: redhat
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#

include_recipe "yum::epel"

# Default shared memory is too low to be useful
template "/etc/sysctl.conf" do
    mode "0644"
    source "redhat-sysctl.conf.erb"
end

node.basics.epel_packages.each do |pkg|
    package pkg do
        unless node.basics.package_mask.include?(pkg)
            action :install
            options '--enablerepo=epel'
        else
            action :remove
        end
    end
end
