#
# Cookbook Name: gitlab
# Recipe: default
#

include_recipe "apt"
include_recipe "build-essential"
include_recipe "postfix::vanilla"
include_recipe "nginx"
include_recipe "postgresql::client"
include_recipe "python"
include_recipe "git::ppa"


if node[:gitlab][:dbHost] == "localhost"

    include_recipe "postgresql::server"
    db_user = node[:gitlab][:dbUsername]

    postgresql_user db_user do
      password node[:gitlab][:dbPassword]
    end

    postgresql_database node[:gitlab][:dbName] do
      owner db_user
    end
end


git_user = node[:gitlab][:git_user][:name]
git_home = node[:gitlab][:git_user][:home]
gitlab_version = node[:gitlab][:version]
gitlab_shell_dir = node[:gitlab][:shell][:dir]
gitlab_shell_version = node[:gitlab][:shell][:version]
gitlab_dir = node[:gitlab][:dir]
satellites_path = node[:gitlab][:satellites_path]
repos_path = node[:gitlab][:repos_path]


# Stop service gitlab if already installed
if File.exist?('/etc/init.d/gitlab')
  service 'gitlab' do
    action :stop
    ignore_failure true
  end
end

node[:gitlab][:dependencies].each do |pkg|
  package pkg do
    action :install
  end
end


# Install bundler gem
bash "install gems" do
  code <<-EOH
    gem install bundler
    gem install charlock_holmes --version '0.6.9.4'
  EOH
end


# Create users for Git
user git_user do
  system true
  shell node[:gitlab][:git_user][:shell]
  comment "GitLab"
  home git_home
  supports :manage_home => true
end


# Install gitlab shell
git "Clone gitlab-shell #{gitlab_shell_version}" do
    repository "https://github.com/gitlabhq/gitlab-shell.git"
    destination gitlab_shell_dir
    reference gitlab_shell_version
    user git_user
end

template "#{gitlab_shell_dir}/config.yml" do
    source "gitlab-shell-config.yml.erb"
    owner git_user
    group git_user
end

execute "Install gitlab-shell" do
  user git_user
  cwd gitlab_shell_dir
  command "#{gitlab_shell_dir}/bin/install"
end


git "Clone gitlab #{gitlab_version}" do
    repository "https://github.com/gitlabhq/gitlabhq.git"
    destination gitlab_dir
    reference gitlab_version
    user git_user
end


bash "Change directories ownership" do
  code <<-EOH
    chown -R #{git_user}:#{git_user} #{gitlab_shell_dir}
    chown -R #{git_user}:#{git_user} #{gitlab_dir}
  EOH
end


%w{ gitlab.yml unicorn.rb }.each do |item|
  template "#{gitlab_dir}/config/#{item}" do
    source "#{item}.erb"
    owner git_user
    group git_user
  end
end


remote_file "#{gitlab_dir}/config/initializers/rack_attack.rb" do
  source "https://raw.githubusercontent.com/gitlabhq/gitlabhq/#{gitlab_version}/config/initializers/rack_attack.rb.example"
  owner git_user
  group git_user
  mode '644'
end


template "#{gitlab_dir}/config/database.yml" do
  source "database.yml.erb"
  owner git_user
  group git_user
  mode '600'
end


if node[:gitlab][:sidekiq][:concurrency]
  template "#{gitlab_dir}/config/initializers/4_sidekiq.rb" do
    source "4_sidekiq.rb.erb"
    owner git_user
    group git_user
    mode '644'
  end
end


bash "Change permission to let gitlab write to the log/ and tmp/ directories" do
  cwd gitlab_dir
  code <<-EOH
    chown -R #{git_user}:#{git_user} log/
    chown -R #{git_user}:#{git_user} tmp/
    chmod -R u+rwX log/
    chmod -R u+rwX tmp/
  EOH
end


bash "Change mode repositories" do
  cwd gitlab_dir
  code <<-EOH
    chown -R #{git_user}:#{git_user} #{repos_path}
    chmod -R ug+rwX,o-rwx #{repos_path}
    find #{repos_path} -type d -print0 | xargs -0 chmod g+s
  EOH
end


[
  "#{satellites_path}",
  "#{gitlab_dir}/tmp/pids",
  "#{gitlab_dir}/tmp/sockets",
  "#{gitlab_dir}/public/uploads",
].each do |dir|
  directory dir do
    owner git_user
    group git_user
    mode '755'
    action :create
    recursive true
  end
end

execute "bundle install" do
  cwd gitlab_dir
  command "bundle install --deployment --without development test mysql aws"
  action :run
end

bash "git config" do
  user git_user
  cwd git_home
  environment({"HOME" => git_home})
  code <<-EOH
    git config --global user.name "GitLab"
    git config --global user.email "gitlab@localhost"
    git config --global core.autocrlf input
  EOH
end


# Initialize DB and activate advanced features
execute "bundle exec rake gitlab:setup RAILS_ENV=production" do
  user git_user
  cwd gitlab_dir
  command "yes yes | bundle exec rake gitlab:setup RAILS_ENV=production && touch .gitlab-setup"
  action :run
  not_if { File.exists?("#{gitlab_dir}/.gitlab-setup") }
end

# Update DB in case updating to newer version
execute "bundle exec rake db:migrate RAILS_ENV=production" do
  user git_user
  cwd gitlab_dir
end


remote_file "/etc/init.d/gitlab" do
  source "https://raw.github.com/gitlabhq/gitlabhq/#{gitlab_version}/lib/support/init.d/gitlab"
  mode '755'
end


service "gitlab" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

# Config nginx
template "/etc/nginx/sites-available/gitlab" do
  source "nginx-gitlab.erb"
end

nginx_site "gitlab" do
  action :enable
end

nginx_site "default" do
  action :disable
end

service "nginx" do
  action [ :enable, :restart ]
end


template '/etc/logrotate.d/gitlab' do
    source 'logrotate.erb'
    mode '644'
end
