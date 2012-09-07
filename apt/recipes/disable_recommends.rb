#
# Cookbook Name:: apt
# Recipe:: disable_recommends
#

file '/etc/apt/apt.conf.d/disable_recommends' do
    mode '0644'
    content <<-EOH
APT::Install-Recommends "0";
APT::Install-Suggests "0";
    EOH
end
