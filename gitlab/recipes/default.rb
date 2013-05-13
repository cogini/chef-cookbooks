#
# Cookbook Name: gitlab
# Recipe: default
#

include_recipe "apt"
include_recipe "build-essential"
include_recipe "postfix::vanilla"
include_recipe "git"
include_recipe "nginx"
include_recipe "postgresql::client"
# XXX Do we really need python?
include_recipe "python"

if node[:gitlab][:dbHost] == "localhost"

    include_recipe "postgresql::server"
    db_user = node[:gitlab][:dbUsername]

    pgsql_user db_user do
      password node[:gitlab][:dbPassword]
    end

    pgsql_db node[:gitlab][:dbName] do
      owner db_user
    end
end


git_user = node[:gitlab][:git_user][:name]
git_home = node[:gitlab][:git_user][:home]
gitlab_version = node[:gitlab][:version]
gitlab_shell_dir = node[:gitlab][:gitlab_shell][:dir]
gitlab_shell_version = node[:gitlab][:gitlab_shell][:version]
gitlab_dir = node[:gitlab][:dir]


# Stop service gitlab if already installed
if (File.exist?("/etc/init.d/gitlab") == true)
  service "gitlab" do
    action :stop
  end
end

node[:gitlab][:dependencies].each do |pkg|
  package pkg do
    action :install
  end
end


# install bundler gem
bash "install gems" do
  code <<-eoh
    gem install bundler
    gem install charlock_holmes --version '0.6.9.4'
  eoh
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
bash "Clone gitlab-shell" do
  user git_user
  #environment ({"HOME" => "#{git_home}"})
  cwd git_home
  code <<-EOH
    [[ -d #{gitlab_shell_dir} ]] || git clone https://github.com/gitlabhq/gitlab-shell.git
    cd #{gitlab_shell_dir}
    git fetch
    git checkout -f #{gitlab_shell_version}
    cp config.yml.example config.yml
    ./bin/install
  EOH
end

bash "Clone gitlab" do
  user git_user
  cwd git_home
  code <<-EOH
    [[ -d #{gitlab_dir} ]] || git clone https://github.com/gitlabhq/gitlabhq.git gitlab
    cd #{gitlab_dir}
    git fetch
    git checkout -f #{gitlab_version}
  EOH
end

%w{ gitlab.yml puma.rb database.yml }.each do |item|
  template "#{gitlab_dir}/config/#{item}" do
    source "#{item}.erb"
    owner git_user
  end
end

bash "Change permission to let gitlab write to the log/ and tmp/ directories" do
  cwd gitlab_dir
  code <<-EOH
    chown -R #{git_user} log/
    chown -R #{git_user} tmp/
    chmod -R u+rwX log/
    chmod -R u+rwX tmp/
  EOH
end

["#{git_home}/gitlab-satellites", "#{gitlab_dir}/tmp/pids" "#{gitlab_dir}/tmp/sockets" "#{gitlab_dir}/public/uploads"].each do |dir|
  directory dir do
    owner git_user
    mode 0755
    action :create
    recursive true
  end
end

execute "bundle install" do
  cwd gitlab_dir
  command "bundle install --deployment --without development test mysql"
  action :run
end

bash "git config" do
  user git_user
  cwd git_home
  #environment ({"HOME" => git_home})
  code <<-EOH
    git config --global user.name "GitLab"
    git config --global user.email "gitlab@localhost"
  EOH
end


# Initialize DB and activate advanced features
execute "bundle exec rake gitlab:setup RAILS_ENV=production" do
  user git_user
  group git_group
  #environment ({"HOME" => git_home})
  cwd gitlab_dir
  command "yes yes | bundle exec rake gitlab:setup RAILS_ENV=production && touch .gitlab-setup"
  action :run
  not_if { File.exists?("#{gitlab_dir}/.gitlab-setup") }
end

# Update DB in case updating to newer version
execute "bundle exec rake db:migrate RAILS_ENV=production" do
  user gitlab_user
  group gitlab_group
  #environment ({"HOME" => git_home})
  cwd gitlab_dir
end

# Enable automerge
execute "bundle exec rake gitlab:enable_automerge RAILS_ENV=production" do
  user gitlab_user
  group gitlab_group
  #environment ({"HOME" => git_home})
  cwd gitlab_dir
  action :run
end

bash "Install init script" do
  code <<-EOH
    curl --output /etc/init.d/gitlab https://raw.github.com/gitlabhq/gitlabhq/master/lib/support/init.d/gitlab
    chmod +x /etc/init.d/gitlab
  EOH
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
