#
# Cookbook Name:: amanda
# Recipe:: default
#

include_recipe "apt"


amanda_home = "/var/lib/amanda"
app_user = "amandabackup"
app_group = "disk"
config_dir = "/etc/amanda"
dirs = [
  node[:amanda][:dir][:backup_dir],
  node[:amanda][:dir][:holding_dir],
  node[:amanda][:dir][:index_dir],
  node[:amanda][:dir][:info_dir],
  node[:amanda][:dir][:log_dir],
  node[:amanda][:dir][:vtapes_dir]
]


node[:amanda][:dependencies].each do |pkg|
  package pkg
end


# Only support ubuntu precise for now
case node[:platform]
when "ubuntu"
  arch = node[:kernel][:machine] =~ /x86_64/ ? "amd64" : "i386"
  amanda_pkg = "amanda-backup-#{node[:amanda][:type]}_#{node[:amanda][:version]}-1Ubuntu1204_#{arch}.deb"
else
  raise ArgumentError, "Platform #{node[:platform]} not supported"
end

remote_file "/tmp/#{amanda_pkg}" do
  source "http://www.zmanda.com/downloads/community/Amanda/#{node[:amanda][:version]}/Ubuntu-12.04/#{amanda_pkg}"
  mode 0644
  not_if { File.exists?("#{amanda_home}/installed") }
end

dpkg_package amanda_pkg do
  source "/tmp/#{amanda_pkg}"
  action :install
  not_if { File.exists?("#{amanda_home}/installed") }
end

file "#{amanda_home}/installed" do
  owner app_user
  action :create_if_missing
end


# Set up amanda server
if node[:amanda][:type] == "server"
  # Fix amrecover error
  template "/usr/libexec/amanda/amidxtaped" do
    source "amidxtaped.erb"
    mode 0755
  end


  directory "#{config_dir}/Daily" do
    owner app_user
    group app_group
    mode 0750
  end

  template "#{config_dir}/Daily/disklist" do
    source "disklist-daily.erb"
    owner app_user
    group app_group
    mode 0644
  end

  template "#{config_dir}/Daily/amanda.conf" do
    source "amanda-daily.conf.erb"
    owner app_user
    group app_group
    mode 0644
  end

  dirs.each do |dir|
    directory dir do
      owner app_user
      group app_group
      mode 0755
      recursive true
    end
  end

  for i in 1..node[:amanda][:tapecycle] do
    directory "#{node[:amanda][:dir][:vtapes_dir]}/slot#{i}" do
      owner app_user
      group app_group
      mode 0755
      recursive true
    end
  end


  template "#{config_dir}/amanda-client.conf" do
    source "amanda-client.conf.erb"
    owner app_user
    group app_group
    mode 0600
  end

  cron "daily_backup" do
    hour "20"
    mailto "noc@cogini.com"
    user app_user
    command "/usr/sbin/amdump Daily"
  end
end
