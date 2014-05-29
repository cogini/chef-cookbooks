#
# Cookbook Name:: shorewall
# Recipe:: default
#
# Copyright 2012, Cogini
#


unless node[:shorewall][:interfaces]
    raise 'node[:shorewall][:interfaces] is required.'
end


# Be safe and check for obsoleted attributes
if node[:shorewall][:allowed_connections] or
    node[:shorewall][:allowed_services]
    raise
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
        notifies :restart, 'service[shorewall]'
    end
end

service 'shorewall' do
    action [:enable, :start]
end
