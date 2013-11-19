#
# Cookbook Name:: shorewall
# Recipe:: default
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#


unless node[:shorewall][:interfaces]
    raise 'node[:shorewall][:interfaces] is required.'
end


case node[:platform]
when 'centos', 'redhat'
    include_recipe 'shorewall::redhat'
when 'ubuntu'
    include_recipe 'shorewall::ubuntu'
end


%w{ rules zones interfaces policy }.each do |t|
    template "/etc/shorewall/#{t}" do
        mode '644'
        notifies 'service[shorewall]'
    end
end
