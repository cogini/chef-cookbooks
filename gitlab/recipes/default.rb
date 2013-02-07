#
# Cookbook Name:: gitlab
# Recipe:: default
#
# Written by Nhan Nguyen
# Email: nhan@cogini.com
#

# Update
execute "apt-get update"

# Install require dependencies
include_recipe "postfix::vanilla"
include_recipe "git"
node[:gitlab][:dependencies].each do |pkg|
  package pkg do
    action :install
  end
end

# Install bundler gem
execute "gem install bundler"

# Create users for Git and Gitolite
user node[:user][:git][:name] do
  system true
  shell node[:user][:git][:shell]
  comment "Git Version Control"
  home node[:user][:git][:home]
  supports :manage_home => true
end

user node[:user][:gitlab][:name] do
  comment "GitLab"
  home node[:user][:gitlab][:home]
  shell node[:user][:gitlab][:shell]
  supports :manage_home => true
end 

group node[:user][:group] do
  group_name node[:user][:group]
  members [ node[:user][:git][:name], node[:user][:gitlab][:name] ]
end

execute "ssh-keygen" do
  user node[:user][:gitlab][:name]
  command "ssh-keygen -q -N '' -t rsa -f /home/gitlab/.ssh/id_rsa"
  action :run
  not_if { File.exist?("/home/gitlab/.ssh/id_rsa") }
end

# Install gitolite
bash "Copy gitlab user's SSH key" do
  code <<-EOH
    cp /home/gitlab/.ssh/id_rsa.pub /home/git/gitlab.pub
    chmod 0444 /home/git/gitlab.pub
  EOH
  not_if { File.exist?("/home/git/gitlab.pub") }
end

directory "/home/git/bin" do
  owner node[:user][:git][:name]
  group node[:user][:group]
  mode 0755
  action :create
  not_if { File.exist?("/home/git/bin") }
end

bash "Install gitolite" do
  user node[:user][:git][:name]
  cwd node[:user][:git][:home]
  group node[:user][:group]
  code <<-EOH
    git clone -b gl-v320 https://github.com/gitlabhq/gitolite.git /home/git/gitolite
    printf "%b\n%b\n" "PATH=\$PATH:/home/git/bin" "export PATH" >> /home/git/.profile
    gitolite/install -ln /home/git/bin
  EOH
end

execute "Setup gitolite" do
  user node[:user][:git][:name]
  group node[:user][:group]
  cwd node[:user][:git][:home]
  environment ({'HOME' => '/home/git'})
  command "PATH=/home/git/bin:$PATH; gitolite setup -pk /home/git/gitlab.pub"
  action :run
end

bash "Change gitolite config dir owner to git" do
  code <<-EOH
    chmod 750 /home/git/.gitolite/
    chown -R git:git /home/git/.gitolite
    chmod -R ug+rwXs,o-rwx /home/git/repositories/
    chown -R git:git /home/git/repositories/
  EOH
end

execute "Add domains to list of known hosts" do
  user node[:user][:gitlab][:name]
  command "ssh -o StrictHostKeyChecking=no git@localhost"
  action :run
end

# Install database using Postgresql
include_recipe "postgresql::server"
pgsql_user "gitlab" do
  password "gitlab"
end

pgsql_db "gitlab_production" do
  owner "gitlab"
end

# Install gitlab
# Clone gitlab repo and checkout latest stable version (4.1)
bash "Checkout gitlab 4.1" do
  user node[:user][:gitlab][:name]
  cwd node[:user][:gitlab][:home]
  code <<-EOH
    [[ -d /home/gitlab/gitlab ]] || git clone https://github.com/gitlabhq/gitlabhq.git /home/gitlab/gitlab
    cd /home/gitlab/gitlab
    git fetch
    git checkout 4-1-stable
  EOH
end

# Configure gitlab and gitlab DB
template "/home/gitlab/gitlab/config/gitlab.yml" do
  source "gitlab.yml.erb"
  owner node[:user][:gitlab][:name]
end

template "/home/gitlab/gitlab/config/unicorn.rb" do
  source "unicorn.rb.erb"
  owner node[:user][:gitlab][:name]
end

template "/home/gitlab/gitlab/config/database.yml" do
  source "database.yml.erb"
  owner node[:user][:gitlab][:name]
end

bash "Change permission to let gitlab write to the log/ and tmp/ directories" do
  cwd "/home/gitlab/gitlab"
  code <<-EOH
    chown -R gitlab log/
    chown -R gitlab tmp/
    chmod -R u+rwX log/
    chmod -R u+rwX tmp/
  EOH
end

directory "/home/gitlab/gitlab-satellites" do
  owner node[:user][:gitlab][:name]
  group node[:user][:group]
  mode 0755
  action :create
  not_if { File.exists?("/home/gitlab/gitlab-satellites") }
end

directory "/home/gitlab/gitlab/tmp/pids" do
  owner node[:user][:gitlab][:name]
  group node[:user][:group]
  mode 0755
  action :create
  not_if { File.exists?("/home/gitlab/gitlab/tmp/pids") }
end

# Install gems
execute "gem install charlock_holmes --version '0.6.9'"

execute "bundle install" do
  cwd "/home/gitlab/gitlab"
  command "bundle install --deployment --without development test mysql"
  action :run
end

bash "git config" do
  user node[:user][:gitlab][:name]
  cwd node[:user][:gitlab][:home]
  environment ({'HOME' => '/home/gitlab'})
  code <<-EOH
    git config --global user.name "GitLab"
    git config --global user.email "gitlab@localhost"
  EOH
end

# Setup gitlab hooks
bash "Setup gitlab hooks" do
  code <<-EOH
    cp /home/gitlab/gitlab/lib/hooks/post-receive /home/git/.gitolite/hooks/common/post-receive
    chown git:git /home/git/.gitolite/hooks/common/post-receive
  EOH
  not_if { File.exist?("/home/git/.gitolite/hooks/common/post-receive") }
end

# Initialize DB and activate advanced features
execute "bundle exec rake gitlab:setup RAILS_ENV=production" do
  user node[:user][:gitlab][:name]
  group node[:user][:group]
  environment ({'HOME' => '/home/gitlab'})
  cwd "/home/gitlab/gitlab"
  command "yes yes | bundle exec rake gitlab:setup RAILS_ENV=production && touch .gitlab-setup"
  action :run
  not_if { File.exists?("/home/gitlab/gitlab/.gitlab-setup") }
end

execute "bundle exec rake gitlab:enable_automerge RAILS_ENV=production" do
  user node[:user][:gitlab][:name]
  group node[:user][:group]
  environment ({'HOME' => '/home/gitlab'})
  cwd "/home/gitlab/gitlab"
  action :run
end

# Install init script and make gitlab start on boot
template "/etc/init.d/gitlab" do
  source "gitlab.erb"
  mode 0755
end

service "gitlab" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start]
end

# Config nginx
template "/etc/nginx/sites-available/gitlab" do
  source "nginx-gitlab.erb"
end

execute "ln -s /etc/nginx/sites-available/gitlab /etc/nginx/sites-enabled/gitlab" do
  action :run
  not_if { File.exists?("/etc/nginx/sites-enabled/gitlab") }
end

execute "rm -R /etc/nginx/sites-enabled/default" do
  action :run
  only_if { File.exist?("/etc/nginx/sites-enabled/default") }
end

service "nginx" do
  action [ :enable, :restart]
end
