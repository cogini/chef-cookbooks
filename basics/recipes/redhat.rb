#
# Cookbook Name:: basics
# Recipe:: redhat
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#

execute 'chkconfig --level 2345 atop on' do
    action :run
    only_if { File.exists?('/etc/init.d/atop') }
end


# Default shared memory is too low to be useful
template '/etc/sysctl.conf' do
    mode '0644'
    source 'redhat-sysctl.conf.erb'
end


include_recipe 'yum::epel'

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


# Unlock port 1022
package 'policycoreutils-python'

execute 'semanage port -a -t ssh_port_t -p tcp 1022'
