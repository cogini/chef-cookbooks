#
# Cookbook Name:: amanda
# Recipe:: client
#

amanda = node[:amanda]


if node[:platform] == 'ubuntu'

  include_recipe 'apt'
  include_recipe 'gdebi'

  arch = node[:kernel][:machine] =~ /x86_64/ ? 'amd64' : 'i386'
  version_without_dot = node[:platform_version].to_s.delete '.'
  amanda_pkg = "amanda-backup-client_#{amanda[:version]}-1Ubuntu#{version_without_dot}_#{arch}.deb"
  package_url = "http://www.zmanda.com/downloads/community/Amanda/#{amanda[:version]}/Ubuntu-#{node[:platform_version]}/#{amanda_pkg}"

elsif node[:platform] == 'centos'
  arch = node[:kernel][:machine] =~ /x86_64/ ? 'x86_64' : 'i686'
  amanda_pkg = "amanda-backup_client-#{amanda[:version]}-1.rhel#{node[:platform_version].split(".")[0]}.#{arch}.rpm"
  package_url = "http://www.zmanda.com/downloads/community/Amanda/#{amanda[:version]}/Redhat_Enterprise_#{node[:platform_version]}/#{amanda_pkg}"

else
  raise NotImplementedError
end

pkg_file = "#{Chef::Config[:file_cache_path]}/#{amanda_pkg}"

remote_file pkg_file do
  source package_url
  action :create_if_missing
end


if node[:platform] == 'ubuntu'
  gdebi_package amanda_pkg do
    source pkg_file
    action :install
  end

elsif node[:platform] == 'centos'
  package "amanda-backup-client" do
    source pkg_file
    version amanda[:version]
  end

else
  raise NotImplementedError
end


include_recipe 'amanda::common'


# Set up amanda client
file "#{amanda[:home]}/.ssh/authorized_keys" do
  owner amanda[:app_user]
  group amanda[:app_group]
  content amanda[:pub_key]
end
