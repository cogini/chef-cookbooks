include_recipe 'icinga::classic'


package 'icinga-idoutils' do
    response_file 'icinga-idoutils.seed'
end


username = node[:icinga][:ido_db][:username]
password = node[:icinga][:ido_db][:password]
database = node[:icinga][:ido_db][:database]

mysql_user username do
    password password
end

mysql_db database do
    owner username
end

execute "initialize #{database}" do
    command "mysql -u#{username} -p#{password} #{database} < /usr/share/dbconfig-common/data/icinga-idoutils/install/mysql"
    only_if { `echo 'show tables' | mysql -u#{username} -p#{password} #{database}`.empty? }
end


service 'ido2db' do
    action [:enable, :start]
end


template '/etc/default/icinga' do
    source 'etc-default-icinga.erb'
    mode '644'
    notifies :restart, 'service[ido2db]'
    notifies :restart, 'service[icinga]'
end

template '/etc/icinga/modules/idoutils.cfg' do
    mode '644'
    notifies :restart, 'service[icinga]'
end

template '/etc/icinga/ido2db.cfg' do
    mode '644'
    notifies :restart, 'service[ido2db]'
end
