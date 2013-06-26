#
# Cookbook Name:: amanda
# Recipe:: common
#

amanda = node[:amanda]

directory amanda[:key_dir] do
    owner amanda[:app_user]
    recursive true
end
