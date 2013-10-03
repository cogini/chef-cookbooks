#
# Cookbook Name:: amanda
# Recipe:: client
#


case node[:platform]
when "ubuntu"
  include_recipe "amanda::client_ubuntu"
when "centos", "redhat"
  include_recipe "amanda::client_redhat"
else
  raise NotImplementedError
end
