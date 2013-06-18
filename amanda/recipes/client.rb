#
# Cookbook Name:: amanda
# Recipe:: default
#

include_recipe "apt"


amanda = node[:amanda]
amanda_home = "/var/lib/amanda"
key_dir = amanda[:key_dir]
app_user = amanda[:app_user]
app_group = "disk"
config_dir = "/etc/amanda"
dirs = [
  amanda[:dir][:backup_dir],
  amanda[:dir][:holding_dir],
  amanda[:dir][:index_dir],
  amanda[:dir][:info_dir],
  amanda[:dir][:log_dir],
  amanda[:dir][:vtapes_dir],
  amanda[:tape][:part_cache_dir]
]


amanda[:dependencies].each do |pkg|
  package pkg
end


# Only support ubuntu precise for now
case node[:platform]
when "ubuntu"
  arch = node[:kernel][:machine] =~ /x86_64/ ? "amd64" : "i386"
  amanda_pkg = "amanda-backup-client_#{amanda[:version]}-1Ubuntu1204_#{arch}.deb"
else
  raise NotImplementedError, "Platform #{node[:platform]} not supported"
end

remote_file "/tmp/#{amanda_pkg}" do
  source "http://www.zmanda.com/downloads/community/Amanda/#{amanda[:version]}/Ubuntu-12.04/#{amanda_pkg}"
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


# Set up amanda client
file "#{key_dir}/authorized_keys" do
  owner app_user
  group app_group
  content amanda[:pub_key]
end
