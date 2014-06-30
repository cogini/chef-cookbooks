include_recipe 'icinga::idoutils'
include_recipe 'php'
include_recipe 'php::module_xmlrpc'
include_recipe 'php::module_gd'
include_recipe 'php::module_ldap'
include_recipe 'php::module_mysql'
include_recipe 'php::module_xsl'


apt_repository 'icinga-web' do
    uri 'http://ppa.launchpad.net/formorer/icinga-web/ubuntu'
    distribution node['lsb']['codename']
    components ['main']
    keyserver 'keyserver.ubuntu.com'
    key '36862847'
end

package 'icinga-web' do
    response_file 'icinga-web.seed'
end


# Needed by config file but not created by package
directory '/etc/icinga/conf.d'

# Fix path for some missing logos
link '/usr/share/icinga/htdocs/images/logos/base' do
    to '/usr/share/nagios/htdocs/images/logos/base'
end


username = node[:icinga][:web_db][:username]
password = node[:icinga][:web_db][:password]
database = node[:icinga][:web_db][:database]

mysql_user username do
    password password
end

mysql_db database do
    owner username
end

execute "initialize #{database}" do
    command "mysql -u#{username} -p#{password} #{database} < /usr/share/dbconfig-common/data/icinga-web/install/mysql"
    only_if { `echo 'show tables' | mysql -u#{username} -p#{password} #{database}`.empty? }
end


execute 'icinga-clear-cache' do
    command '/usr/lib/icinga-web/bin/clearcache.sh'
    action :nothing
end

%w{ ido web }.each do |db|
    template "/etc/icinga-web/conf.d/database-#{db}.xml" do
        group 'www-data'
        mode '640'
        notifies :restart, 'service[icinga]'
        notifies :run, 'execute[icinga-clear-cache]'
    end
end

template '/etc/icinga/icinga.cfg' do
    mode '644'
    notifies :restart, 'service[icinga]'
end
