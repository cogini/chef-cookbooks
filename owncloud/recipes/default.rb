include_recipe 'apt'
include_recipe 'build-essential'
include_recipe 'git'
include_recipe 'nginx'
include_recipe 'php::fpm'
include_recipe 'php::module_apc'
include_recipe 'php::module_curl'
include_recipe 'php::module_gd'
include_recipe 'php::module_intl'
include_recipe 'php::module_pgsql'
include_recipe 'postgresql::client'

owncloud = node[:owncloud]
app_user = owncloud[:app_user]
site_dir = owncloud[:site_dir]
log_dir = owncloud[:log_dir]
db = owncloud[:db]

owncloud[:dependencies].each do |pkg|
    package pkg
end

user app_user do
    home "/home/#{app_user}"
    shell '/bin/bash'
    supports :manage_home => true
    action :create
end

directory log_dir do
    action :create
    recursive true
end

directory site_dir do
    action :create
    recursive true
    owner app_user
    group app_user
end

git 'Clone owncloud' do
    destination site_dir
    enable_submodules true
    reference owncloud[:version]
    repository 'https://github.com/owncloud/core.git'
    user app_user
end

if db[:host] == 'localhost'

    include_recipe 'postgresql::server'
    db_user = db[:user]

    postgresql_user db_user do
        password db[:password]
    end

    postgresql_database db[:database] do
        owner db_user
    end
end

%w{config data apps}.each do |component|
    dir = "#{site_dir}/#{component}"
    directory dir do
        action :create
        recursive true
        owner 'www-data'
        mode '770'
    end

    execute 'Set permission' do
        command "chown -R www-data:www-data #{dir}"
    end
end

template "#{site_dir}/../set_env.sh" do
    mode '644'
end

template '/etc/nginx/sites-available/owncloud' do
    source 'nginx-site.erb'
    mode '644'
    notifies :reload, 'service[nginx]'
end

template '/etc/logrotate.d/owncloud' do
    source 'logrotate.erb'
    mode '644'
end

nginx_site 'default' do
    action :disable
end

nginx_site 'owncloud' do
    action :enable
end
