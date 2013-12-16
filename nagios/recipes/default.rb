#
# Cookbook Name:: nagios
# Recipe:: default
#
# Copyright 2012, Cogini
#

include_recipe node[:nagios][:recipe]


Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
node.set_unless[:nagios][:mysql][:password] = secure_password
node.set_unless[:nagios][:pgsql][:password] = secure_password


mysql_config = node[:nagios][:mysql]
if mysql_config[:enable] and mysql_config[:host] == 'localhost'
    mysql_user mysql_config[:username] do
        action :create
        password mysql_config[:password]
    end
end


pgsql = node[:nagios][:pgsql]

if pgsql[:enable]

    git "#{node[:nagios][:plugin_dir]}/check_postgres" do
        repository "https://github.com/bucardo/check_postgres.git"
    end

    if pgsql[:host] == 'localhost' and not node[:postgresql][:is_slave]
        postgresql_user pgsql[:username] do
            action :create
            password pgsql[:password]
        end
    end
end


nrpe_service = node[:nagios][:service]

service nrpe_service do
    action [:start, :enable]
    supports :restart => true
end

template '/etc/nagios/nrpe.cfg' do
    source 'nrpe.cfg.erb'
    notifies :restart, "service[#{nrpe_service}]"
end

file '/etc/nagios/nrpe_local.cfg' do
    content node[:nagios][:nrpe_local_config].join("\n")
end
