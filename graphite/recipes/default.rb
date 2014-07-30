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


db = node[:graphite][:db]

if db[:engine] == 'mysql'

    include_recipe 'mysql::client'
    package 'python-mysqldb'

    if db[:host] == 'localhost'

        include_recipe 'mysql::server'

        mysql_user db[:user] do
            password db[:password]
        end

        mysql_db db[:name] do
            owner db[:user]
        end
    end
end

template '/etc/graphite/local_settings.py' do
    owner '_graphite'
    mode '600'
    notifies :restart, 'service[apache2]'
end

template '/etc/carbon/storage-schemas.conf' do
    mode '644'
    notifies :restart, 'service[apache2]'
end


include_recipe 'apache2::mod_wsgi'

template '/etc/apache2/sites-available/graphite-web.conf' do
    mode '644'
    notifies :restart, 'service[apache2]'
end

node[:graphite][:users].each do |u,p|
    htpasswd node[:graphite][:auth_user_file] do
        user u
        password p
    end
end

apache_site 'graphite-web.conf'

apache_site '000-default.conf' do
    action :disable
end
