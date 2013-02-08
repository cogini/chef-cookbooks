#
# Cookbook Name:: gitlab
# Recipe:: default
#
# Written by Nhan Nguyen
# Email: nhan@cogini.com
#

# Update
include_recipe "apt"

# Install require dependencies
include_recipe "postfix::vanilla"
include_recipe "git"
include_recipe "nginx"
include_recipe "python"
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
user node[:gitlab][:git_user][:name] do
  system true
  shell node[:gitlab][:git_user][:shell]
  comment "Git Version Control"
  home node[:gitlab][:git_user][:home]
  supports :manage_home => true
end

user node[:gitlab][:gitlab_user][:name] do
  comment "GitLab"
  home node[:gitlab][:gitlab_user][:home]
  shell node[:gitlab][:gitlab_user][:shell]
  supports :manage_home => true
end 

group node[:gitlab][:group] do
  group_name node[:gitlab][:group]
  members [ node[:gitlab][:git_user][:name], node[:gitlab][:gitlab_user][:name] ]
end

execute "ssh-keygen" do
  user node[:gitlab][:gitlab_user][:name]
  command "ssh-keygen -q -N '' -t rsa -f #{node[:gitlab][:gitlab_user][:home]}/.ssh/id_rsa"
  action :run
  not_if { File.exist?("#{node[:gitlab][:gitlab_user][:home]}/.ssh/id_rsa") }
end

# Install gitolite
bash "Copy gitlab user's SSH key" do
  code <<-EOH
    cp #{node[:gitlab][:gitlab_user][:home]}/.ssh/id_rsa.pub #{node[:gitlab][:git_user][:home]}/gitlab.pub
    chmod 0444 #{node[:gitlab][:git_user][:home]}/gitlab.pub
  EOH
  not_if { File.exist?("#{node[:gitlab][:git_user][:home]}/gitlab.pub") }
end

directory "#{node[:gitlab][:git_user][:home]}/bin" do
  owner node[:gitlab][:git_user][:name]
  group node[:gitlab][:group]
  mode 0755
  action :create
  not_if { File.exist?("#{node[:gitlab][:git_user][:home]}/bin") }
end

bash "Install gitolite" do
  user node[:gitlab][:git_user][:name]
  cwd node[:gitlab][:git_user][:home]
  group node[:gitlab][:group]
  code <<-EOH
    git clone --branch gl-v320 https://github.com/gitlabhq/gitolite.git /home/git/gitolite
    gitolite/install -ln /home/git/bin
  EOH
end

execute "Setup gitolite" do
  user node[:gitlab][:git_user][:name]
  group node[:gitlab][:group]
  cwd node[:gitlab][:git_user][:home]
  environment ({"HOME" => "#{node[:gitlab][:git_user][:home]}"})
  command "PATH=#{node[:gitlab][:git_user][:home]}/bin:$PATH; gitolite setup -pk #{node[:gitlab][:git_user][:home]}/gitlab.pub"
  action :run
end

bash "Change gitolite config dir owner to git" do
  code <<-EOH
    chmod 750 #{node[:gitlab][:git_user][:home]}/.gitolite/
    chown -R #{node[:gitlab][:git_user][:name]}:#{node[:gitlab][:group]} #{node[:gitlab][:git_user][:home]}/.gitolite
    chmod -R ug+rwXs,o-rwx #{node[:gitlab][:git_user][:home]}/repositories/
    chown -R git:git #{node[:gitlab][:git_user][:home]}/repositories/
  EOH
end

execute "Add domains to list of known hosts" do
  user node[:gitlab][:gitlab_user][:name]
  command "ssh -o StrictHostKeyChecking=no git@localhost"
  action :run
end

# Install database using Postgresql
include_recipe "postgresql::server"
pgsql_user node[:gitlab][:gitlab_user][:name] do
  password "gitlab"
end

pgsql_db "gitlab_production" do
  owner node[:gitlab][:gitlab_user][:name]
end

