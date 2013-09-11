include_recipe "apt"
include_recipe "git"


app_user = node[:chili][:app_user]
site_dir = node[:chili][:site_dir]
db = node[:chili][:db]
version = node[:chili][:version]


case db[:adapter]
when "mysql"
    excluded_gems = %w{
        postgres
        sqlite
    }

    include_recipe "mysql::client"

    if db[:host] == "localhost"
        include_recipe "mysql::server"
        db_user = db[:user]

        mysql_user db_user do
            password db[:password]
        end

        mysql_db db[:database] do
            owner db_user
        end
    end

when "postgresql"
    excluded_gems = %w{
        mysql
        mysql2
        sqlite
    }

    include_recipe "postgresql::client"

    if db[:host] == "localhost"
        include_recipe "postgresql::server"
        db_user = db[:user]

        pgsql_user db_user do
            password db[:password]
        end

        pgsql_db db[:database] do
            owner db_user
        end
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


bash "Clone chili" do
    user app_user
    environment({ "HOME" => "/home/#{app_user}" })
    code <<-EOH
        [[ -d #{site_dir} ]] || git clone git://github.com/chiliproject/chiliproject.git #{site_dir}
        cd #{site_dir}
        git fetch
        git checkout -f #{version}
    EOH
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


%w{
    database.yml
    configuration.yml
    unicorn.rb
}.each do |config_file|
    template "#{site_dir}/config/#{config_file}" do
        mode 0644
        owner app_user
        source "#{config_file}.erb"
    end
end


template "/etc/init.d/chili" do
    mode 0755
    source "init-chili.erb"
end


execute "Install required gems" do
    command "bundle install --without development test #{excluded_gems.join(' ')}"
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


service "chili" do
    supports :start => true, :stop => true, :restart => true, :status => true, :reload => true
    action [ :enable, :restart ]
end


site_name = node[:chili][:site_name]

case node[:chili][:web_server]
when "nginx"
    include_recipe "nginx"

    template "/etc/nginx/sites-available/#{site_name}" do
        mode 0644
        source "nginx-chili.erb"
    end

    nginx_site "#{site_name}" do
        action :enable
    end

when "apache"
    include_recipe "apache2"
    include_recipe "apache2::mod_rewrite"
    include_recipe "apache2::mod_proxy"
    include_recipe "apache2::mod_proxy_http"
    include_recipe "apache2::mod_proxy_balancer"

    template "/etc/apache2/sites-available/#{site_name}" do
        mode 0644
        source "apache-chili.erb"
    end

    apache_site "#{site_name}" do
        action :enable
    end
end
