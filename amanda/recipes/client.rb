#
# Cookbook Name:: amanda
# Recipe:: client
#

include_recipe 'apt'
include_recipe 'gdebi'


amanda = node[:amanda]
arch = node[:kernel][:machine] =~ /x86_64/ ? 'amd64' : 'i386'


if node[:platform] == 'ubuntu'
  version_without_dot = node[:platform_version].to_s.delete '.'
  amanda_pkg = "amanda-backup-client_#{amanda[:version]}-1Ubuntu#{version_without_dot}_#{arch}.deb"
  package_url = "http://www.zmanda.com/downloads/community/Amanda/#{amanda[:version]}/Ubuntu-#{node[:platform_version]}/#{amanda_pkg}"
else
  raise NotImplementedError
end

pkg_file = "#{Chef::Config[:file_cache_path]}/#{amanda_pkg}"

remote_file pkg_file do
  source package_url
  action :create_if_missing
end

gdebi_package amanda_pkg do
  source pkg_file
  action :install
end


include_recipe 'amanda::common'


# Set up amanda client
file "#{amanda[:home]}/.ssh/authorized_keys" do
  owner amanda[:app_user]
  group amanda[:app_group]
  content amanda[:pub_key]
end