# Install gitlab
# Clone gitlab repo and checkout latest stable version (4.1)
bash "Checkout gitlab 4.1" do
  user node[:gitlab][:gitlab_user][:name]
  cwd node[:gitlab][:gitlab_user][:home]
  code <<-EOH
    [[ -d #{node[:gitlab][:dir]} ]] || git clone https://github.com/gitlabhq/gitlabhq.git #{node[:gitlab][:dir]}
    cd #{node[:gitlab][:dir]}
    git fetch
    git checkout 4-1-stable
  EOH
end

# Configure gitlab and gitlab DB
template "#{node[:gitlab][:dir]}/config/gitlab.yml" do
  source "gitlab.yml.erb"
  owner node[:gitlab][:gitlab_user][:name]
end

template "#{node[:gitlab][:dir]}/config/unicorn.rb" do
  source "unicorn.rb.erb"
  owner node[:gitlab][:gitlab_user][:name]
end

template "#{node[:gitlab][:dir]}/config/database.yml" do
  source "database.yml.erb"
  owner node[:gitlab][:gitlab_user][:name]
end

bash "Change permission to let gitlab write to the log/ and tmp/ directories" do
  cwd node[:gitlab][:dir]
  code <<-EOH
    chown -R #{node[:gitlab][:gitlab_user][:name]} log/
    chown -R #{node[:gitlab][:gitlab_user][:name]} tmp/
    chmod -R u+rwX log/
    chmod -R u+rwX tmp/
  EOH
end

directory "#{node[:gitlab][:gitlab_user][:home]}/gitlab-satellites" do
  owner node[:gitlab][:gitlab_user][:name]
  group node[:gitlab][:group]
  mode 0755
  action :create
  not_if { File.exists?("#{node[:gitlab][:gitlab_user][:home]}/gitlab-satellites") }
end

directory "#{node[:gitlab][:dir]}/tmp/pids" do
  owner node[:gitlab][:gitlab_user][:name]
  group node[:gitlab][:group]
  mode 0755
  action :create
  not_if { File.exists?("#{node[:gitlab][:dir]}/tmp/pids") }
end

execute "bundle install" do
  cwd node[:gitlab][:dir]
  command "bundle install --deployment --without development test mysql"
  action :run
end

bash "git config" do
  user node[:gitlab][:gitlab_user][:name]
  cwd node[:gitlab][:gitlab_user][:home]
  environment ({"HOME" => node[:gitlab][:gitlab_user][:home]})
  code <<-EOH
    git config --global user.name "GitLab"
    git config --global user.email "gitlab@localhost"
  EOH
end

# Setup gitlab hooks
bash "Setup gitlab hooks" do
  code <<-EOH
    cp #{node[:gitlab][:dir]}/lib/hooks/post-receive #{node[:gitlab][:git_user][:home]}/.gitolite/hooks/common/post-receive
    chown #{node[:gitlab][:git_user][:name]}:#{node[:gitlab][:group]} #{node[:gitlab][:git_user][:home]}/.gitolite/hooks/common/post-receive
  EOH
end

# Initialize DB and activate advanced features
execute "bundle exec rake gitlab:setup RAILS_ENV=production" do
  user node[:gitlab][:gitlab_user][:name]
  group node[:gitlab][:group]
  environment ({"HOME" => node[:gitlab][:gitlab_user][:home]})
  cwd node[:gitlab][:dir]
  command "yes yes | bundle exec rake gitlab:setup RAILS_ENV=production && touch .gitlab-setup"
  action :run
  not_if { File.exists?("#{node[:gitlab][:dir]}/.gitlab-setup") }
end

execute "bundle exec rake gitlab:enable_automerge RAILS_ENV=production" do
  user node[:gitlab][:gitlab_user][:name]
  group node[:gitlab][:group]
  environment ({"HOME" => node[:gitlab][:gitlab_user][:home]})
  cwd node[:gitlab][:dir]
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

execute "rm -R /etc/nginx/sites-enabled/default" do
  action :run
  only_if { File.exist?("/etc/nginx/sites-enabled/default") }
end

service "nginx" do
  action [ :enable, :restart ]
end
