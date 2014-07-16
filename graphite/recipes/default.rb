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


include_recipe 'apache2::mod_wsgi'

template '/etc/apache2/sites-available/graphite-web.conf' do
    mode '644'
    notifies :restart, 'service[apache2]'
end

apache_site 'graphite-web.conf'

apache_site '000-default.conf' do
    action :disable
end
