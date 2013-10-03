#
# Cookbook Name:: amanda
# Recipe:: client
#

amanda = node[:amanda]

package_from_url amanda[:package_url]
include_recipe 'amanda::common'

file "#{amanda[:home]}/.ssh/authorized_keys" do
  owner amanda[:app_user]
  group amanda[:app_group]
  content amanda[:pub_key]
end
