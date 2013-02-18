#
# Cookbook Name:: gitlab
# Recipe:: default
#
# Written by Nhan Nguyen
# Email: nhan@cogini.com
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
git_bin_dir = "#{git_home}/bin"
gitlab_user = node[:gitlab][:gitlab_user][:name]
gitlab_home = node[:gitlab][:gitlab_user][:home]
gitlab_group = node[:gitlab][:group]
gitlab_dir = node[:gitlab][:dir]


node[:gitlab][:dependencies].each do |pkg|
  package pkg do
    action :install
  end
end


# Install bundler gem
bash "install gems" do
  code <<-EOH
    gem install bundler
    gem install charlock_holmes --version '0.6.9'
  EOH
end


# Create users for Git and Gitolite
user git_user do
  system true
  shell node[:gitlab][:git_user][:shell]
  comment "Git Version Control"
  home git_home
  supports :manage_home => true
end

user gitlab_user do
  comment "GitLab"
  home gitlab_home
  shell node[:gitlab][:gitlab_user][:shell]
  supports :manage_home => true
end

group gitlab_group do
  group_name gitlab_group
  members [
    git_user,
    gitlab_user
  ]
end


execute "ssh-keygen" do
  user gitlab_user
  command "ssh-keygen -q -N '' -t rsa -f #{gitlab_home}/.ssh/id_rsa"
  action :run
  not_if { File.exist?("#{gitlab_home}/.ssh/id_rsa") }
end


# Install gitolite
bash "Copy gitlab user's SSH key" do
  code <<-EOH
    cp #{gitlab_home}/.ssh/id_rsa.pub #{git_home}/gitlab.pub
    chmod 0444 #{git_home}/gitlab.pub
  EOH
  not_if { File.exist?("#{git_home}/gitlab.pub") }
end

directory git_bin_dir do
  owner git_user
  group gitlab_group
  mode 0755
  action :create
  recursive true
end

gitolite_path = "/home/git/gitolite"
bash "Install gitolite" do
  user git_user
  cwd git_home
  group gitlab_group
  code <<-EOH
    [[ -d #{gitolite_path} ]] || git clone https://github.com/gitlabhq/gitolite.git #{gitolite_path}
    cd #{gitolite_path}
    git fetch
    git checkout gl-v320
    ./install -ln #{git_bin_dir}
  EOH
end

execute "Setup gitolite" do
  user git_user
  group gitlab_group
  cwd git_home
  environment ({"HOME" => "#{git_home}"})
  command "PATH=#{git_bin_dir}:$PATH; gitolite setup -pk #{git_home}/gitlab.pub"
  action :run
end

bash "Change gitolite config dir owner to git" do
  code <<-EOH
    chmod 750 #{git_home}/.gitolite/
    chown -R #{git_user}:#{gitlab_group} #{git_home}/.gitolite
    chmod -R ug+rwXs,o-rwx #{git_home}/repositories/
    chown -R git:git #{git_home}/repositories/
  EOH
end


execute "Add domains to list of known hosts" do
  user gitlab_user
  command "ssh -o StrictHostKeyChecking=no git@localhost"
  action :run
end


# Install gitlab
# Clone gitlab repo and checkout latest stable version (4.1)
bash "Checkout gitlab 4.1" do
  user gitlab_user
  cwd gitlab_home
  code <<-EOH
    [[ -d #{gitlab_dir} ]] || git clone https://github.com/gitlabhq/gitlabhq.git #{gitlab_dir}
    cd #{gitlab_dir}
    git fetch
    git checkout 4-1-stable
  EOH
end

%w{ gitlab.yml unicorn.rb database.yml }.each do |item|
  template "#{gitlab_dir}/config/#{item}" do
    source "#{item}.erb"
    owner gitlab_user
  end
end

bash "Change permission to let gitlab write to the log/ and tmp/ directories" do
  cwd gitlab_dir
  code <<-EOH
    chown -R #{gitlab_user} log/
    chown -R #{gitlab_user} tmp/
    chmod -R u+rwX log/
    chmod -R u+rwX tmp/
  EOH
end

["#{gitlab_home}/gitlab-satellites", "#{gitlab_dir}/tmp/pids"].each do |dir|
  directory "#{gitlab_home}/gitlab-satellites" do
    owner gitlab_user
    group gitlab_group
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
  user gitlab_user
  cwd gitlab_home
  environment ({"HOME" => gitlab_home})
  code <<-EOH
    git config --global user.name "GitLab"
    git config --global user.email "gitlab@localhost"
  EOH
end

# Setup gitlab hooks
bash "Setup gitlab hooks" do
  code <<-EOH
    cp #{gitlab_dir}/lib/hooks/post-receive #{git_home}/.gitolite/hooks/common/post-receive
    chown #{git_user}:#{gitlab_group} #{git_home}/.gitolite/hooks/common/post-receive
  EOH
end

# Initialize DB and activate advanced features
execute "bundle exec rake gitlab:setup RAILS_ENV=production" do
  user gitlab_user
  group gitlab_group
  environment ({"HOME" => gitlab_home})
  cwd gitlab_dir
  command "yes yes | bundle exec rake gitlab:setup RAILS_ENV=production && touch .gitlab-setup"
  action :run
  not_if { File.exists?("#{gitlab_dir}/.gitlab-setup") }
end

execute "bundle exec rake gitlab:enable_automerge RAILS_ENV=production" do
  user gitlab_user
  group gitlab_group
  environment ({"HOME" => gitlab_home})
  cwd gitlab_dir
  action :run
end

# Install init script and make gitlab start on boot
template "/etc/init.d/gitlab" do
  source "gitlab.erb"
  mode 0755
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
