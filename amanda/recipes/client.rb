#
# Cookbook Name:: amanda
# Recipe:: client
#

include_recipe 'apt'
include_recipe 'gdebi'

include_recipe 'amanda::common'


amanda = node[:amanda]
arch = node[:kernel][:machine] =~ /x86_64/ ? 'amd64' : 'i386'


if node[:platform] == 'ubuntu' and node['platform_version'].to_f == 12.04
  amanda_pkg = "amanda-backup-client_#{amanda[:version]}-1Ubuntu1204_#{arch}.deb"
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


# Set up amanda client
file "#{amanda[:key_dir]}/authorized_keys" do
  owner amanda[:app_user]
  group amanda[:app_group]
  content amanda[:pub_key]
end
