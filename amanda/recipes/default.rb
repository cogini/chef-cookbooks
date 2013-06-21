#
# Cookbook Name:: amanda
# Recipe:: default
#

include_recipe 'apt'
include_recipe 'gdebi'


amanda = node[:amanda]
key_dir = amanda[:key_dir]
app_user = amanda[:app_user]
app_group = amanda[:app_group]
config_dir = '/etc/amanda'
arch = node[:kernel][:machine] =~ /x86_64/ ? 'amd64' : 'i386'


if node[:platform] == 'ubuntu' and node['platform_version'].to_f == 12.04
  amanda_pkg = "amanda-backup-server_#{amanda[:version]}-1Ubuntu1204_#{arch}.deb"
  pkg_file = "#{Chef::Config[:file_cache_path]}/#{amanda_pkg}"
else
  raise NotImplementedError
end


remote_file pkg_file do
  source "http://www.zmanda.com/downloads/community/Amanda/#{amanda[:version]}/Ubuntu-12.04/#{amanda_pkg}"
  action :create_if_missing
end

gdebi_package amanda_pkg do
  source pkg_file
  action :install
end


# Fix amrecover error
template '/usr/libexec/amanda/amidxtaped' do
  source 'amidxtaped.erb'
  mode 0755
end


[
  amanda[:dir][:holding_dir],
  amanda[:dir][:index_dir],
  amanda[:dir][:info_dir],
  amanda[:dir][:log_dir],
  amanda[:dir][:vtapes_dir],
].each do |dir|
  directory dir do
    owner app_user
    group app_group
    mode 0755
    recursive true
  end
end

for i in 1..amanda[:tapecycle] do
  directory "#{amanda[:dir][:vtapes_dir]}/slot#{i}" do
    owner app_user
    group app_group
    mode 0755
    recursive true
  end
end


template "#{config_dir}/amanda-client.conf" do
  source 'amanda-client.conf.erb'
  owner app_user
  group app_group
  mode 0600
end


template "#{key_dir}/config" do
  owner app_user
  group app_group
  source 'ssh-config.erb'
  mode 0644
end

execute 'Generate ssh key' do
  user app_user
  command "ssh-keygen -q -N '' -t rsa -f #{key_dir}/id_rsa"
  not_if { File.exists?("#{key_dir}/id_rsa") }
end


amanda[:backup_locations].each do |client|

  execute "Add #{client[:hostname]} to list of known hosts" do
    user app_user
    command "ssh -o StrictHostKeyChecking=no #{client[:hostname]}"
    ignore_failure true
  end
end


# Daily backups

directory "#{config_dir}/Daily" do
  owner app_user
  group app_group
  mode 0750
end

template "#{config_dir}/Daily/disklist" do
  source 'disklist-daily.erb'
  owner app_user
  group app_group
  mode 0640
end

template "#{config_dir}/Daily/amanda.conf" do
  source 'amanda-daily.conf.erb'
  owner app_user
  group app_group
  mode 0640
end

cron 'daily_backup' do
  hour '20'
  mailto 'noc@cogini.com'
  user app_user
  command '/usr/sbin/amdump Daily'
end
