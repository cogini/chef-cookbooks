#
# Cookbook Name:: amanda
# Recipe:: client_redhat
#

amanda = node[:amanda]

arch = node[:kernel][:machine] =~ /x86_64/ ? 'x86_64' : 'i686'
amanda_pkg = "amanda-backup_client-#{amanda[:version]}-1.rhel#{node[:platform_version].to_i}.#{arch}.rpm"
package_url = "http://www.zmanda.com/downloads/community/Amanda/#{amanda[:version]}/Redhat_Enterprise_#{node[:platform_version]}/#{amanda_pkg}"


pkg_file = "#{Chef::Config[:file_cache_path]}/#{amanda_pkg}"


remote_file pkg_file do
  source package_url
  action :create_if_missing
end

package "amanda-backup-client" do
    source pkg_file
    version amanda[:version]
end


include_recipe 'amanda::common'


# Set up amanda client
file "#{amanda[:home]}/.ssh/authorized_keys" do
  owner amanda[:app_user]
  group amanda[:app_group]
  content amanda[:pub_key]
end
