include_recipe "apt"
include_recipe "postgresql::client"
include_recipe "git"
include_recipe "nginx"


app_user = node[:chili][:app_user]
site_dir = node[:chili][:site_dir]
db = node[:chili][:db]
version = node[:chili][:version]

if db[:host] == "localhost"

    include_recipe "postgresql::server"
    db_user = db[:user]

    postgresql_user db_user do
        password db[:password]
    end

    postgresql_database db[:database] do
        owner db_user
    end
end


node[:chili][:dependencies].each do |pkg|
    package pkg
end


user app_user do
    home "/home/#{app_user}"
    shell "/bin/bash"
    supports :manage_home => true
end


git "Clone chili #{version}" do
    repository "https://github.com/chiliproject/chiliproject.git"
    destination site_dir
    reference version
    user app_user
end

node[:chili][:required_gems].each do |gem|
    ruby_block "Add missing gem" do
        block do
            file = Chef::Util::FileEdit.new("#{site_dir}/Gemfile")
            file.insert_line_if_no_match("#{gem}", "gem '#{gem}'")
            file.write_file
        end
    end
end


execute "gem install bundler" do
    cwd site_dir
end


template "#{site_dir}/../set_env.sh" do
    mode 0644
    source "set_env.sh.erb"
end


%w{
    database.yml
    configuration.yml
    unicorn.rb
}.each do |config_file|
    template "#{site_dir}/config/#{config_file}" do
        mode '644'
        owner app_user
    end
end


template "/etc/init.d/chili" do
    mode 0755
    source "init-chili.erb"
    notifies :reload, "service[chili]"
end


execute "Install required gems" do
    command "bundle install --without development test mysql mysql2 sqlite"
    cwd site_dir
end


execute "Generate a session store secret" do
    command "bundle exec rake generate_session_store"
    cwd site_dir
    environment({ "HOME" => "/home/#{app_user}" })
    user app_user
end


execute "Create database structure" do
    command "bundle exec rake db:migrate db:migrate:plugins RAILS_ENV=production"
    cwd site_dir
    environment({ "HOME" => "/home/#{app_user}" })
    user app_user
end


bash "Set permissions" do
    cwd site_dir
    code <<-EOH
        mkdir -p public/plugin_assets tmp/sockets
        chown -R #{app_user}:#{app_user} files log tmp public/plugin_assets
        chmod -R 0755 files log tmp public/plugin_assets
    EOH
end


# FIXME: temporary fix for chili 3.8.0
template "#{site_dir}/app/models/document.rb" do
    mode 0644
    source 'document.rb.erb'
    owner app_user
end

service "chili" do
    supports :restart => true, :status => true, :reload => true
    action [:enable, :start]
end


template '/etc/nginx/sites-available/chili.cogini.com' do
    mode 0644
    source 'nginx-chili.erb'
    notifies :reload, 'service[nginx]'
end

nginx_site "chili.cogini.com" do
    action :enable
end


template '/etc/logrotate.d/chili' do
    mode '644'
    source 'logrotate.conf.erb'
end
