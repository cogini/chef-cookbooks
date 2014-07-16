#
# Cookbook Name:: graphite
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package 'graphite-carbon'
package 'graphite-web'

template '/etc/default/graphite-carbon' do
    mode '644'
    notifies :restart, 'service[carbon-cache]'
end

service 'carbon-cache' do
    action [:enable, :start]
end
