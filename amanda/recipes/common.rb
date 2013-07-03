#
# Cookbook Name:: amanda
# Recipe:: common
#

amanda = node[:amanda]

directory "#{amanda[:home]}/.ssh" do
    owner amanda[:app_user]
    recursive true
end
